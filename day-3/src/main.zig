const std = @import("std");
const file = @embedFile("./inputs/input2.txt");
const mem = std.mem;
const fmt = std.fmt;

const MulDisabler = "don't()";
const MulEnabler = "do()";
const MulStartString = "mul(";
const DigitsSeparator = ",";
const MulEndString = ")";

fn parseMulExpression(line: []const u8) ?u32 {
    if (!mem.startsWith(u8, line, MulStartString)) return null;
    if (!mem.endsWith(u8, line, MulEndString)) return null;

    const inner = line[MulStartString.len .. line.len - MulEndString.len];

    var parts = mem.split(u8, inner, DigitsSeparator);

    if (parts.peek() == null) return null;
    const firstOperator = parseOperand(parts.next().?);

    if (parts.peek() == null) return null;
    const secondOperator = parseOperand(parts.next().?);

    if (parts.next() != null or secondOperator == null or firstOperator == null) return null;

    return firstOperator.? * secondOperator.?;
}

fn parseOperand(part: []const u8) ?u32 {
    return fmt.parseUnsigned(u32, part, 10) catch null;
}

fn extractValidExpressions(allocator: mem.Allocator, input: []const u8) !std.ArrayList([]const u8) {
    var validExpressions = std.ArrayList([]const u8).init(allocator);
    var absoluteIndex: usize = 0;
    var disablerIndex: ?usize = null;

    while (absoluteIndex < input.len) {
        disablerIndex = mem.indexOf(u8, input[absoluteIndex..], MulDisabler) orelse null;
        const start = mem.indexOf(u8, input[absoluteIndex..], MulStartString) orelse break;
        var end = absoluteIndex + start + MulStartString.len;

        if (disablerIndex != null and start >= disablerIndex.?) {
            const enablerIndex = mem.indexOf(u8, input[absoluteIndex + disablerIndex.? + MulDisabler.len ..], MulEnabler) orelse break;

            absoluteIndex = absoluteIndex + disablerIndex.? + MulDisabler.len + MulEnabler.len + enablerIndex;
            continue;
        } else {
            while (end < input.len) {
                if (input[end] == ')') {
                    const expression = input[absoluteIndex + start .. end + 1];
                    if (parseMulExpression(expression) != null) {
                        try validExpressions.append(expression);
                    }
                    break;
                }
                end += 1;
            }
            absoluteIndex = absoluteIndex + start + 1;
        }
    }

    return validExpressions;
}

pub fn main() !void {
    const input = file;
    const allocator = std.heap.page_allocator;

    var validExpressions = try extractValidExpressions(allocator, input);
    defer validExpressions.deinit();
    var sum: u32 = 0;

    for (validExpressions.items) |expr| {
        const result = parseMulExpression(expr);
        if (result != null) {
            sum = sum + result.?;
        }
    }

    std.debug.print("Total: {d}\n", .{sum});
}

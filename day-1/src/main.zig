const std = @import("std");
const mem = std.mem;

const file = @embedFile("./inputs/input2.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var lines = mem.split(u8, file, "\n");
    var linesCount: u16 = 0;

    var left = std.ArrayList(u32).init(allocator);
    defer left.deinit();

    var right = std.ArrayList(u32).init(allocator);
    defer right.deinit();

    var similarityNumbersMapping = std.AutoHashMap(u32, u32).init(allocator);
    defer similarityNumbersMapping.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var contentTuple = mem.split(u8, line, "   ");

        if (contentTuple.next()) |first| {
            const parsedNumber = try parseNumber(first); 
            try left.append(parsedNumber);

        }

        if (contentTuple.next()) |second| {
            const parsedNumber = try parseNumber(second);
            try right.append(parsedNumber);

            if(similarityNumbersMapping.get(parsedNumber)) |oldValue| {
                try similarityNumbersMapping.put(parsedNumber, oldValue + 1);
            } else {
                try similarityNumbersMapping.put(parsedNumber, 1);
            }
        }

        linesCount = linesCount + 1;
    }
    
    mem.sort(u32, left.items, {}, std.sort.asc(u32));
    mem.sort(u32, right.items, {}, std.sort.asc(u32));

    var total: u32 = 0;
    var totalSimilarityNumbers: u32 = 0;

    for(0..linesCount) |i| {
        const leftValue = left.items[i];
        const rightValue = right.items[i];

        if(leftValue < rightValue) {
            total = total + (rightValue - leftValue);
        } else {
            total = total + (leftValue - rightValue);
        }


        if(similarityNumbersMapping.get(leftValue)) |timesRepeated| {
            totalSimilarityNumbers = totalSimilarityNumbers + (leftValue * timesRepeated);
        }
    }

    std.debug.print("Total sum of distances: {d}\n", .{total});
    std.debug.print("Total similarity numbers: {}\n", .{totalSimilarityNumbers});
}

fn parseNumber(string: []const u8) !u32 {
    return try std.fmt.parseUnsigned(u32, string, 10);
}


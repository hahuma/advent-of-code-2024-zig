const std = @import("std");
const file = @embedFile("./inputs/input2.txt");
const fmt = std.fmt;
const mem = std.mem;

const Direction = enum {
    ASC,
    DESC,
};

fn isOnSameDirection(prevValue: u32, nextValue: u32, direction: Direction) bool {
    const isIncreasing = direction == .ASC and prevValue < nextValue;
    const isDecreasing = direction == .DESC and prevValue > nextValue;

    return isIncreasing or isDecreasing;
}

fn isOnAllowedRange(prevValue: u32, nextValue: u32) bool {
    const highDifference: u32 = if (nextValue > prevValue)
        nextValue - prevValue
    else
        prevValue - nextValue;

    const maxDifferenceAllowed: u2 = 3;
    const minDifferenceAllowed: u1 = 1;
    return highDifference >= minDifferenceAllowed and highDifference <= maxDifferenceAllowed;
}

pub fn main() !void {
    var lines = mem.split(u8, file, "\n");

    var totalSafe: u32 = 0;
    var totalNotTolerated: u32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var numbers = mem.split(u8, line, " ");
        var prevNumber: ?u32 = null;
        var backupNumber: ?u32 = null;
        var currDirection: ?Direction = null;
        var isOnToleranceValue: bool = true;
        var hasFailedOnce: bool = false;
        var isSafe: bool = true;
        var isSafeNoTolerations: bool = true;

        numbersWhile: while (numbers.next()) |number| {
            const currNumber = try fmt.parseUnsigned(u32, number, 10);

            if (prevNumber == null) {
                prevNumber = currNumber;
                continue;
            }

            if (currDirection == null and prevNumber != null) {
                if (currNumber > prevNumber.?) {
                    currDirection = Direction.ASC;
                } else {
                    currDirection = Direction.DESC;
                }
            }

            if (currDirection != null and prevNumber != null) {
                if (isOnAllowedRange(prevNumber.?, currNumber) and
                    isOnSameDirection(prevNumber.?, currNumber, currDirection.?))
                {
                    backupNumber = prevNumber;
                    prevNumber = currNumber;
                    continue;
                } else {
                    if (!hasFailedOnce) {
                        hasFailedOnce = true;
                        isSafeNoTolerations = false;
                    }
                }
            }

            if (numbers.peek()) |next| {
                const nextParsed = try fmt.parseUnsigned(u32, next, 10);
                if (isOnAllowedRange(prevNumber.?, nextParsed) and
                    isOnSameDirection(prevNumber.?, nextParsed, currDirection.?) and
                    isOnToleranceValue)
                {
                    prevNumber = backupNumber;
                    isOnToleranceValue = false;
                    continue;
                } else {
                    isSafe = false;
                    break :numbersWhile;
                }
            }
        }

        if (isSafe) {
            totalSafe = totalSafe + 1;
        }

        if (isSafeNoTolerations) {
            totalNotTolerated = totalNotTolerated + 1;
        }
    }

    std.debug.print("Total Safe: {d}\n", .{totalSafe});
    std.debug.print("Total Safe Without Tolerance: {}\n", .{totalNotTolerated});
}

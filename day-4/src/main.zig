const std = @import("std");
const mem = std.mem;

const xmas = "XMAS";

pub fn main() !void {
    const file = @embedFile("./inputs/input2.txt");
    const allocator = std.heap.page_allocator;

    var linesList = std.ArrayList([]const u8).init(allocator);
    defer linesList.deinit();

    var splitIter = mem.split(u8, file, "\n");
    while (splitIter.next()) |line| {
        try linesList.append(line);
    }

    const lines = linesList.items;
    var totalCount: u32 = 0;

    var row: usize = 0;
    while (row < lines.len) : (row += 1) {
        const line = lines[row];
        var col: usize = 0;
        while (col < line.len) : (col += 1) {
            totalCount += countOccurrences(lines, row, col, xmas);
        }
    }

    std.debug.print("Total Count: {}\n", .{totalCount});
}

fn countOccurrences(grid: [][]const u8, row: usize, col: usize, word: []const u8) u32 {
    const directions = [_]Direction{
        Direction{ .dx = 0, .dy = 1 },
        Direction{ .dx = 0, .dy = -1 },
        Direction{ .dx = 1, .dy = 0 },
        Direction{ .dx = -1, .dy = 0 },
        Direction{ .dx = 1, .dy = 1 },
        Direction{ .dx = 1, .dy = -1 },
        Direction{ .dx = -1, .dy = 1 },
        Direction{ .dx = -1, .dy = -1 },
    };

    var count: u32 = 0;

    for (directions) |dir| {
        if (checkDirection(grid, row, col, word, dir)) {
            count += 1;
        }
    }

    return count;
}

fn checkDirection(grid: [][]const u8, row: usize, col: usize, word: []const u8, dir: Direction) bool {
    var k: isize = 0;
    while (k < word.len) : (k += 1) {
        const rowIsize: isize = @intCast(row);
        const colIsize: isize = @intCast(col);
        const newRow:isize = @intCast(rowIsize + dir.dx * k);
        const newCol:isize = @intCast(colIsize + dir.dy * k);

        if (newRow < 0 or newCol < 0) return false;

        const usizeRow: usize = @intCast(newRow);
        const usizeCol: usize = @intCast(newCol);

        if (usizeRow >= grid.len or usizeCol >= grid[usizeRow].len) return false;
        const usizeK: usize = @intCast(k);

        if (grid[usizeRow][usizeCol] != word[usizeK]) return false;
    }
    return true;
}

const Direction = struct {
    dx: isize,
    dy: isize,
};


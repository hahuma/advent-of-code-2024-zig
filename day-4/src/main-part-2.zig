const std = @import("std");

const input = @embedFile("./inputs/input2.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var grid = std.ArrayList([]const u8).init(allocator);
    defer _ = grid.deinit();

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        try grid.append(line);
    }

    var n_masmas: i32 = 0;
    var n_massam: i32 = 0;
    var n_sammas: i32 = 0;
    var n_samsam: i32 = 0;

    for (grid.items[0 .. grid.items.len - 2], 0..) |row, irow| {
        for (row[0 .. row.len - 2], 0..) |_, icol| {
            if (is_masmas(grid, irow, icol)) {
                n_masmas += 1;
            }
            if (is_massam(grid, irow, icol)) {
                n_massam += 1;
            }
            if (is_sammas(grid, irow, icol)) {
                n_sammas += 1;
            }
            if (is_samsam(grid, irow, icol)) {
                n_samsam += 1;
            }
        }
    }

    const n_total_xmas = n_masmas + n_massam + n_sammas + n_samsam;

    std.debug.print("\nCount of \"X-MAS\": {d}\n", .{n_total_xmas});
}

fn is_masmas(grid: std.ArrayList([]const u8), irow: usize, icol: usize) bool {
    if (grid.items[irow + 0][icol + 0] == 'M' and
        grid.items[irow + 1][icol + 1] == 'A' and
        grid.items[irow + 2][icol + 2] == 'S' and
        grid.items[irow + 2][icol + 0] == 'M' and
        grid.items[irow + 0][icol + 2] == 'S')
    {
        return true;
    }
    return false;
}
fn is_massam(grid: std.ArrayList([]const u8), irow: usize, icol: usize) bool {
    if (grid.items[irow + 0][icol + 0] == 'M' and
        grid.items[irow + 1][icol + 1] == 'A' and
        grid.items[irow + 2][icol + 2] == 'S' and
        grid.items[irow + 2][icol + 0] == 'S' and
        grid.items[irow + 0][icol + 2] == 'M')
    {
        return true;
    }
    return false;
}
fn is_sammas(grid: std.ArrayList([]const u8), irow: usize, icol: usize) bool {
    if (grid.items[irow + 0][icol + 0] == 'S' and
        grid.items[irow + 1][icol + 1] == 'A' and
        grid.items[irow + 2][icol + 2] == 'M' and
        grid.items[irow + 2][icol + 0] == 'M' and
        grid.items[irow + 0][icol + 2] == 'S')
    {
        return true;
    }
    return false;
}
fn is_samsam(grid: std.ArrayList([]const u8), irow: usize, icol: usize) bool {
    if (grid.items[irow + 0][icol + 0] == 'S' and
        grid.items[irow + 1][icol + 1] == 'A' and
        grid.items[irow + 2][icol + 2] == 'M' and
        grid.items[irow + 2][icol + 0] == 'S' and
        grid.items[irow + 0][icol + 2] == 'M')
    {
        return true;
    }
    return false;
}

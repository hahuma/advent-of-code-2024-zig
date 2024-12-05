const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_part1 = b.addExecutable(.{
        .name = "day-4",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe_part1);

    const run_cmd_part1 = b.addRunArtifact(exe_part1);
    run_cmd_part1.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd_part1.addArgs(args);
    }

    const run_step_part1 = b.step("run-part-1", "Run the Part 1 app");
    run_step_part1.dependOn(&run_cmd_part1.step);

    const exe_part2 = b.addExecutable(.{
        .name = "day-4-part-2",
        .root_source_file = b.path("src/main-part-2.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe_part2);

    const run_cmd_part2 = b.addRunArtifact(exe_part2);
    run_cmd_part2.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd_part2.addArgs(args);
    }

    const run_step_part2 = b.step("run-part-2", "Run the Part 2 app");
    run_step_part2.dependOn(&run_cmd_part2.step);
}


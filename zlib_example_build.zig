const std = @import("std");
const Build = std.Build;
const Compile = Build.Step.Compile;

pub const Example = struct {
    compile: *Compile,
};

pub fn create(b: *Build, target: Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) Example {
    const bin = b.addExecutable(.{
        .name = "example1",
        .root_source_file = b.path("example/example1.zig"),
        .target = target,
        .optimize = optimize,
    });

    return Example{ .compile = bin };
}

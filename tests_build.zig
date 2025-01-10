const std = @import("std");
const Build = std.Build;

pub const Tester = struct {
    compile: *std.Build.Step.Compile,
};

pub fn create(b: *Build, target: Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) Tester {
    const exe = b.addTest(.{
        .name = "test_zlib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(b.path("zlib"));
    return Tester{ .compile = exe };
}

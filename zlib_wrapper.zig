const std = @import("std");
const Step = std.Build.Step;
const Build = std.Build;
const Compile = Step.Compile;
const Self = @This();

const package_path = "src/main.zig";
pub const include_dir = "zlib";

pub const ZigLibrary = struct {
    compile: *Compile,

    pub fn link(self: ZigLibrary, b: *Build, other: *Compile) void {
        other.addIncludePath(b.path("src"));
        other.linkLibrary(self.compile);
    }
};

pub fn create(b: *Build, target: Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) ZigLibrary {
    const lib = b.addStaticLibrary(.{ .name = "zlib", .target = target, .optimize = optimize, .root_source_file = b.path("src/main.zig") });

    return ZigLibrary{ .compile = lib };
}

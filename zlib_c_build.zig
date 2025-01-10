const std = @import("std");
const Step = std.Build.Step;
const Build = std.Build;
const Compile = Step.Compile;
const Self = @This();

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const root_path = root() ++ "/";
const package_path = "src/main.zig";
pub const include_dir = "zlib";

pub const Library = struct {
    compile: *Compile,

    pub fn link(self: Library, b: *Build, other: *Compile) void {
        other.addIncludePath(b.path("zlib"));
        other.linkLibrary(self.compile);
    }
};

pub fn create(b: *Build, target: Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) Library {
    const lib = b.addStaticLibrary(.{ .name = "z", .target = target, .optimize = optimize });

    lib.linkLibC();
    lib.addCSourceFiles(.{ .root = b.path(include_dir), .files = srcs, .flags = &.{"-std=c89"} });
    lib.installHeadersDirectory(b.path(include_dir), "", .{});
    return Library{ .compile = lib };
}

const srcs = &.{
    "adler32.c",
    "compress.c",
    "crc32.c",
    "deflate.c",
    "gzclose.c",
    "gzlib.c",
    "gzread.c",
    "gzwrite.c",
    "inflate.c",
    "infback.c",
    "inftrees.c",
    "inffast.c",
    "trees.c",
    "uncompr.c",
    "zutil.c",
};

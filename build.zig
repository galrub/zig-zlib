const std = @import("std");
const zlib = @import("zlib.zig");
const test_build = @import("test_build.zig");
const zlib_wraapper = @import("zlib_wrapper.zig");

const lib_file_path = "zig-out/lib/z.lib";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //root module
    _ = b.addModule("zlib", .{
        .root_source_file = b.path("src/main.zig"),
    });

    //compile and link the
    const lib = zlib.create(b, target, optimize);
    b.installArtifact(lib.compile);

    //build and run the test
    const tests = test_build.create(b, target, optimize);
    lib.link(b, tests.compile);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.compile.step);

    b.installArtifact(tests.compile);

    //build the wrapper libs
    const zlib_wrap = zlib_wraapper.create(b, target, optimize);
    lib.link(b, zlib_wrap.compile);
    const wrapper_step = b.step("wrapper", "build the zig wrapper");
    wrapper_step.dependOn(&zlib_wrap.compile.step);

    b.installArtifact(zlib_wrap.compile);

    // const bin = b.addExecutable(.{
    //     .name = "example1",
    //     .root_source_file = b.path("example/example1.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    // bin.linkLibrary(lib.compile);
    // b.installArtifact(bin);
}

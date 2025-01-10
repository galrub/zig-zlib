const std = @import("std");
const zlib_c_build = @import("zlib_c_build.zig");
const tests_build = @import("tests_build.zig");
const zlib_wraapper_build = @import("zlib_wrapper_build.zig");
const example_build = @import("zlib_example_build.zig");

const lib_file_path = "zig-out/lib/z.lib";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //root module
    _ = b.addModule("zlib", .{
        .root_source_file = b.path("src/main.zig"),
    });

    //compile and link the
    const static_lib = zlib_c_build.create(b, target, optimize);
    const lib_c_step = b.step("compileClib", "build zlib for the C source file");
    lib_c_step.dependOn(&static_lib.compile.step);

    b.installArtifact(static_lib.compile);

    //build and run the C code test
    const tests = tests_build.create(b, target, optimize);
    static_lib.link(b, tests.compile);
    const testing_step = b.step("test", "run tests");
    testing_step.dependOn(&tests.compile.step);

    b.installArtifact(tests.compile);

    //build the wrapper libs
    const zlib_wrapper = zlib_wraapper_build.create(b, target, optimize);
    static_lib.link(b, zlib_wrapper.compile);
    const wrapper_step = b.step("wrapper", "build the zig wrapper");
    wrapper_step.dependOn(&zlib_wrapper.compile.step);

    b.installArtifact(zlib_wrapper.compile);

    //build the examole
    const example = example_build.create(b, target, optimize);
    zlib_wrapper.link(b, example.compile);
    const exe_step = b.step("example", "build the example");
    exe_step.dependOn(&example.compile.step);

    b.installArtifact(example.compile);
}

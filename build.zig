const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "dmenu",
        .root_source_file = .{ .path = "dmenu.c" },
    });

    // linker stuff
    exe.linkLibC();
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("Xinerama");
    exe.linkSystemLibrary("fontconfig");
    exe.linkSystemLibrary("Xft");

    // include paths
    exe.addIncludePath("/usr/include/freetype2");
    exe.addIncludePath("/usr/X11R6/include");

    // define flags
    exe.defineCMacro("VERSION", "\"5.2\"");
    exe.defineCMacro("XINERAMA", null);

    // add object files
    const c_args =[_][]const u8 {
        "-std=c99",
    };
    exe.addCSourceFile("drw.c", &c_args);
    exe.addCSourceFile("util.c", &c_args);

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}

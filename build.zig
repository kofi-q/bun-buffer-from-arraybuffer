const std = @import("std");
const tokota = @import("tokota");

pub fn build(b: *std.Build) !void {
    const step_bun = b.step("bun", "Run the example with Bun");
    const step_node = b.step("node", "Run the example with Node");

    const addon = tokota.Addon.create(b, .{
        .name = "addon",
        .mode = b.standardOptimizeOption(.{}),
        .target = b.standardTargetOptions(.{}),
        .root_source_file = b.path("main.zig"),
        .output_dir = .{ .custom = ".." },
    });
    b.getInstallStep().dependOn(&addon.install.step);

    const bun = b.addSystemCommand(&.{ "bun", "main.js" });
    const node = b.addSystemCommand(&.{ "node", "main.js" });

    bun.step.dependOn(b.getInstallStep());
    node.step.dependOn(b.getInstallStep());

    step_bun.dependOn(&bun.step);
    step_node.dependOn(&node.step);
}

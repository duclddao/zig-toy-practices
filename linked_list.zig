const std = @import("std");
const print = std.debug.print;
const Node = struct {
    value: u8,
    next: ?*Node = null,
    fn to_str(self: Node) void {
        print("{}", self.value);
    }
    fn add(self: *Node) void {
        print("{}", self.value);
    }
};

pub fn main() !void {
    // read file
    // intialize list then print it in sorted order
    // end
    const input_dir = try std.fs.cwd().openDir("input", .{});
    const file = try input_dir.openFile("number_sequences.txt", .{});
    defer file.close();
    const reader = file.reader();
    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.tokenizeAny(u8, line, " ");
        while (it.next()) |value| {
            print("{s} ", .{value});
        }
        print("\n", .{});
    }
}

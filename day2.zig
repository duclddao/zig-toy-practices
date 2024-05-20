const std = @import("std");
const print = std.debug.print;
const RGB = enum { red, green, blue };
const Set = struct {
    red: u32 = 0,
    green: u32 = 0,
    blue: u32 = 0,

    fn isExceeded(self: Set, other: Set) bool {
        if (self.red < other.red or self.green < other.green or self.blue < other.blue) {
            return true;
        }
        return false;
    }
    fn set(self: *Set, indicator: []const u8, value: u32) !void {
        const case = std.meta.stringToEnum(RGB, indicator).?;
        switch (case) {
            .red => self.red = value,
            .green => self.green = value,
            .blue => self.blue = value,
        }
    }
};

const configSet = Set{
    .red = 12,
    .green = 13,
    .blue = 14,
};

// part1
// fn processLine(line: []const u8) !u32 {
//     var it = std.mem.splitSequence(u8, line, ": ");
//     var gameId: u32 = undefined;
//     var sets: []const u8 = undefined;
//     while (it.next()) |part| {
//         if (std.mem.indexOf(u8, part, "Game")) |_| {
//             const spaceIdx = std.mem.indexOf(u8, part, " ").?;
//             gameId = try std.fmt.parseInt(u32, part[spaceIdx + 1 ..], 10);
//         } else {
//             sets = part;
//         }
//     }
//     it = std.mem.splitSequence(u8, sets, "; ");
//     while (it.next()) |setStr| {
//         var setIt = std.mem.splitSequence(u8, setStr, ", ");
//         var set = Set{};

//         while (setIt.next()) |pair| {
//             var pairIt = std.mem.splitSequence(u8, pair, " ");
//             const value = try std.fmt.parseInt(u32, pairIt.next().?, 10);
//             const indicator = pairIt.next().?;
//             try set.set(indicator, value);
//         }
//         if (configSet.isExceeded(set)) {
//             return 0;
//         }
//     }
//     return gameId;
// }

//part2
fn processLine(line: []const u8) !u32 {
    var it = std.mem.splitSequence(u8, line, ": ");
    var sets: []const u8 = undefined;
    var maxConfig = Set{};
    while (it.next()) |part| {
        if (std.mem.indexOf(u8, part, "Game") == null) {
            sets = part;
        }
    }
    it = std.mem.splitSequence(u8, sets, "; ");
    while (it.next()) |setStr| {
        var setIt = std.mem.splitSequence(u8, setStr, ", ");
        var set = Set{};

        while (setIt.next()) |pair| {
            var pairIt = std.mem.splitSequence(u8, pair, " ");
            const value = try std.fmt.parseInt(u32, pairIt.next().?, 10);
            const indicator = pairIt.next().?;
            try set.set(indicator, value);
        }
        maxConfig.red = @max(maxConfig.red, set.red);
        maxConfig.green = @max(maxConfig.green, set.green);
        maxConfig.blue = @max(maxConfig.blue, set.blue);
    }
    return maxConfig.red * maxConfig.green * maxConfig.blue;
}
pub fn main() !void {
    const inputDir = try std.fs.cwd().openDir("input", .{});
    const file = try inputDir.openFile("day2.txt", .{});
    defer file.close();

    //allocator
    var areana = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer areana.deinit();
    const allocator = areana.allocator();

    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
    var res: u32 = 0;
    var it = std.mem.tokenizeAny(u8, read_buf, "\r\n");
    while (it.next()) |line| {
        res += try processLine(line);
    }
    print("{}\n", .{res});
}

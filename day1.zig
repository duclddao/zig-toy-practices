const std = @import("std");
const print = std.debug.print;
const Digit = struct {
    strValue: []const u8,
    value: u8,
};

const PATTERNS = [_]Digit{
    Digit{ .strValue = "one", .value = 1 },
    Digit{ .strValue = "two", .value = 2 },
    Digit{ .strValue = "three", .value = 3 },
    Digit{ .strValue = "four", .value = 4 },
    Digit{ .strValue = "five", .value = 5 },
    Digit{ .strValue = "six", .value = 6 },
    Digit{ .strValue = "seven", .value = 7 },
    Digit{ .strValue = "eight", .value = 8 },
    Digit{ .strValue = "nine", .value = 9 },
} ++ [_]Digit{
    Digit{ .strValue = "1", .value = 1 },
    Digit{ .strValue = "2", .value = 2 },
    Digit{ .strValue = "3", .value = 3 },
    Digit{ .strValue = "4", .value = 4 },
    Digit{ .strValue = "5", .value = 5 },
    Digit{ .strValue = "6", .value = 6 },
    Digit{ .strValue = "7", .value = 7 },
    Digit{ .strValue = "8", .value = 8 },
    Digit{ .strValue = "9", .value = 9 },
};

fn processLine(line: []const u8) u32 {
    var i: usize = 0;
    const windowSize: usize = if (line.len < 5) line.len else 5;
    var startValue: u8 = 0;
    var endValue: u8 = 0;
    var minStart: ?usize = null;
    var maxEnd: ?usize = null;
    while (i + windowSize <= line.len) : (i += 1) {
        for (PATTERNS) |pattern| {
            const pos = std.mem.indexOf(u8, line[i .. i + windowSize], pattern.strValue);
            if (pos != null and minStart != null and minStart.? > pos.?) {
                minStart = pos;
                startValue = pattern.value;
            } else if (pos != null and minStart == null) {
                minStart = pos;
                startValue = pattern.value;
            }
        }
        if (minStart != null) {
            break;
        }
    }
    i = (line.len - windowSize);
    while (i >= 0) : (i -= 1) {
        for (PATTERNS) |pattern| {
            const pos = std.mem.lastIndexOf(u8, line[i .. i + windowSize], pattern.strValue);
            if (pos != null and maxEnd != null and maxEnd.? < pos.?) {
                maxEnd = pos;
                endValue = pattern.value;
            } else if (pos != null and maxEnd == null) {
                maxEnd = pos;
                endValue = pattern.value;
            }
        }
        if (maxEnd != null) {
            break;
        }
    }
    return startValue * 10 + endValue;
}

pub fn main() !void {
    const inputDir = try std.fs.cwd().openDir("input", .{});
    const file = try inputDir.openFile("day1.txt", .{});
    defer file.close();

    //allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const read_buf = try file.readToEndAlloc(allocator, 102400);
    var sum: u32 = 0;
    var it = std.mem.tokenizeAny(u8, read_buf, "\r\n");
    while (it.next()) |line| {
        sum += processLine(line);
    }
    print("Result: {}", .{sum});
}

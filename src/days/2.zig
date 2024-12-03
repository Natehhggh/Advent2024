const std = @import("std");

pub fn solve() !void {
    const len = 1000;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();

    var levels: [len]std.ArrayList(i32) = undefined;
    for (0..len) |i| {
        levels[i] = std.ArrayList(i32).init(allocator);
        defer levels[i].deinit();
    }
    try getInput(&levels);

    var total: u32 = 0;
    for (levels) |level| {
        var derivativeDir: i32 = -99;
        const n = level.items.len;
        var safe = true;
        for (level.items[0 .. n - 1], level.items[1..]) |read, readNext| {
            if (read == readNext) {
                safe = false;
                break;
            }
            if (derivativeDir == -99) {
                derivativeDir = @divTrunc(read - readNext, abs(read - readNext));
            }

            if (derivativeDir * (read - readNext) < 0) {
                safe = false;
                break;
            }

            if (@abs(read - readNext) > 3) {
                safe = false;
            }
        }
        if (safe) {
            total += 1;
        }
    }

    try stdout.print("safe readings: {d}\n", .{total});
}

pub fn solve_bonus() !void {
    const len = 1000;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();

    var levels: [len]std.ArrayList(i32) = undefined;
    for (0..len) |i| {
        levels[i] = std.ArrayList(i32).init(allocator);
        defer levels[i].deinit();
    }
    try getInput(&levels);

    var total: u32 = 0;
    for (levels) |level| {
        const n = level.items.len;
        //TODO: clean up, solution came after some work, and I dont want to rename/refactor atm
        var safe: i32 = isSafe(level);

        if (safe != -1) {
            var withoutPrev = std.ArrayList(i32).init(allocator);
            defer withoutPrev.deinit();
            var withoutCurr = std.ArrayList(i32).init(allocator);
            defer withoutCurr.deinit();
            var withoutNext = std.ArrayList(i32).init(allocator);
            defer withoutNext.deinit();

            for (0..n) |i| {
                if (i != safe - 1) {
                    try withoutPrev.append(level.items[i]);
                }
                if (i != safe) {
                    try withoutCurr.append(level.items[i]);
                }
                if (i != safe + 1) {
                    try withoutNext.append(level.items[i]);
                }
            }

            var safeWithout = isSafe(withoutCurr);

            if (safeWithout != -1) {
                safeWithout = isSafe(withoutNext);
            }

            if (safeWithout != -1) {
                safeWithout = isSafe(withoutPrev);
            }

            safe = safeWithout;
        }

        if (safe == -1) {
            total += 1;
        }
    }

    try stdout.print("safe readings: {d}\n", .{total});
}

pub fn isSafe(levels: std.ArrayList(i32)) i32 {
    var returnVal: i32 = -1;
    var derivativeDir: i32 = -99;
    const n = levels.items.len;
    for (levels.items[0 .. n - 1], levels.items[1..], 0..n - 1) |read, readNext, i| {
        if (read == readNext) {
            returnVal = @intCast(i);
            break;
        }
        if (derivativeDir == -99) {
            derivativeDir = @divTrunc(read - readNext, abs(read - readNext));
        }

        if (derivativeDir * (read - readNext) < 0) {
            returnVal = @intCast(i);
            break;
        }

        if (@abs(read - readNext) > 3) {
            returnVal = @intCast(i);
            break;
        }
    }
    return returnVal;
}

pub fn getInput(arr: []std.ArrayList(i32)) !void {
    var file = try std.fs.cwd().openFile("./days/2.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var lineNum: u32 = 0;
    // TODO: parse in it's own method
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var input = std.mem.splitAny(u8, line, "\n");
        const lineText = input.next().?;

        input = std.mem.splitAny(u8, lineText, " ");
        while (input.next()) |val| {
            try arr[lineNum].append(try std.fmt.parseInt(i32, val, 10));
        }
        lineNum += 1;
    }
}

pub fn abs(a: i32) i32 {
    if (a >= 0) {
        return a;
    }
    return a * -1;
}

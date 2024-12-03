const std = @import("std");

pub fn solve() !void {
    const len = 1000;

    var locationsLeft: [len]i32 = undefined;
    var locationsRight: [len]i32 = undefined;
    try getInput(&locationsLeft, &locationsRight);

    const stdout = std.io.getStdOut().writer();

    bubbleSort(&locationsLeft);
    bubbleSort(&locationsRight);

    var total: u32 = 0;
    for (0..len) |i| {
        const diff: u32 = @abs(locationsLeft[i] - locationsRight[i]);
        total += diff;
    }

    try stdout.print("deviation: {d}\n", .{total});
}

pub fn solve_bonus() !void {
    const len = 1000;

    var locationsLeft: [len]i32 = undefined;
    var locationsRight: [len]i32 = undefined;
    try getInput(&locationsLeft, &locationsRight);

    const stdout = std.io.getStdOut().writer();

    bubbleSort(&locationsLeft);
    bubbleSort(&locationsRight);

    var score: i32 = undefined;
    var total: i32 = 0;
    var scoreOld: i32 = -1;
    var valueOld: i32 = -1;
    for (locationsLeft) |valLeft| {
        if (valLeft == valueOld) {
            score = scoreOld;
        } else {
            var multi: i32 = 0;
            for (locationsRight) |valRight| {
                if (valRight > valLeft) {
                    break;
                }
                if (valRight == valLeft) {
                    multi += 1;
                }
            }
            score = valLeft * multi;
            valueOld = valLeft;
            scoreOld = score;
        }

        total += score;
    }

    try stdout.print("Similarity: {d}\n", .{total});
}

//TODO: get a faster sort, this is just quick and simple
pub fn bubbleSort(arr: []i32) void {
    const len = arr.len;
    var sorted = false;
    while (!sorted) {
        sorted = true;
        for (0..len - 1) |i| {
            if (arr[i] > arr[i + 1]) {
                sorted = false;
                var tmp: i32 = 0;

                tmp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = tmp;
            }
        }
    }
}

pub fn getInput(arrLeft: []i32, arrRight: []i32) !void {
    var file = try std.fs.cwd().openFile("./days/1.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var lineNum: u32 = 0;
    // TODO: parse in it's own method
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var input = std.mem.splitAny(u8, line, "\n");
        var val = input.next().?;

        input = std.mem.splitAny(u8, val, "   ");
        val = input.next().?;

        arrLeft[lineNum] = try std.fmt.parseInt(i32, val, 10);

        val = input.next().?;
        arrRight[lineNum] = try std.fmt.parseInt(i32, val, 10);
        lineNum += 1;
    }
}

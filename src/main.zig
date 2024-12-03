const std = @import("std");
const day1 = @import("./days/1.zig");
const day2 = @import("./days/2.zig");

pub fn main() !void {
    try day2.solve_bonus();
}

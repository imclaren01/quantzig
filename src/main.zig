const std = @import("std");
const rnd = @import("math/rounding.zig");
const root = @import("root.zig");

const math = root.math;
const utils = root.utilities;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    _ = math.round.Rounding.init(.Closest, 100);
    _ = math.abcdmathfunction.ABCDMathFunction.init(2, 3, 4, 0);
}

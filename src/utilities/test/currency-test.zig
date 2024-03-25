const std = @import("std");
const math = std.math;
const testing = std.testing;
const currency = @import("../currency.zig");

test "basic currency test" {
    const curr: ?currency.Currency = null;
    _ = &curr;
}

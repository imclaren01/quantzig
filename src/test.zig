const std = @import("std");

test "math tests" {
    _ = @import("math/test/rounding-test.zig");
}

test "utilities tests" {
    _ = @import("utilities/test/currency-test.zig");
}

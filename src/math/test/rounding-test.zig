const std = @import("std");
const math = std.math;
const testing = std.testing;
const round = @import("../rounding.zig");

const RoundingTestData = enum {
    value,
    precision,
    closest,
    up,
    down,
    floor,
    ceiling,
};

const testData = std.EnumArray(RoundingTestData, f64);

const testData = [_][7]f64{
    .{ 0.86313513, 5, 0.86314, 0.86314, 0.86313, 0.86314, 0.86313 },
    .{ 0.86313, 5, 0.86313, 0.86313, 0.86313, 0.86313, 0.86313 },
    .{ -7.64555346, 1, -7.6, -7.7, -7.6, -7.6, -7.6 },
    .{ 0.13961605, 2, 0.14, 0.14, 0.13, 0.14, 0.13 },
    .{ 0.14344179, 4, 0.1434, 0.1435, 0.1434, 0.1434, 0.1434 },
    .{ -4.74315016, 2, -4.74, -4.75, -4.74, -4.74, -4.74 },
    .{ -7.82772074, 5, -7.82772, -7.82773, -7.82772, -7.82772, -7.82772 },
    .{ 2.74137947, 3, 2.741, 2.742, 2.741, 2.741, 2.741 },
    .{ 2.13056714, 1, 2.1, 2.2, 2.1, 2.1, 2.1 },
    .{ -1.06228670, 1, -1.1, -1.1, -1.0, -1.0, -1.1 },
    .{ 8.29234094, 4, 8.2923, 8.2924, 8.2923, 8.2923, 8.2923 },
    .{ 7.90185598, 2, 7.90, 7.91, 7.90, 7.90, 7.90 },
    .{ -0.26738058, 1, -0.3, -0.3, -0.2, -0.2, -0.3 },
    .{ 1.78128713, 1, 1.8, 1.8, 1.7, 1.8, 1.7 },
    .{ 4.23537260, 1, 4.2, 4.3, 4.2, 4.2, 4.2 },
    .{ 3.64369953, 4, 3.6437, 3.6437, 3.6436, 3.6437, 3.6436 },
    .{ 6.34542470, 2, 6.35, 6.35, 6.34, 6.35, 6.34 },
    .{ -0.84754962, 4, -0.8475, -0.8476, -0.8475, -0.8475, -0.8475 },
    .{ 4.60998652, 1, 4.6, 4.7, 4.6, 4.6, 4.6 },
    .{ 6.28794223, 3, 6.288, 6.288, 6.287, 6.288, 6.287 },
    .{ 7.89428221, 2, 7.89, 7.90, 7.89, 7.89, 7.89 },
};
test "test closest rounding" {
    for (testData) |item| {
        const rounding = round.Rounding.init(.Closest, item[@intFromEnum(RoundingTestData.precision)]);
        const calculated = rounding.round(f64, item[@intFromEnum(.value)]);
        try testing.expectApproxEqRel(calculated, item[@intFromEnum(.closest)], 42 * math.floatEps(f64));
    }
}

test "test up rounding" {
    for (testData) |item| {
        const rounding: round.Rounding = .{ .Up, item[.precision] };
        const calculated = rounding.round(f64, item[.value]);
        try testing.expectApproxEqRel(calculated, item[.up], 42 * math.floatEps(f64));
        std.debug.print("Hi");
    }
}

test "test down rounding" {
    for (testData) |item| {
        const rounding: round.Rounding = .{ .Down, item[.precision] };
        const calculated = rounding.round(f64, item[.value]);
        try testing.expectApproxEqRel(calculated, item[.down], 42 * math.floatEps(f64));
    }
}

const std = @import("std");
const math = std.math;

pub fn close64(a: f64, b: f64) bool {
    return math.approxEqRel(f64, a, b, 42 * math.floatEps(f64));
}

pub fn close32(a: f32, b: f32) bool {
    return math.approxEqRel(f32, a, b, 42 * math.floatEps(f32));
}

const std = @import("std");

pub const Currency = struct {
    name: []const u8,
    code: []const u8,
    numericCode: i16,
    symbol: []const u8,
    fractionSymbol: []const u8,
    fractionsPerUnit: i16,
    // rounding: math.
};

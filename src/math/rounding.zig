const std = @import("std");
const math = std.math;

pub const RoundingType = enum {
    None,
    Up,
    Down,
    Closest,
    Floor,
    Ceiling,
};

pub const Rounding = struct {
    roundingType: RoundingType,
    precision: comptime_int,
    roundingDigit: comptime_int = 5,

    pub fn init(roundingType: RoundingType, precision: comptime_int) Rounding {
        return Rounding{
            .roundingType = roundingType,
            .precision = precision,
        };
    }

    pub fn changeRoundingDigit(self: Rounding, newRoundingDigit: comptime_int) void {
        self.roundingDigit = newRoundingDigit;
    }

    pub fn round(self: Rounding, comptime T: type, val: T) T {
        if (T != f64 or T != f32) {
            @compileError("round function needs f32 or f64");
        }
        if (self.roundingType == .None) {
            return val;
        }
        const mult = math.pow(f64, 10.0, self.precision);
        const isNeg = (val < 0.0);
        var lvalue = @abs(val) * mult;
        const rat = math.modf(lvalue);
        lvalue -= rat.fpart;

        lvalue += switch (self.roundingType) {
            .Down => 0,
            .Up => if (rat.fpart != 0.0) 1.0 else 0.0,
            .Closest => if (rat.fpart >= (self.digit / 10.0)) 1.0 else 0.0,
            .Floor => {
                if (!isNeg) {
                    if (rat.fpart >= (self.digit / 10.0)) {
                        1;
                    }
                }
                0;
            },
        };
    }
};

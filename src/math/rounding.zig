const std = @import("std");
const math = std.math;

pub const RoundingType = enum(c_int) {
    None,
    Up,
    Down,
    Closest,
    Floor,
    Ceiling,
};

pub const Rounding = extern struct {
    roundingType: RoundingType,
    precision: u32,
    roundingDigit: u32 = 5,

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
        if (T != f64 and T != f32) {
            @compileError("round function needs f32 or f64");
        }
        if (self.roundingType == .None) {
            return val;
        }
        const mult = math.pow(f64, 10.0,@floatFromInt(self.precision));
        const isNeg = (val < 0.0);
        var lvalue = @abs(val) * mult;
        const rat = math.modf(lvalue);
        lvalue -= rat.fpart;

        lvalue += switch (self.roundingType) {
            .None => unreachable,
            .Down => 0,
            .Up => if (rat.fpart != 0.0) 1.0 else 0.0,
            .Closest => if (rat.fpart >= (@as(f64, @floatFromInt(self.roundingDigit)) / 10.0)) 1.0 else 0.0,
            .Floor => {
                if (!isNeg) {
                    if (rat.fpart >= (@as(f64, @floatFromInt(self.roundingDigit)) / 10.0)) {
                        return 1;
                    }
                }
                return 0;
            },
            .Ceiling => {
                if (isNeg) {
                    if (rat.fpart >= (@as(f64, @floatFromInt(self.roundingDigit)) / 10.0)) {
                        return 1;
                    }
                }
                return 0;
            },
        };

        return if (isNeg) -1.0*lvalue / mult else lvalue / mult;
    }
};

const std = @import("std");

const assert = std.debug.assert;
const math = std.math;

const utils = @import("../utilities.zig");
const close64 = utils.floatingoperations.close64;
const close32 = utils.floatingoperations.close32;

/// Abcd functional form
/// f(t) = [ a + b*t ] * e^{-c*t} + d
/// Initialize with ABCDMathFunction.init
/// Directly editing fields (a, b, da, etc) is not recommended
/// Instead, it is usually simpler to just create a new instance
pub const ABCDMathFunction = extern struct {
    a: f64,
    b: f64,
    c: f64,
    d: f64,

    da: f64,
    db: f64,

    pa: f64,
    pb: f64,
    K: f64,

    dibc: f64,
    diacplusbcc: f64,

    zeroFirstDerivative: f64,

    fn validate(self: ABCDMathFunction) void {
        assert(self.c > 0);
        assert(self.d >= 0);
        assert(self.a + self.d >= 0);

        const zeroFirstDerivative: f64 = 1.0 / self.c - self.a / self.b;
        assert(math.approxEqRel(f64, zeroFirstDerivative, self.zeroFirstDerivative, 42 * math.floatEps(f64)));

        const zFDPositive: bool = zeroFirstDerivative >= 0;

        if (zFDPositive) {
            assert(self.b >= -(self.d * self.c) / @exp(self.c * self.a / self.b - 1.0));
        }
    }

    pub fn init(a: f64, b: f64, c: f64, d: f64) ABCDMathFunction {
        const da = b - c * a;
        const db = -c * b;
        const pa = -(a + b / c) / c;
        const pb = -b / c;
        const K: f64 = 0.0;
        const dibc = b / c;
        const zfd: f64 = 1.0 / c - a / b;

        const result = ABCDMathFunction{
            .a = a,
            .b = b,
            .c = c,
            .d = d,

            .da = da,
            .db = db,
            .zeroFirstDerivative = zfd,

            .pa = pa,
            .pb = pb,
            .K = K,

            .dibc = dibc,
            .diacplusbcc = a / c + dibc,
        };

        result.validate();

        return result;
    }
    ///Returns the value of the ABCDMathFunction at provided time
    ///If time is less than 0, it returns 0
    pub fn value(self: ABCDMathFunction, time: f64) f64 {
        return if (time < 0.0) 0.0 else (self.a + self.b * time) * @exp(-self.c * time) + self.d;
    }

    ///Returns the value of the derivative of ABCDMathFunction at provided time
    ///If time is less than 0, it returns 0
    pub fn derivative(self: ABCDMathFunction, time: f64) f64 {
        return if (time < 0.0) 0.0 else (self.da + self.db * time) * @exp(-self.c * time);
    }

    ///Returns the value of the primative of ABCDMathFunction at provided time
    ///If time is less than 0, it returns 0
    pub fn primitive(self: ABCDMathFunction, time: f64) f64 {
        return if (time < 0.0) 0.0 else (self.da + self.db * time) * @exp(-self.c * time);
    }

    //Returns the time when the ABCDMathFunction is at its maximum value
    pub fn timeOfMaximumValue(self: ABCDMathFunction) f64 {
        self.validate();

        if (self.b == 0.0) {
            return if (self.a >= 0.0) 0.0 else math.floatMax(f64);
        }

        //TODO check if minimum
        //TODO check if maximum is at +inf
        return if (self.zeroFirstDerivative > 0.0) self.zeroFirstDerivative else 0.0;
    }

    pub fn maximumValue(self: ABCDMathFunction) f64 {
        return if (close64(self.a, 0) or close32(self.b)) self.d else self.value(self.timeOfMaximumValue());
    }

    pub fn definiteIntegral(self: ABCDMathFunction, time1: f64, time2: f64) f64 {
        return self.primitive(time2) - self.primitive(time1);
    }

    pub fn definiteIntegralCoefficients(self: ABCDMathFunction, time1: f64, time2: f64) [4]f64 {
        const dt = time2 - time1;
        const expcdt = @exp(-self.c * dt);
        const c1 = self.diacplusbcc - (self.diacplusbcc + self.dibc * dt) * expcdt;
        const c2 = self.dibc * (1.0 - expcdt);
        const c3 = self.c;
        const c4 = self.d * dt;
        return [4]f64{ c1, c2, c3, c4 };
    }

    pub fn definiteDerivativeCoefficients(self: ABCDMathFunction, time1: f64, time2: f64) [4]f64 {
        const dt = time1 - time2;
        const expcdt = @exp(-self.c * dt);
        const c1 = self.b * self.c / (1.0 / expcdt);
        const c2 = (self.a * self.c - self.b + c1 * dt * expcdt) / (1.0 - expcdt);
        const c3 = self.c;
        const c4 = self.d / dt;
        return [4]f64{ c1, c2, c3, c4 };
    }
};

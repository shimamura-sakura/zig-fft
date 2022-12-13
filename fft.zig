const std = @import("std");
const PI = std.math.pi;
pub const FFTError = error{ SizeNotEql, SizeNotPow2 };
pub fn fft(comptime F: type, real: []F, imag: []F) FFTError!void {
    if (real.len != imag.len) return FFTError.SizeNotEql;
    if (@popCount(real.len) != 1) return FFTError.SizeNotPow2;
    shuffle(F, real, imag);
    compute(F, real, imag);
}
pub fn ifft(comptime F: type, real: []F, imag: []F) FFTError!void {
    if (real.len != imag.len) return FFTError.SizeNotEql;
    if (@popCount(real.len) != 1) return FFTError.SizeNotPow2;
    for (imag) |*v| v.* = -v.*;
    fft(F, real, imag) catch unreachable;
    for (real) |*v| v.* /= @intToFloat(F, real.len);
    for (imag) |*v| v.* /= @intToFloat(F, imag.len) * -1.0;
}
fn shuffle(comptime F: type, real: []F, imag: []F) void {
    const shrAmount = @bitSizeOf(usize) - @ctz(real.len);
    const shrAmtType = std.meta.Int(.unsigned, @ctz(@as(u8, @bitSizeOf(usize))));
    for (real) |_, i| {
        const j = @bitReverse(i) >> @intCast(shrAmtType, shrAmount);
        if (i >= j) continue;
        std.mem.swap(F, &real[i], &real[j]);
        std.mem.swap(F, &imag[i], &imag[j]);
    }
}
fn compute(comptime F: type, real: []F, imag: []F) void {
    var step: usize = 1;
    while (step < real.len) : (step <<= 1) {
        var group: usize = 0;
        const jump = step << 1;
        while (group < step) : (group += 1) {
            const t_re = @cos(-PI * @intToFloat(F, group) / @intToFloat(F, step));
            const t_im = @sin(-PI * @intToFloat(F, group) / @intToFloat(F, step));
            var pair = group;
            while (pair < real.len) : (pair += jump) {
                const match = pair + step;
                const p_re = t_re * real[match] - t_im * imag[match];
                const p_im = t_im * real[match] + t_re * imag[match];
                real[match] = real[pair] - p_re;
                imag[match] = imag[pair] - p_im;
                real[pair] += p_re;
                imag[pair] += p_im;
            }
        }
    }
}

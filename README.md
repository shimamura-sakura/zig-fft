# zig-fft
Simple FFT in Zig. A port of https://github.com/lloydroc/arduino_fft, added IFFT.

## Usage

```zig
pub fn main() !void {
    var real = [8]f32{ 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0 };
    var imag = [8]f32{ -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0 };
    std.debug.print("IN:\n", .{});
    std.debug.print("real: {d:7.3}\n", .{real});
    std.debug.print("imag: {d:7.3}\n", .{imag});

    try fft(f32, &real, &imag);

    std.debug.print("FFT:\n", .{});
    std.debug.print("real: {d:7.3}\n", .{real});
    std.debug.print("imag: {d:7.3}\n", .{imag});

    try ifft(f32, &real, &imag);

    std.debug.print("IFFT:\n", .{});
    std.debug.print("real: {d:7.3}\n", .{real});
    std.debug.print("imag: {d:7.3}\n", .{imag});
}
```

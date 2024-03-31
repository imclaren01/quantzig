# quantzig

A Zig package that aims to transition open source financial analysis software away from exclusively C++ territory. Zig provides the speed necessary for large-scale, nanosecond calculations that are necessary for real time quantitative analysis, while still providing far more safety, consistency, and simplicitly compared to C++. Additionally, using the export keyword, we are able to expose the library to the C ABI, so that it can be utilized by nearly every programming language.

Please keep in mind that this library is currently very much a work in progress. QuantLib, the inspiration and source for large parts of the logic for quantzig, is a massive library with hundreds of contributers that has been developed and improved over many years. It is also, like most C++ libraries, written in a strictly OOP manner that is neither feasible nor useful for a Zig library. This library will be missing features, documentation, and testing for the forseeable future. 

## Getting started

### Linking quantzig to your project

This is an example `build.zig` that will link the quantzig library to your project.

```zig
const std = @import("std");
const qz = @import("quantzig.zig"); // Import the Sdk at build time

pub fn build(b: *std.Build.Builder) !void {
    // Determine compilation target
    const target = b.standardTargetOptions(.{});

    // Create a new instance of the SDL2 Sdk
    const sdk = Sdk.init(b, null);

    // Create executable for our example
    const myProject = b.addExecutable(.{
        .name = "my-project",
        .root_source_file = .{ .path = "project-using-quantzig.zig" },
        .target = target,
    });
    qz.link(myProject, .static); // link quantzig as a static library
    //We may in the future extend to become a dynamic library, but it is unlikely to be useful. The chances of more than one or 
    //maybe two programs using quantzig on the same device seems slim to none.

    // Add "quantzig" package that exposes the api
    myProject.root_module.addImport("quantzig", qz.getNativeModule());

    // Install the executable into the prefix when invoking "zig build"
    b.installArtifact(myProject);
}
```

## Roadmap

1. Implement key underlying functions from QuantLib ❌
    - rounding/precision ✅
    - datetime ❌
    - currency ❌
    - math ❌
    ...
2. Implement financial instruments and pricing engines (in a non-OOP way) ❌

# QEMU Android/ARM64 optimization plan

## Current repository state

PocketVM is currently an Android Java application. The QEMU engine is not vendored or linked yet, so changing the app's Java code cannot make the x86-64 guest CPU faster. Keep QEMU changes separate from UI changes.

## Target

- Host: Android on ARM64 (Poco M6).
- Guest: Windows x86-64.
- Emulator: QEMU system emulation using TCG unless a compatible accelerator is proven available.
- Primary metric: guest CPU throughput; secondary metrics: boot time, memory use, thermal throttling, and stability.

## Rules before changing the emulator

1. Pin an exact upstream QEMU commit and toolchain. Do not benchmark a moving `master` branch.
2. Build a baseline first, then change one variable at a time.
3. Keep the same guest disk image, machine type, CPU model, RAM, vCPU count, display mode, and workload for every run.
4. Record compiler flags and QEMU command line with each result.
5. Run each benchmark multiple times, discard warm-up runs, and compare medians. Record device temperature/thermal state where available.
6. Never describe a build-flag change as a speedup until measurements demonstrate it.

## Optimization order

### 1. Establish a reproducible baseline
- Confirm that the Android ARM64 QEMU binary launches on-device.
- Confirm that `qemu-system-x86_64` is built with TCG and that the expected machine/device models are available.
- Capture startup logs, guest boot time, and a repeatable CPU workload result.

### 2. Profile before editing TCG
Inspect CPU time in:
- `accel/tcg/` — translation and execution loop.
- `tcg/` and host-specific TCG backends — generated ARM64 code and translation overhead.
- `target/i386/` — x86/x86-64 translation semantics.
- `softmmu/` and memory/TLB paths — guest memory access costs.
- device emulation — only if profiling shows I/O or device models dominate.

Paths can move between upstream versions; confirm them against the pinned commit.

### 3. Candidate experiments
- Compare upstream release compiler settings against carefully measured release settings; do not assume `-O3` or LTO is automatically faster.
- Measure TCG translation-block chaining and cache behavior before changing it.
- Measure guest memory/TLB overhead under the same workload.
- Test vCPU count only after single-vCPU performance is measured; extra vCPUs can add overhead.
- Consider device simplification only when the guest workload does not require the removed device features.

### 4. Acceptance criteria
A patch is accepted only if:
- correctness and boot tests pass;
- it produces a repeatable improvement on the target Android device;
- the improvement exceeds run-to-run noise;
- it does not introduce a significant regression in another representative workload;
- the patch is documented with the exact benchmark setup and before/after results.

## Important limitation

The standard Android NDK targets Android ABIs, but QEMU does not list Android as a primary tested host platform. Android/Bionic compatibility and optional dependencies must be verified during the build. A successful Linux/ARM64 build is not proof that the same binary will run on Android.

## Next implementation step

Integrate or build a pinned QEMU ARM64-host binary for PocketVM, then add a reproducible benchmark path. Do not make speculative changes to TCG until that baseline is available.

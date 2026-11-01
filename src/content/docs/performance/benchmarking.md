---
title: "Hydrogen native runtime comparison"
---

> Development reference from [Hylang-Compiler](https://github.com/Aurora-softwares/Hylang-Compiler/tree/Development). Commands and source paths on this page are relative to that repository checkout. For current task status, use the [development project](https://github.com/orgs/Aurora-softwares/projects/4).

This harness tests executables emitted by the **Hydrogen-written Linux x64
compiler** against C, C++, and Rust. It covers two computational kernels and
four application-like areas. The SDK C backend and SDK interpreter are optional
comparison routes; they are not optimisation targets for this benchmark plan.
Every run must print the exact checksum computed independently by Python.

| Case | Work represented | Input |
| --- | --- | --- |
| `loop` | Dependent integer arithmetic | 10 million iterations in the reference run |
| `array` | Numeric array fill and aggregation | 10 million integer elements in four-byte slots |
| `log` | Read a text log and count error lines | 100,000 fixed-format ASCII lines, 1 MB |
| `csv` | Read and aggregate an amount column | 100,000 deterministic `id,amount` rows, 679 KB |
| `bytes` | Read a binary file and calculate a rolling checksum | 1.6 MB |
| `nodes` | Build and traverse a linked object graph | 20,000 objects |

The runner creates the same deterministic files for all languages in one
temporary directory. The log has every fifth line marked `E`; CSV amounts are
`row % 97`; binary bytes repeat `(index * 17 + 3) % 256`. The numeric work
stays in signed range, so overflow rules do not affect the output. Object
lists remain live through traversal and are left to process cleanup in all
routes. These cases are proxies for real work, not full applications.

## Current development result (1 November 2026)

The latest [31-run six-case snapshot](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-rebuilt-stage1.json)
uses the rebuilt native stage-1 compiler, three warmups, and the reference
inputs above. Times are whole-process medians in milliseconds. The target for
each row is the *slowest* C, C++, or Rust median from that same run.

| Workload | Hydrogen native | Slowest comparison | Native / target | Target met? |
| --- | ---: | ---: | ---: | --- |
| loop | 54.62 | 44.83 | 1.22× | No |
| array | 87.23 | 58.85 | 1.48× | No |
| log | 3.54 | 4.79 | 0.74× | Yes |
| csv | 2.36 | 4.15 | 0.57× | Yes |
| bytes | 9.90 | 11.27 | 0.88× | Yes |
| nodes | 2.24 | 1.94 | 1.16× | No |

Three of six cases meet the target. Array fill and scan is the largest gap;
loop and nodes also remain above their targets. The older 17 October table
below is retained as a historical baseline, not the current result. The
0.8.0 performance work remains In Progress in the
[development project](https://github.com/orgs/Aurora-softwares/projects/4).

## Run it

From the Hylang-Compiler repository root:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target hy hydrogen_stage1
python3 assets/benchmarks/runtime/run.py \
  --native build/self_hosting/hydrogen-stage1 \
  --iterations 10000000 --records 100000 --bytes 1600000 --nodes 20000 \
  --runs 7 --warmups 2 \
  --json build/benchmarks/runtime-realworld-results.json
```

Use the freshly rebuilt stage-1 binary for the development result above; a
stage-3 binary should only be used after explicitly rebuilding and verifying
that binary. The runner needs Python 3, `cc`, `c++`, `rustc`, and a native
self-hosted compiler.
Use `--cc`, `--cxx`, `--rustc`, or `--native` to select other binaries. Add
`--include-sdk-c` for the SDK's generated C route, or
`--include-interpreter` for `hy run` (use much smaller inputs there). These
optional routes require `build/hy`, selectable with `--sdk`.

For a quick correctness check:

```bash
python3 assets/benchmarks/runtime/run.py \
  --native build/self_hosting/hydrogen-stage1 \
  --iterations 1000 --records 100 --bytes 1024 --nodes 100 \
  --runs 1 --warmups 0
```

`--workloads log,csv,bytes,nodes` runs a subset. All runs time process startup,
input reading, computation, and the checksum print; compilation is reported
separately. C and C++ use `-O2`, Rust uses `-C opt-level=2`, and the native
Hydrogen compiler emits its direct x64 output. The runner checks stdout,
stderr, and exit code on warmups and timed samples, shuffles route order, then
reports median wall time and ratio to C. JSON output records every sample,
compiler versions and hashes, source hashes, input hashes, and build times.

## Historical baseline (17 October 2026)

On 17 October 2026, an Intel i7-4790K running Linux produced the following
medians with seven timed runs and two warmups. C/C++ used GCC 15.2 and Rust
used 1.93.1. Hydrogen used the rebuilt native stage-1 compiler. Times are in
milliseconds and exclude source compilation.

| Workload        | Hydrogen | C    | Native / C | C++  | Native / C++ | Rust | Native / Rust |
| ---             | ---:     | ---: | ---:       | ---: | ---:         | ---: | ---:          |
| Integer loop    | 94.7     | 46.6 | 2.03×      | 45.8 |              | 40.4 |               |
| Array fill/scan | 157.1    | 63.9 | 2.46×      | 66.9 |              | 55.8 |               |
| Log scan        | 6.54     | 1.78 | 3.67×      | 5.37 |              | 2.83 |               |
| CSV aggregation | 4.27     | 1.87 | 2.29×      | 4.59 |              | 2.43 |               |
| Binary checksum | 15.2     | 7.76 | 1.96×      | 12.1 |              | 7.86 |               |
| Linked objects  | 4.51     | 1.52 | 2.96×      | 2.46 |              | 2.07 |               |

The self-hosted compiler previously allocated a new string on every evaluation
of a string literal. On this same hashed log input, the native scan took 8.07
seconds before literals were stored in executable data and 25.9 ms afterwards,
about 312 times faster. The pre-change samples are in
[`results-2026-10-17-before-literals.json`](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17-before-literals.json),
and the first full after-change samples are in
[`results-2026-10-17.json`](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17.json).

The compiler lowers signed `int` division by a positive constant with a
reciprocal multiply, and the runtime packs small objects into shared pages.
The next pass packed native `byte[]` and `int[]`, removed the string copy from
byte-file reads and writes, specialised one-byte literal comparison, encoded
numeric literal operations directly, and inlined checked packed-array
addresses. Against the [previous six-case run](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17-two-optimisations.json),
the loop improved from 136.1 to 94.7 ms, the array pass from 194.8 to
157.1 ms, the log scan from 25.5 to 6.54 ms, CSV from 9.65 to 4.27 ms,
and the binary checksum from 35.2 to 15.2 ms.

The short linked-object case varies with process startup. It measured 4.51 ms
in the seven-run table, while a separate [21-run check](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17-nodes-21-run.json)
measured 3.41 ms native and 1.22 ms C. The allocator's earlier 100,000-object
check measured 25.3 ms native. Its 20,000-object peak RSS diagnostic fell from
80,012 to 2,560 KB, and `mmap` calls from 20,013 to 650 (including startup).
Raw [17 October six-case](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17-main-issues.json) and
[100,000-object](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-17-nodes-100k.json) samples are retained.
See [optimisations.md](https://hylang.co.uk/performance/optimisation-evidence/) for the remaining ranked work.

These ratios depend on CPU, OS, input size, compiler versions, and load. In
particular, process startup dominates tiny runs; use the reference sizes or
larger when assessing steady execution. The six cases do not establish an
overall language speed ranking.

The later [25 October loop/array/byte code-generation comparison](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-25-loop-array-byte-codegen.json)
records 30 paired before/after runs after constant-remainder and conditional
branch improvements. Its matching checksums and compiler/executable hashes
are retained alongside the raw timings. See [optimisations.md](https://hylang.co.uk/performance/optimisation-evidence/)
for the diagnosis and remaining bounds-check work.

The [proven packed-array bounds comparison](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-25-proven-array-bounds.json)
records the narrow loop optimisation and its array improvement. A
[longer byte confirmation](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-25-proven-array-bounds-byte-confirm.json)
did not establish a byte-checksum speedup. The final
[direct-read and loop-entry check comparison](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-25-proven-packed-reads.json)
records 300 paired array runs and 200 paired byte runs with matching outputs,
compiler/binary hashes, and a measurable improvement in both cases. See
[optimisations.md](https://hylang.co.uk/performance/optimisation-evidence/) for the results and remaining costs.

## 29 October development check

The current `0.8.0` performance work is tracked by [#127](https://github.com/Aurora-softwares/Hylang-Compiler/issues/127)
and [#128](https://github.com/Aurora-softwares/Hylang-Compiler/issues/128); both remain In Progress.
With 21 runs and two warmups at the reference sizes, the updated native compiler
measured 71.45 ms for `loop`, 119.51 ms for `array`, 4.00 ms for `log`,
2.22 ms for `csv`, 12.42 ms for `bytes`, and 2.54 ms for `nodes`. The same
run's slowest C/C++/Rust comparison times were 44.98, 62.22, 4.88, 3.91,
11.44, and 1.90 ms respectively. Thus `log` and `csv` met the requested
slowest-comparison speed on this host; the other four cases did not. In
particular, array fill and scan still needs roughly a twofold improvement.
The [raw six-case run](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-29-loop-register.json)
records inputs, checksums, tool versions, and every sample. Paired change
measurements are described in the [optimisation evidence](/performance/optimisation-evidence/).

## 30 October development check

The next `0.8.0` native-codegen candidate keeps a guarded loop index, up to two
integer locals, and a stable packed-array pointer in registers where the loop
proof permits it. It also uses direct packed-array stores, shortens constant
remainder lowering, and elides a provably empty constructor call. The
[31-run six-case snapshot](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-10-30-register-and-allocation.json)
uses three warmups and the same reference sizes, checksums, and compiler flags.
Times below are whole-process medians in milliseconds; the target is the
*slowest* C, C++, or Rust median in the same run.

| Workload | Hydrogen native | Slowest comparison | Target met? |
| --- | ---: | ---: | --- |
| loop | 55.20 | 44.64 | No |
| array | 89.64 | 60.25 | No |
| log | 3.57 | 4.86 | Yes |
| csv | 2.01 | 3.86 | Yes |
| bytes | 10.04 | 11.16 | Yes |
| nodes | 2.46 | 1.93 | No |

The array fill and scan remains the largest miss at about 1.49 times the
target. Loop is about 1.24 times and nodes about 1.28 times the target. The
raw file retains every timed sample and the compiler/source hashes; these are
host measurements, not a cross-machine speed guarantee.

The [1 November follow-up](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-immediate-encoding.json)
uses the same 31-run method after the signed-immediate byte-writer repair. It
again meets the target for log, CSV, and bytes, with loop, array, and nodes
still above it. See the [optimisation evidence](/performance/optimisation-evidence/)
for the repair and remaining work.

## 1 November small-object allocation check

The Linux native runtime now leaves newly bumped small-object slots at their
zero-filled mapping defaults and clears reused slots only through the requested
payload. The collector scans that payload length. An alternating comparison
of executables built from the same workload source measured 20,000 nodes at
2.99 ms before and 2.81 ms after (150 pairs, 102 faster after), and 100,000
nodes at 15.43 ms before and 14.91 ms after (75 pairs, 49 faster after). Every
run checked exact output, exit status, and empty stderr. The [paired raw
samples](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-small-slot-zeroing-paired.json)
retain executable hashes and the candidate compiler hash.

The [31-run six-case snapshot](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-small-slot-zeroing.json)
uses the rebuilt stage-1 compiler, three warmups, reference sizes, and the
same exact-output checks. Whole-process medians in milliseconds are:

| Workload | Hydrogen native | Slowest C/C++/Rust | Target met? |
| --- | ---: | ---: | --- |
| loop | 55.34 | 44.79 | No |
| array | 86.87 | 58.36 | No |
| log | 3.62 | 4.85 | Yes |
| csv | 1.97 | 3.85 | Yes |
| bytes | 9.96 | 11.24 | Yes |
| nodes | 2.19 | 1.85 | No |

The array pass is still the largest miss, at about 1.49 times the target.
Loop is about 1.24 times and nodes about 1.18 times. The snapshot comparison
with earlier days does not isolate the allocator change; use the alternating
node pairs above for that attribution. The 0.8.0 optimisation work remains
In Progress in the [development project](https://github.com/orgs/Aurora-softwares/projects/4).

## 1 November guarded-index arithmetic check

For a zero-based index that the compiler proves stays nonnegative under a
strict loop bound, positive-constant division and remainder now omit the
unused signed correction branch. Other signed operands retain that path.
The [100-pair loop comparison](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-nonnegative-index-paired.json)
measured 55.29 to 54.80 ms, with 72 pairs faster after the change; the
20,000-node case was effectively unchanged. Exact output, exit status, and
empty stderr were checked for every run.

In the subsequent [31-run six-case snapshot](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-nonnegative-index.json),
Hydrogen measured 54.66 ms for loop, 87.45 for array, 4.23 for log, 2.07 for
CSV, 9.90 for bytes, and 2.20 for nodes. The respective slowest C/C++/Rust
medians were 44.66, 58.18, 4.85, 3.85, 11.29, and 1.88 ms. Log, CSV, and
bytes meet the target; loop, array, and nodes remain above it. Array arithmetic
is the next 0.8.0 performance target. Published release assets and a live
Windows install remain separate release gates.

## 1 November integer arithmetic fold

The native x64 compiler now combines two adjacent immediate `int` additions,
subtractions, or multiplications at 32-bit width before one final sign
extension. This retains the existing wrapping result, including at signed
limits. The [100-pair array comparison](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-folded-immediates-paired.json)
measured 88.59 to 87.90 ms, with 63 pairs faster after the change. Every run
checked exact output, successful exit, and empty stderr.

The [subsequent six-case snapshot](https://github.com/Aurora-softwares/Hylang-Compiler/blob/Development/assets/benchmarks/runtime/results-2026-11-01-folded-immediates.json)
measured Hydrogen at 54.64 ms for loop, 86.86 for array, 3.56 for log, 2.18
for CSV, 9.86 for bytes, and 2.21 for nodes. The respective slowest C/C++/Rust
medians were 44.62, 58.55, 4.74, 3.75, 11.25, and 1.93 ms. Log, CSV, and
bytes meet the target; loop, array, and nodes remain above it. The next
array target is profiling constant remainder arithmetic in the fill loop.
The 0.8.0 performance work stays In Progress.

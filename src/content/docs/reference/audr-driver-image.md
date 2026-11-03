---
title: "AUDR: Australis kernel driver images"
---

> Development reference from [Hylang-Compiler](https://github.com/Aurora-softwares/Hylang-Compiler/tree/Development). Commands and source paths on this page are relative to that repository checkout. For current task status, use the [development project](https://github.com/orgs/Aurora-softwares/projects/4).

`type = "driver"` projects produce `.driver` images. Build with `hy build
ExampleDriver.hyproj -o Example.driver`; `hy check` also validates that the
freestanding entry can be emitted. The entry is
`public static int DriverMain.Run(long context)`. An 11-byte entry shim bridges
the kernel's register call to Hydrogen's stack-argument calling convention.
Return zero for success; any other value rejects the call.

Projects without a `[driver]` section emit AUDR v1, whose `context` is the
physical `KernelBootInfo` address and whose entry runs once at load time.
To emit AUDR v2 with device matching, declare all match fields explicitly:

```toml
[driver]
abi = 2
match = "pci"
vendor = 65535
device = 65535
class = 12
subclass = 3
interface = 48
```

`match` may also be `"usb"`. `65535` is the vendor or device wildcard; `255` is the class, subclass, or
interface wildcard. At least one field must be specific. Invalid or incomplete
declarations fail `hy check` and `hy build` without replacing an output image.

All integers in the image header are little endian. The image has a 24-byte
v1 or 48-byte v2 header followed by 1–65,536 bytes (v1) or 1–1,048,576 bytes
(v2) of native x86-64 code:

| Offset | Size | Value |
| --- | ---: | --- |
| 0 | 4 | ASCII `AUDR` |
| 4 | 1 | format version `1` or `2` |
| 5 | 1 | entry ABI, equal to the format version |
| 6 | 2 | flags `0` |
| 8 | 4 | code length |
| 12 | 4 | entry offset `0` |
| 16 | 4 | IEEE CRC-32 of bytes from offset 24 through the end of the image |
| 20 | 4 | reserved `0` |
| 24 | 24 for v2 only | six little-endian 32-bit fields: match kind (`1` PCI or `2` USB), vendor, device, class, subclass, interface |
| 24 (v1) or 48 (v2) | code length | position-independent code |

The v2 entry runs when its device matches. Its `context` points to a temporary,
zeroed kernel page with version at byte 0, match kind at 4, boot-info address at
8, vendor/device at 16/20, device key at 24, MMIO address/length at 32/40,
class/subclass/interface at 48/52/56, and operation `1` (probe) at 64. The
entry writes a 32-bit probe result from 1 to 255 at 72. The context page is freed
after the call and cannot be retained. Exact vendor/device matches outrank class
matches; ties follow `/drivers.list` order. A failed probe falls through to the
next match, then the built-in operation. Australis currently invokes this path
for the PCI xHCI capability-length probe. USB metadata and a corresponding
kernel match method exist, but USB enumeration does not invoke it yet.

Australis loads only paths listed, one per line, in `/drivers.list` on the
system volume. Paths must be absolute, end in `.driver`, and use ASCII letters,
digits, `/`, `-`, `_`, or `.`. Example:

```text
/Example.driver
```

The loader accepts at most eight drivers and retains successfully initialized
code until shutdown. An absent manifest has no effect on existing built-in
drivers. A bad manifest or image is rejected and logged on the serial console.

**Trust boundary:** AUDR modules run with kernel privileges and can access
hardware and kernel memory. CRC-32 detects accidental damage; it does not
authenticate a publisher. Only install modules from trusted sources on a
trusted system volume. AUDR v2 currently selects a bounded probe operation;
DMA ownership, interrupt registration, long-lived callbacks, unload,
signatures, and isolation are not implemented. The built-in xHCI controller
still owns USB I/O after its capability-length probe is supplied by a v2
module.

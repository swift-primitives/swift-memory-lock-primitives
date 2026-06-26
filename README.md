# Memory Lock Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Page-locking vocabulary for Swift — a `Memory.Lock` namespace of reader-writer lock kinds, an RAII release token, and syscall error types, with zero platform dependencies.

---

## Quick Start

`Memory.Lock` holds the *shapes* of memory page-locking, not the syscalls: which kind of lock is wanted (`.shared` vs `.exclusive`), an ownership-enforcing handle that releases on scope exit (`Token`), and the failure cases a platform layer can report (`Error`). The lock/unlock syscalls themselves live in downstream platform packages — POSIX `mlock`/`munlock` in [swift-iso-9945](https://github.com/swift-standards/swift-iso-9945), `VirtualLock`/`VirtualUnlock` in [swift-windows-standard](https://github.com/swift-standards/swift-windows-standard) — and they implement against this shared vocabulary.

```swift
import Memory_Lock_Primitives

// Reader-writer intent for a memory-mapping coordination point.
let kind: Memory.Lock.Kind = .exclusive   // .shared allows concurrent readers

// A platform/L3 package that knows how to acquire the OS lock mints a token,
// capturing whatever it needs to undo the lock in the release witness.
var heldByUs = true
var token = Memory.Lock.Token {
    heldByUs = false   // runs exactly once — on release() or deinit, whichever is first
}

// Release explicitly, or just let the token leave scope: deinit runs the witness.
token.release()   // idempotent
print(kind, heldByUs)   // exclusive false
```

`Memory.Lock.Token` is `~Copyable`, so the lock cannot be silently duplicated — single ownership is enforced by the type system, and the release witness fires once. `Memory.Lock.Kind` is `Sendable`, `Equatable`, and `Hashable`. `Memory.Lock.Error` enumerates the four failure points — `.lock`, `.unlock`, `.lockAll`, `.unlockAll` — each carrying an `Error_Primitives.Error.Code`, and prints the failed syscall via `CustomStringConvertible`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-memory-lock-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Memory Lock Primitives", package: "swift-memory-lock-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain). This package is a sibling extraction of [swift-memory-primitives](https://github.com/swift-primitives/swift-memory-primitives), which supplies the `Memory` namespace it extends.

---

## Architecture

Two library products. Depends only on the `Memory` namespace ([swift-memory-primitives](https://github.com/swift-primitives/swift-memory-primitives)) and `Error.Code` ([swift-error-primitives](https://github.com/swift-primitives/swift-error-primitives)), both re-exported.

| Product | Target | Purpose |
|---------|--------|---------|
| `Memory Lock Primitives` | `Sources/Memory Lock Primitives/` | The `Memory.Lock` namespace: `Kind` (`.shared` / `.exclusive` reader-writer semantics), `Token` (the `~Copyable` RAII release handle), and `Error` (`.lock` / `.unlock` / `.lockAll` / `.unlockAll` syscall failures). |
| `Memory Lock Primitives Test Support` | `Tests/Support/` | Re-exports the main target for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).

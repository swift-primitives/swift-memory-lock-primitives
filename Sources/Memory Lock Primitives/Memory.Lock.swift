// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-memory-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-memory-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Memory {
    /// Raw page locking syscall vocabulary.
    ///
    /// ## Platform Implementation
    ///
    /// Syscall implementations are in platform-specific packages:
    /// - POSIX: `swift-iso-9945` (`extension Memory.Lock`)
    /// - Windows: `swift-windows-standard` (`extension Memory.Lock`)
    ///
    /// For mlockall/munlockall (POSIX-only), see `swift-iso-9945`.
    public enum Lock {}
}

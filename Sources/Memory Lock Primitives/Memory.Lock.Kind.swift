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

extension Memory.Lock {
    /// Lock type determining concurrency behavior for memory-mapping coordination.
    ///
    /// Reader-writer semantics: multiple readers can proceed concurrently;
    /// writers require exclusive access.
    ///
    /// ## Compatibility
    ///
    /// | Held Lock | `.shared` request | `.exclusive` request |
    /// |-----------|-------------------|----------------------|
    /// | None | Granted | Granted |
    /// | `.shared` | Granted | Blocked |
    /// | `.exclusive` | Blocked | Blocked |
    public enum Kind: Sendable, Equatable, Hashable {
        /// Shared (read) lock allowing concurrent access.
        case shared

        /// Exclusive (write) lock preventing all other access.
        case exclusive
    }
}

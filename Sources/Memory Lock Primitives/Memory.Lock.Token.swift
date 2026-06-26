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
    /// RAII lock token for memory-mapping coordination.
    ///
    /// Holds a witness closure that releases the underlying lock on `release()`
    /// or `deinit`, whichever comes first. The token is `~Copyable` to enforce
    /// single-ownership at the type level.
    ///
    /// ## Construction
    ///
    /// Tokens are constructed by L3 packages (e.g., `swift-memory`) that know
    /// how to acquire the underlying file lock. The closure captures the
    /// typed file descriptor (via `var Optional + .take()`) and lock-range
    /// needed to release the lock.
    ///
    /// ## Thread Safety
    ///
    /// Designed for single-ownership. The lock is released when `release()`
    /// is called or when the token is dropped.
    ///
    /// ## Sendability
    ///
    /// Token is **not** `Sendable`. The witness closure captures a typed
    /// `~Copyable` resource (e.g., `Kernel.Descriptor`) via `var Optional`,
    /// which Swift forbids inside `@Sendable` closures. Since Token is held
    /// inside `Memory.Map` (which is `@unchecked Sendable` for distinct
    /// architectural reasons — raw mapping bytes), the parent's escape hatch
    /// absorbs the Sendable invariant per the Item 1.5 Path δ disposition
    /// (2026-05-02). Cross-thread transfer of a Token-bearing Memory.Map
    /// remains supported via Memory.Map's existing `@unchecked Sendable`.
    public struct Token: ~Copyable {
        @usableFromInline
        var _release: (() -> Void)?

        /// Creates a lock token with a release witness closure.
        ///
        /// - Parameter release: Closure invoked exactly once on `release()` or `deinit`.
        @inlinable
        public init(release: @escaping () -> Void) {
            self._release = release
        }

        /// Releases the lock immediately.
        ///
        /// Idempotent: calling it more than once has no further effect, and the
        /// release witness runs exactly once.
        @inlinable
        public mutating func release() {
            _release?()
            _release = nil
        }

        deinit {
            _release?()
        }
    }
}

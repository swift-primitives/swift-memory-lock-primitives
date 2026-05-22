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

public import Error_Primitives

extension Memory.Lock {
    /// Errors from page locking syscalls.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// mlock / VirtualLock failed.
        case lock(Error_Primitives.Error.Code)

        /// munlock / VirtualUnlock failed.
        case unlock(Error_Primitives.Error.Code)

        /// mlockall failed (POSIX only).
        case lockAll(Error_Primitives.Error.Code)

        /// munlockall failed (POSIX only).
        case unlockAll(Error_Primitives.Error.Code)
    }
}

// MARK: - CustomStringConvertible

extension Memory.Lock.Error: CustomStringConvertible {
    public var description: Swift.String {
        switch self {
        case .lock(let code):
            return "mlock failed: \(code)"
        case .unlock(let code):
            return "munlock failed: \(code)"
        case .lockAll(let code):
            return "mlockall failed: \(code)"
        case .unlockAll(let code):
            return "munlockall failed: \(code)"
        }
    }
}

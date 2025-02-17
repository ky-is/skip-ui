// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public enum Axis : Int, Hashable, CaseIterable, Sendable {
    case horizontal = 1
    case vertical = 2

    public struct Set : OptionSet, Hashable, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let horizontal: Axis.Set = Axis.Set(Axis.horizontal)
        public static let vertical: Axis.Set = Axis.Set(Axis.vertical)

        public init(_ axis: Axis) {
            self.rawValue = axis.rawValue
        }
    }
}

#endif

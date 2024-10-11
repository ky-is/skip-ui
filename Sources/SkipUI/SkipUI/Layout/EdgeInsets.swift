// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

public struct EdgeInsets : Equatable, Sendable {
    public var top: CGFloat
    public var leading: CGFloat
    public var bottom: CGFloat
    public var trailing: CGFloat

    public init(top: CGFloat = 0.0, leading: CGFloat = 0.0, bottom: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    #if SKIP
    @Composable func asPaddingValues() -> PaddingValues {
        return PaddingValues(start: leading.dp, top: top.dp, end: trailing.dp, bottom: bottom.dp)
    }
    #endif
}

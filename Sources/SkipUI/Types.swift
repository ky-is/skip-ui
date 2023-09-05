// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
public typealias CGFloat = Double

public struct CGSize: Hashable {
    public static let zero = CGSize()
    public var width = 0.0
    public var height = 0.0
}

#else

/// No-op
func stub<T>() -> T {
    fatalError("stub")
}

// SkipUI.kt:13:14 'Nothing' return type can't be specified with type alias
public typealias Nothing = Never


/// No-op
func stubView() -> some View {
    return EmptyView()
}

/// No-op
@usableFromInline func never() -> Nothing {
    stub()
}

public typealias NeverView = Never

/// A stub view
public struct StubView : View {
    public typealias Body = Never
    public var body: Body {
        fatalError()
    }
}

#endif
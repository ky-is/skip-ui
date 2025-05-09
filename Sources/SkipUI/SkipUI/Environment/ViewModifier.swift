// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import SkipModel
#if SKIP
import androidx.compose.runtime.Composable
#endif

// SKIP @bridge
public protocol ViewModifier {
    #if SKIP
    // SKIP DECLARE: fun body(content: View): View = content
    @ViewBuilder @MainActor func body(content: View) -> any View
    typealias Content = View
    #else
//    associatedtype Body : View
//    @ViewBuilder @MainActor func body(content: Self.Content) -> Self.Body
//    associatedtype Content
    #endif
}

#if SKIP
extension ViewModifier {
    /// Compose this modifier's content.
    @Composable public func Compose(content: Content, context: ComposeContext) -> Void {
        // Unfortunately we can't use try/finally around a @Composable invocation
        StateTracking.pushBody()
        body(content: content).Compose(context: context)
        StateTracking.popBody()
    }
}
#endif

extension View {
    // SKIP @bridge
    public func modifier(_ viewModifier: any ViewModifier) -> any View {
        #if SKIP
        return ComposeModifierView(contentView: self) { view, context in
            viewModifier.Compose(content: view, context: context)
        }
        #else
        return self
        #endif
    }
}

#if false
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier where Self.Body == Never {

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    public func body(content: Self.Content) -> Self.Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new modifier that is the result of concatenating
    /// `self` with `modifier`.
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewModifier {

    /// Returns a new version of the modifier that will apply the
    /// transaction mutation function `transform` to all transactions
    /// within the modifier.
//    public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier { fatalError() }


    /// Returns a new version of the modifier that will apply
    /// `animation` to all animatable values within the modifier.
//    public func animation(_ animation: Animation?) -> some ViewModifier { fatalError() }

}

#endif
#endif

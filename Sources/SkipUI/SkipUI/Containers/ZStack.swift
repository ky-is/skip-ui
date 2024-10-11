// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

public struct ZStack : View {
    let alignment: Alignment
    let content: ComposeBuilder

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> any View) {
        self.alignment = alignment
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let views = content.collectViews(context: context)
        let idMap: (View) -> Any? = { TagModifierView.strip(from = it, role = ComposeModifierRole.id)?.value }
        let ids = views.compactMap(transform = idMap)
        let rememberedIds = remember { mutableSetOf<Any>() }
        let newIds = ids.filter { !rememberedIds.contains($0) }
        let rememberedNewIds = remember { mutableSetOf<Any>() }

        rememberedNewIds.addAll(newIds)
        rememberedIds.clear()
        rememberedIds.addAll(ids)

        if ids.count < views.count {
            rememberedNewIds.clear()
            let contentContext = context.content()
            ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
                Box(modifier: modifier, contentAlignment: alignment.asComposeAlignment()) {
                    views.forEach { $0.Compose(context: contentContext) }
                }
            }
        } else {
            ComposeContainer(eraseAxis: true, modifier: context.modifier) { modifier in
                let arguments = AnimatedContentArguments(views: views, idMap: idMap, ids: ids, rememberedIds: rememberedIds, newIds: newIds, rememberedNewIds: rememberedNewIds, composer: nil)
                ComposeAnimatedContent(context: context, modifier: modifier, arguments: arguments)
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalAnimationApi::class)
    @Composable private func ComposeAnimatedContent(context: ComposeContext, modifier: Modifier, arguments: AnimatedContentArguments) {
        AnimatedContent(modifier: modifier, targetState: arguments.views, transitionSpec: {
            // SKIP INSERT: EnterTransition.None togetherWith ExitTransition.None
        }, contentKey: {
            $0.map(arguments.idMap)
        }, content: { state in
            let animation = Animation.current(isAnimating: transition.isRunning)
            if animation == nil {
                arguments.rememberedNewIds.clear()
            }
            Box(contentAlignment: alignment.asComposeAlignment()) {
                for view in state {
                    let id = arguments.idMap(view)
                    var modifier: Modifier = Modifier
                    if let animation, arguments.newIds.contains(id) || arguments.rememberedNewIds.contains(id) || !arguments.ids.contains(id) {
                        let transition = TransitionModifierView.transition(for: view) ?? OpacityTransition.shared
                        let spec = animation.asAnimationSpec()
                        let enter = transition.asEnterTransition(spec: spec)
                        let exit = transition.asExitTransition(spec: spec)
                        modifier = modifier.animateEnterExit(enter: enter, exit: exit)
                    }
                    view.Compose(context: context.content(modifier: modifier))
                }
            }
        }, label: "ZStack")
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if false

// TODO: Process for use in SkipUI

/// An overlaying container that you can use in conditional layouts.
///
/// This layout container behaves like a ``ZStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``ZStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ZStackLayout : Layout {
    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }

    /// Creates a stack with the specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack
    ///     on both the x- and y-axes.
    @inlinable public init(alignment: Alignment = .center) { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Void

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ZStackLayout : Sendable {
}

#endif

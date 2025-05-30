// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.drawscope.DrawStyle
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp

public enum CGLineCap : Int {
    case butt = 0 // For bridging
    case round = 1 // For bridging
    case square = 2 // For bridging

}
public enum CGLineJoin : Int {
    case miter = 0 // For bridging
    case round = 1 // For bridging
    case bevel = 2 // For bridging
}
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
import enum CoreGraphics.CGLineCap
import enum CoreGraphics.CGLineJoin
#endif

public struct StrokeStyle : Equatable {
    public var lineWidth: CGFloat
    public var lineCap: CGLineCap
    public var lineJoin: CGLineJoin
    public var miterLimit: CGFloat
    public var dash: [CGFloat]
    public var dashPhase: CGFloat

    public init(lineWidth: CGFloat = 1.0, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10.0, dash: [CGFloat] = [], dashPhase: CGFloat = 0.0) {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }

    #if SKIP
    @Composable func asDrawStyle() -> DrawStyle {
        let density = LocalDensity.current
        let widthPx = with(density) { lineWidth.dp.toPx() }
       
        let cap: StrokeCap
        switch lineCap {
        case CGLineCap.butt:
            cap = StrokeCap.Butt
        case CGLineCap.round:
            cap = StrokeCap.Round
        case CGLineCap.square:
            cap = StrokeCap.Square
        }

        let join: StrokeJoin
        switch lineJoin {
        case CGLineJoin.bevel:
            join = StrokeJoin.Bevel
        case CGLineJoin.round:
            join = StrokeJoin.Round
        case CGLineJoin.miter:
            join = StrokeJoin.Miter
        }

        var pathEffect: PathEffect? = nil
        if !dash.isEmpty {
            let intervals = FloatArray(max(2, dash.count)) { element in
                with(density) { dash[min(element, dash.count - 1)].dp.toPx() }
            }
            let phase = with(density) { dashPhase.dp.toPx() }
            pathEffect = PathEffect.dashPathEffect(intervals, phase)
        }
        return Stroke(width = widthPx, miter = Float(miterLimit), cap, join, pathEffect)
    }
    #endif
}

#endif

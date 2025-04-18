// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import SkipModel

import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.remember

// Model State as a class rather than struct to mutate by reference and avoid copy overhead.
public final class FocusState<Value>: StateTracker {
    public init() {
        _wrappedValue = false as! Value
        StateTracking.register(self)
    }

    /// Used by the transpiler to handle both `Bool` and `Hashable` types.
    public init(initialValue: Value) {
        _wrappedValue = initialValue
        StateTracking.register(self)
    }

    public var wrappedValue: Value {
        get {
            if let _wrappedValueState {
                return _wrappedValueState.value
            }
            return _wrappedValue
        }
        set {
            _wrappedValue = newValue
            _wrappedValueState?.value = _wrappedValue
        }
    }
    private var _wrappedValue: Value
    private var _wrappedValueState: MutableState<Value>?

    public var projectedValue: Binding<Value> {
        return Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }

    public func trackState() {
        _wrappedValueState = mutableStateOf(_wrappedValue)
    }
}
#endif

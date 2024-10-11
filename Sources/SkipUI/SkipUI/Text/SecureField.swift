// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

@available(iOS 16.0, macOS 14.0, *)
public struct SecureField : View {
    let textField: TextField

    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> any View) {
        textField = TextField(text: text, prompt: prompt, isSecure: true, label: label)
    }

    public init(_ title: String, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { Text(titleKey) })
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        textField.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

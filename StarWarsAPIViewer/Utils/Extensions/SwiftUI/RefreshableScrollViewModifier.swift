//
//  RefreshableScrollViewModifier.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 30.06.2023.
//

import SwiftUI

/// Source: https://dev.to/gualtierofr/pull-down-to-refresh-in-swiftui-4j26
struct RefreshableScrollViewModifier<BottomContent: View>: ViewModifier {
    private let belowIOS15Input: (action: () -> Void, isRefreshing: Binding<Bool>)
    private let fromIOS15Action: () async -> Void
    private let bottomContent: () -> BottomContent

    func body(content: Content) -> some View {
        RefreshableScrollView(
            belowIOS15Input: belowIOS15Input,
            fromIOS15Action: fromIOS15Action,
            content: { content },
            bottomContent: { bottomContent() }
        )
    }
    
    init(
        belowIOS15Input: (action: () -> Void, isRefreshing: Binding<Bool>),
        fromIOS15Action: @escaping () async -> Void,
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.belowIOS15Input = belowIOS15Input
        self.fromIOS15Action = fromIOS15Action
        self.bottomContent = bottomContent
    }
}

private struct RefreshableScrollView<Content: View, BottomContent: View>: View {
    private let content: () -> Content
    private let bottomContent: () -> BottomContent
    /* Below iOS 15 */
    @Binding private var isRefreshing: Bool
    private let belowIOS15Action: () -> Void
    /* iOS 15 and later */
    private let fromIOS15Action: () async -> Void
    
    private let threshold:CGFloat = 50.0
    
    init(
        belowIOS15Input: (action: () -> Void, isRefreshing: Binding<Bool>),
        fromIOS15Action: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.content = content
        self.bottomContent = bottomContent
        self._isRefreshing = belowIOS15Input.isRefreshing
        self.belowIOS15Action = belowIOS15Input.action
        self.fromIOS15Action = fromIOS15Action
    }
    var body: some View {
        if #available(iOS 15, *) {
            ScrollView {
                content()
                bottomContent()
            }
            .refreshable {
                await fromIOS15Action()
            }
        } else {
            GeometryReader { geometry in
                ScrollView {
                    if isRefreshing {
                        VStack {
                            ProgressView()
                            Text("Refreshing...")
                        }
                    }
                    
                    content()
                        .anchorPreference(key: OffsetPreferenceKey.self, value: .top) { value -> CGFloat in
                            geometry[value].y
                        }
                    bottomContent()
                }
                .onPreferenceChange(OffsetPreferenceKey.self) { offset in
                    if offset > threshold {
                        belowIOS15Action()
                    }
                }
            }
        }
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//
//  RefreshableScrollViewModifier.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 30.06.2023.
//

import SwiftUI

/// Source: https://dev.to/gualtierofr/pull-down-to-refresh-in-swiftui-4j26
struct RefreshableScrollViewModifier: ViewModifier {
    let belowIOS15Action: () -> Void
    let fromIOS15Action: () async -> Void
    let isRefreshing: Binding<Bool>

    func body(content: Content) -> some View {
        RefreshableScrollView(isRefreshing: isRefreshing, belowIOS15Action: belowIOS15Action, fromIOS15Action: fromIOS15Action) {
            content
        }
    }
}

private struct RefreshableScrollView<Content: View>: View {
    @Binding private var isRefreshing: Bool
    private let content: () -> Content
    private let belowIOS15Action: () -> Void
    private let fromIOS15Action: () async -> Void
    private let threshold:CGFloat = 50.0
    
    init(
        isRefreshing: Binding<Bool>,
        belowIOS15Action: @escaping () -> Void,
        fromIOS15Action: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isRefreshing = isRefreshing
        self.content = content
        self.belowIOS15Action = belowIOS15Action
        self.fromIOS15Action = fromIOS15Action
    }
    var body: some View {
        if #available(iOS 15, *) {
            ScrollView {
                content()
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
                        .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                            geometry[$0].y
                        }
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

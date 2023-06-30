//
//  RefreshableScrollViewModifier.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 30.06.2023.
//

import SwiftUI

struct RefreshableScrollViewModifier: ViewModifier {
    let action: () -> Void
    let isRefreshing: Binding<Bool>

    func body(content: Content) -> some View {
        RefreshableScrollView(isRefreshing: isRefreshing, action: action) {
            content
        }
    }
}

private struct RefreshableScrollView<Content: View>: View {
    @Binding private var isRefreshing: Bool
    private let content: () -> Content
    private let refreshAction: () -> Void
    private let threshold:CGFloat = 50.0
    
    init(
        isRefreshing: Binding<Bool>,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isRefreshing = isRefreshing
        self.content = content
        self.refreshAction = action
    }
    var body: some View {
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
                    refreshAction()
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

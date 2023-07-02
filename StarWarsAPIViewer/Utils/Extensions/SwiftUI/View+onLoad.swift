//
//  View+onLoad.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 02.07.2023.
//

import SwiftUI

/// A modifier that performs an action only once when the view appears.
struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)

    init(perform action: @escaping (() -> Void)) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action()
            }
        }
    }
}

extension View {
    // Adds a modifier that performs the given action only once when the view appears.
    /// - Parameter action: The action to be performed when the view loads.
    /// - Returns: A modified view with the action performed on appearance.
    func onLoad(perform action: @escaping (() -> Void)) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

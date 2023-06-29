//
//  View+Navigation.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

extension View {
    /// Creates a navigation link with an associated item and destination view. The navigation link will be active as long as the item is not nil.
    /// - Parameters:
    ///   - item: The item associated with the navigation link.
    ///   - destination: A closure that creates the destination view based on the associated item.
    /// - Returns: A modified view that behaves as a navigation link.
    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }
    
    /// Creates a navigation link with an explicitly provided destination view.
    /// - Parameters:
    ///   - isActive: A binding that indicates whether the navigation link is active.
    ///   - destination: A closure that creates the destination view.
    /// - Returns: A modified view that behaves as a navigation link.
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }
}

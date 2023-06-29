//
//  StarWarsSpaceView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct StarWarsSpaceView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController(nibName: String(describing: self), bundle: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Nothing to do
    }
}

//
//  StarWarsSpaceView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct StarWarsSpaceView<ViewModel: StarWarsSpaceViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        StarWarsSpaceViewWrapper(onButtonTap: { viewModel.handle(.didTapBrowsePlanets) })
            .ignoresSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SWAPI")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - StarWarsSpaceViewWrapper

private struct StarWarsSpaceViewWrapper: UIViewControllerRepresentable {
    let onButtonTap: () -> Void
    
    func makeUIViewController(context: Context) -> StarWarsSpaceViewController {
        let view = StarWarsSpaceViewController(nibName: "StarWarsSpaceViewController", bundle: nil)
        view.onButtonTap = { onButtonTap() }
        return view
    }
    
    func updateUIViewController(_ uiViewController: StarWarsSpaceViewController, context: Context) {
        // Nothing to do
    }
}

// MARK: - StarWarsSpaceViewController

private final class StarWarsSpaceViewController: UIViewController {
    @IBOutlet private weak var browsePlanetsButton: UIButton!
    var onButtonTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browsePlanetsButton.accessibilityIdentifier = "browsePlanetsButton"
    }
    
    @IBAction
    private func onButtonTap(sender: UIButton) {
        onButtonTap?()
    }
}

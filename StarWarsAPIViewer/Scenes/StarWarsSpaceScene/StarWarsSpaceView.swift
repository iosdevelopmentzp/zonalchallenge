//
//  StarWarsSpaceView.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import SwiftUI

struct StarWarsSpaceView<ViewModel: StarWarsSpaceViewModelProtocol>: View {
    // MARK: - Properties
    
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
    
    // MARK: - Constructor
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - StarWarsSpaceViewWrapper

private struct StarWarsSpaceViewWrapper: UIViewControllerRepresentable {
    // MARK: - Properties
    
    let onButtonTap: () -> Void
    
    // MARK: - UIViewControllerRepresentable
    
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
    // MARK: - Properties
    
    @IBOutlet private weak var browsePlanetsButton: UIButton!
    var onButtonTap: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browsePlanetsButton.accessibilityIdentifier = "browsePlanetsButton"
    }
    
    // MARK: - IBAction
    
    @IBAction
    private func onButtonTap(sender: UIButton) {
        onButtonTap?()
    }
}

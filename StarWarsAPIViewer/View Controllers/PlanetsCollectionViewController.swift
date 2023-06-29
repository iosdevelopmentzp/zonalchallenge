//
//  PlanetsCollectionViewController.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

import UIKit

class PlanetsCollectionViewController: UICollectionViewController {
    
    private let planetCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Planet> { cell, indexPath, planet in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = planet.name
        configuration.secondaryText = "Population: \(planet.population)"
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<PlanetSnapshotProvider.PlanetSections, Planet> = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, planet in
        return collectionView.dequeueConfiguredReusableCell(using: self.planetCellRegistration, for: indexPath, item: planet)
    }
    
    private let snapshotProvider = PlanetSnapshotProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = dataSource
        let listAppearance = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: listAppearance)
        snapshotProvider.onSnapshotUpdate = { snapshot in
            self.dataSource.apply(snapshot)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        snapshotProvider.fetch()
    }
}

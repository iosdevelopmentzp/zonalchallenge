//
//  PlanetsViewSceneDelegate.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 29.06.2023.
//

import Foundation

protocol PlanetsViewSceneDelegate: AnyObject {
    /// Notifies the delegate to open the details view for a specific planet.
    func openPlanetDetails(with planetId: Int)
}

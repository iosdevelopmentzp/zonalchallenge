//
//  MockedError.swift
//  StarWarsAPIViewer
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

#if DEBUG

enum MockedError: LocalizedError, Equatable {
    case generic
    case localizedDescription(_ description: String)
    
    var errorDescription: String? {
        switch self {
        case .localizedDescription(let description):
            return description
            
        case .generic:
            return "Generic mocked error"
        }
    }
}

#endif

//
//  Resolver.swift
//  
//
//  Created by Dmytro Vorko on 03.07.2023.
//

import Foundation

public enum ResolveStrategy {
    case alwaysNewInstance
    case permanentInstance
}

public protocol ResolverType {
    func resolve<T>() -> T
    func register<T>(type: T.Type, strategy: ResolveStrategy, resolver: @escaping (ResolverType) -> T)
}

public extension ResolverType {
    func register<T>(type: T.Type, resolver: @escaping (ResolverType) -> T) {
        return register(type: type, strategy: .alwaysNewInstance, resolver: resolver)
    }
}

public final class Resolver {
    // MARK: - Nested
    
    public struct ResolverProvider<T> {
        let strategy: ResolveStrategy
        let provider: (ResolverType) -> T
    }
    
    // MARK: - Properties
    
    private var resolvers: [String: Any] = [:]
    private var permanentInstances: [String: Any] = [:]
    
    // MARK: - Constructor
    
    public init() {}
}

// MARK: - ResolverType

extension Resolver: ResolverType {
    public func register<T>(type: T.Type, strategy: ResolveStrategy, resolver: @escaping (ResolverType) -> T) {
        let resolverProvider = ResolverProvider(strategy: strategy, provider: resolver)
        resolvers[String(describing: T.self)] = resolverProvider
    }
    
    public func resolve<T>() -> T {
        let resolver = resolvers[String(describing: T.self)]
        
        guard let resolverProvider = resolver as? ResolverProvider<T> else {
            fatalError("The resolver for type \(T.self) has not been registered")
        }
        
        switch resolverProvider.strategy {
        case .alwaysNewInstance:
            return resolverProvider.provider(self)
            
        case .permanentInstance:
            return {
                guard let permanentInstance = permanentInstances[String(describing: T.self)] as? T else {
                    let instance = resolverProvider.provider(self)
                    permanentInstances[String(describing: T.self)] = instance
                    return instance
                }
                return permanentInstance
            }()
        }
    }
}

//
//  SpaceshipView.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 22/07/2021.
//

import UIKit

class SpaceshipView: UIView {
    
    private static var starImage: UIImage = {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        let image = renderer.image { context in
            let starPath = UIBezierPath(ovalIn:rect)
            UIColor.white.setFill()
            starPath.fill()
        }
        return image
    }()
    
    private static var shipImage = UIImage(imageLiteralResourceName: "spaceship")

    private lazy var thrustLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [thrustEmitterCell]
        emitterLayer.emitterPosition = CGPoint(x: layer.bounds.width / 2.0, y: 0)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: 0.5, height: 1)
        return emitterLayer
    }()
    
    private lazy var thrustEmitterCell: CAEmitterCell = {
        let thrustEmitterCell = CAEmitterCell()
        thrustEmitterCell.color = UIColor.orange.cgColor
        thrustEmitterCell.contents = SpaceshipView.starImage.cgImage
        thrustEmitterCell.lifetime = 3
        thrustEmitterCell.birthRate = 15
        thrustEmitterCell.alphaSpeed = -0.9
        thrustEmitterCell.velocity = -100
        thrustEmitterCell.scale = 0.1

        return thrustEmitterCell
    }()
    
    private let shipImageView: UIImageView
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override init(frame: CGRect) {
        shipImageView = UIImageView(image: SpaceshipView.shipImage.withRenderingMode(.alwaysTemplate).withTintColor(.red))
        shipImageView.frame = frame
        super.init(frame: frame)
        layer.addSublayer(thrustLayer)
        addSubview(shipImageView)

    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        guard let thrustSuperLayer = thrustLayer.superlayer else {
            return
        }
        thrustLayer.emitterPosition = CGPoint(x: thrustSuperLayer.bounds.width / 2.0, y: (thrustSuperLayer.bounds.maxY/4)*3)
    }

}

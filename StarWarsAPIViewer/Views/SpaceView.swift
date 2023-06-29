//
//  SpaceView.swift
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 21/07/2021.
//

import UIKit

class SpaceView: UIView {
    
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

    private lazy var starLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [starEmitterCell]
        emitterLayer.emitterPosition = CGPoint(x: layer.bounds.width / 2.0, y: -100)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: layer.bounds.width, height: 1)
        return emitterLayer
    }()
    
    private lazy var starEmitterCell: CAEmitterCell = {
        let starEmitterCell = CAEmitterCell()
        starEmitterCell.color = UIColor.white.cgColor
        starEmitterCell.contents = SpaceView.starImage.cgImage
        starEmitterCell.lifetime = 10
        starEmitterCell.birthRate = 5
        starEmitterCell.alphaRange = 0.4
        starEmitterCell.velocity = -100
        starEmitterCell.velocityRange = 99
        starEmitterCell.scale = 0.0001
        starEmitterCell.scaleRange = 0.1
        //starEmitterCell.xAcceleration = -70

        
        return starEmitterCell
    }()
    
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self,
                                        selector: #selector(updateShipPosition))
        
        return displayLink
    }()
    
    private let shipImageDimension: CGFloat = 50
    private var nextPositionDecisionTimestamp = CFTimeInterval(0)
    private var shipDeltaX: CGFloat = 1
    private var shipDeltaY: CGFloat = 1
    private let spaceshipView: SpaceshipView

    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        spaceshipView = SpaceshipView(frame: CGRect(origin: .zero, size: CGSize(width: shipImageDimension, height: shipImageDimension)))
        spaceshipView.translatesAutoresizingMaskIntoConstraints = false
        super.init(coder: coder)
        backgroundColor = .black
        layer.addSublayer(starLayer)
        displayLink.add(to: .current,
                        forMode: .default)
        addSubview(spaceshipView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spaceshipView.frame = CGRect(origin: CGPoint(x: frame.midX - (shipImageDimension / 2), y: frame.maxY - shipImageDimension), size: CGSize(width: shipImageDimension, height: shipImageDimension))
    }
    
    @objc func updateShipPosition(_ displayLink: CADisplayLink) {
        
        //Only change ship direction at random intervals
        if Bool.random(){
            let willGoUp = Bool.random()
            let willGoLeft = Bool.random()
            shipDeltaX = (willGoLeft ? 1 : -1)
            shipDeltaY = (willGoUp ? 1 : -1)

        }
        let previousFrame = spaceshipView.frame
        
        //Keeps the new frame within the bounds of this view's frame
        let newY = max(min(previousFrame.origin.y + shipDeltaY, frame.maxY - shipImageDimension), 0)
        let newX = max(min(previousFrame.origin.x + shipDeltaX, frame.maxX - shipImageDimension), 0)
        spaceshipView.frame = CGRect(x: newX, y: newY, width: shipImageDimension, height: shipImageDimension)
        
    }

}

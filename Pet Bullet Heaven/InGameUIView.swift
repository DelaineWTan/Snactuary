//
//  InGameUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//

import UIKit

class InGameUIView: UIView {
    var pauseButtonTappedHandler: (() -> Void)?
    var isStickVisible = false
    var innerCircleLayer: CAShapeLayer?
    var outerCircleLayer: CAShapeLayer?
    
    var innerCircleInitialCenterPoint: CGPoint?
    var lastLocation: CGPoint?
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public func setStickPosition(location: CGPoint) {
        // translate gesture plot to UI kit plot
        let xLocation = location.x - bounds.maxX/2
        let yLocation = location.y - bounds.maxY/2
        
        innerCircleLayer?.position.x = xLocation
        innerCircleLayer?.position.y = yLocation
        
        outerCircleLayer?.position.x = xLocation
        outerCircleLayer?.position.y = yLocation
        
        innerCircleInitialCenterPoint = innerCircleLayer!.position
    }
    
    public func updateStickPosition(translation: CGPoint, fingerLocation: CGPoint) {
        let innerPosition = innerCircleLayer?.position
        let outerPosition = outerCircleLayer?.position
        
        // get diameters of both circles and subtract to get range of inner
        let innerDiameter = max((innerCircleLayer?.path?.boundingBox.width)!, (innerCircleLayer?.path?.boundingBox.height)!)
        let outerDiameter = max((outerCircleLayer?.path?.boundingBox.width)!, (outerCircleLayer?.path?.boundingBox.height)!)
        let thumbStickRange = (outerDiameter - innerDiameter) / 2

        let testX = fingerLocation.x - bounds.maxX/2
        let testY = fingerLocation.y - bounds.maxY/2
        let bigTest = CGPoint(x: testX, y: testY) 
        let distance = calculateDistanceBetweenPoints(point1: outerPosition!, point2: bigTest)
        
        innerCircleLayer?.position = bigTest
        print("trans: \(distance)")
        print("dist: \(thumbStickRange)")
        if (distance > thumbStickRange) {
            innerCircleLayer?.position = innerPosition!
            
            
        } else {
            innerCircleLayer?.position = bigTest
        }
////            let direction = CGPoint(x: innerPosition!.x - outerPosition!.x, y: (innerPosition!.y - outerPosition!.y) * -1)
////            let normalizeDirection = CGPoint(x: direction.x / distance, y: direction.y / distance)
////            innerCircleLayer?.position = CGPoint(x: outerPosition!.x + normalizeDirection.x * (outerDiameter / 2), y: outerPosition!.y + normalizeDirection.y * (outerDiameter / 2))
//        } else {
//            print("false")
//            innerCircleLayer?.position.x += CGFloat(translation.x)
//            innerCircleLayer?.position.y += CGFloat(translation.y)
//        }
        
    }
    
    public func stickVisibilty(isVisible: Bool) {
        innerCircleLayer?.isHidden = !isVisible
        outerCircleLayer?.isHidden = !isVisible
    }
    
    // Can be a public func in a static math helper class
    private func calculateDistanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func setupUI() {
        addSubview(pauseButton)
        
            
        // Layout constraints for pause button
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 40)
        ]) 
        
        //let circlePath = UIBezierPath(ovalIn: bounds)
        let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX+200, y: bounds.midY+400), radius: 30, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        // inner circle
        innerCircleLayer = CAShapeLayer()
        innerCircleLayer?.opacity = 0.3
        innerCircleLayer?.path = innerCirclePath.cgPath
        
        innerCircleLayer?.fillColor = UIColor.blue.cgColor
        
        // outer circle
        let outerCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX+200, y: bounds.midY+400), radius: 50, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        outerCircleLayer = CAShapeLayer()
        outerCircleLayer?.strokeColor = UIColor.black.cgColor
        outerCircleLayer?.lineWidth = 3
        outerCircleLayer?.fillColor = nil
        outerCircleLayer?.path = outerCirclePath.cgPath
        
        // add circles as sublayers
        layer.addSublayer(innerCircleLayer!)
        layer.addSublayer(outerCircleLayer!)
        innerCircleLayer?.isHidden = true
        outerCircleLayer?.isHidden = true
    }
    
    @objc private func pauseButtonTapped() {
        pauseButtonTappedHandler?()
    }
}

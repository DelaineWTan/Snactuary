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
        print(bounds.maxY)
        let testX = location.x + bounds.maxX/2
        let testY = location.y + bounds.maxY/2
        
        innerCircleLayer?.position.x = testX
        innerCircleLayer?.position.y = testY
        
        outerCircleLayer?.position.x = testX
        outerCircleLayer?.position.y = testY
    }
    
    public func updateStickPosition(translation: CGPoint) {
        // set pos to outer
        innerCircleLayer?.position.x += CGFloat(translation.x)
        innerCircleLayer?.position.y += CGFloat(translation.y)
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
    }
    
    @objc private func pauseButtonTapped() {
        pauseButtonTappedHandler?()
    }
}

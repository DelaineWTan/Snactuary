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
    
    var hungerProgress = 0
    var maxHungerProgress = 100
    
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
    
    lazy var hungerMeter: UIProgressView = {
        let hungerMeterBar = UIProgressView(progressViewStyle: .bar)
        hungerMeterBar.progress = 0
        hungerMeterBar.layer.cornerRadius = 5
        hungerMeterBar.layer.masksToBounds = true
        hungerMeterBar.progressTintColor = .yellow
        hungerMeterBar.trackTintColor = .darkGray
        return hungerMeterBar
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
        let anchorPoint = convertGestureCoordinateSystemToUICoordinateSystem(point: location)
        
        innerCircleLayer?.position = anchorPoint
        outerCircleLayer?.position = anchorPoint
    }
    
    // Put source which helped me here
    public func updateStickPosition(fingerLocation: CGPoint) {
        let outerPosition = outerCircleLayer?.position
        
        // get diameters of both circles and subtract to get range of which the inner circle may move
        let innerDiameter = max((innerCircleLayer?.path?.boundingBox.width)!, (innerCircleLayer?.path?.boundingBox.height)!)
        let outerDiameter = max((outerCircleLayer?.path?.boundingBox.width)!, (outerCircleLayer?.path?.boundingBox.height)!)
        let thumbStickRange = (outerDiameter - innerDiameter) / 2
        let translatedFingerPos = convertGestureCoordinateSystemToUICoordinateSystem(point: fingerLocation)
        
        // distance b/w finger-hold location and middle of thumbstick
        let distance = calculateDistanceBetweenPoints(point1: outerPosition!, point2: translatedFingerPos)
        
        // Get angle b/w center of thumbstick and finger
        let angle = atan2(translatedFingerPos.y - outerPosition!.y, translatedFingerPos.x - outerPosition!.x)
        let clamp = min(distance, thumbStickRange)
        
        // new coordinates of inner circle
        let newX = outerPosition!.x + cos(angle) * clamp
        let newY = outerPosition!.y + sin(angle) * clamp
        
        innerCircleLayer?.position = CGPoint(x: newX, y: newY)
    }
    
    public func stickVisibilty(isVisible: Bool) {
        innerCircleLayer?.isHidden = !isVisible
        outerCircleLayer?.isHidden = !isVisible
    }
    
    private func convertGestureCoordinateSystemToUICoordinateSystem(point: CGPoint) -> CGPoint {
        // translate gesture plot to UI kit plot
        let xPoint = point.x - bounds.maxX/2
        let yPoint = point.y - bounds.maxY/2
        return CGPoint(x: xPoint, y: yPoint)
    }
    
    // Can be a public func in a static math helper class
    private func calculateDistanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func setupUI() {
        addSubview(pauseButton)
        addSubview(hungerMeter)
        
            
        // Layout constraints for pause button
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Layout constraints for hunger meter
        hungerMeter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hungerMeter.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            hungerMeter.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            //hungerMeter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hungerMeter.widthAnchor.constraint(equalToConstant: 240),
            hungerMeter.heightAnchor.constraint(equalToConstant: 10),
        ])
        
        //let circlePath = UIBezierPath(ovalIn: bounds)
        let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX+200, y: bounds.midY+400), radius: 30, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        // inner circle
        innerCircleLayer = CAShapeLayer()
        innerCircleLayer?.opacity = 0.6
        innerCircleLayer?.path = innerCirclePath.cgPath
        
        innerCircleLayer?.fillColor = UIColor.darkGray.cgColor
        
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
        
        collectObjects() // remove
    }
    // func to test hunger meter
    func collectObjects() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.hungerProgress += 1
            let progress = Float(self.hungerProgress) / Float(self.maxHungerProgress)
            self.hungerMeter.setProgress(progress, animated: true)
            
            if self.hungerProgress >= self.maxHungerProgress {
                timer.invalidate()
            }
        }
    }
    
    @objc private func pauseButtonTapped() {
        pauseButtonTappedHandler?()
    }
}

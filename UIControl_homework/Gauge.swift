//
//  Gauge.swift
//  UIControl_homework
//
//  Created by Valentin Varbanov on 1.12.17.
//  Copyright © 2017 Valentin Varbanov. All rights reserved.
//

import UIKit

@IBDesignable class Gauge: UIView {
    
    // MARK: - Public Properties
    
    /// Int value from 0 to 100
    public var value: Int = 30 {
        didSet {
            updateValueLayers(duration: 1)
            label.text = "\(value)"
        }
    }
    
    /// UIColor for the value
    public var valueColor = UIColor.black {
        didSet {
            gaugeValueLayer.strokeColor = valueColor.cgColor
            markerLayer.strokeColor = valueColor.cgColor
        }
    }
    
    /// UIColor for the gauge
    public var color = UIColor.lightGray {
        didSet {
            gaugeLayer.strokeColor = color.cgColor
        }
    }
    
    /// UIColor for the background circle
    public var circleColor = UIColor.lightGray.withAlphaComponent(0.5) {
        didSet {
            circleLayer.strokeColor = circleColor.cgColor
        }
    }
    
    /// UIColor for the label
    public var labelColor = UIColor.black {
        didSet {
            label.textColor = labelColor
        }
    }
    
    /**
     Value in degrees for the starting position of the arc
     
     The value should be from -360 to 360
     
     Not animatable!
     * Note: value of 0 is 12 o'clock
     */
    public var startPosition = -150.0 { didSet { addLayers() } }
    
    /**
     Value in degrees for the end position of the arc
     
     The value should be from -360 to 360
     
     Not animatable!
     * Note: value of 0 is 12 o'clock
     */
    public var endPosition = 150.0 { didSet { addLayers() } }
    
    // MARK: - Public Methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayers()
        initLabel()
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let radiansToDegreesRatio: CGFloat = CGFloat.pi / 180
        
        // common
        static let radiusToSizeRatio: CGFloat = 0.8
        static let lineWidthToSizeRation: CGFloat = 1 / 20
        
        // circle background
        static let backgroundCircleWidthToLineWidth:CGFloat = 1.2
        static let backgroundCircleStartAngle:CGFloat = 0
        static let backgroundCircleEndAngle:CGFloat = 2 * CGFloat.pi
        
        // dashes
        static let dashSpacingToLineWidth:CGFloat = 1 / 4
        static let dashSizeToLineWidth:CGFloat = 1 / 4
        
        // marker
        static let markerWidthToLineWidth:CGFloat = 1.8
        static let markerSize: CGFloat = 0.5
        
        // label
//        static let font = UIFont(name: "HelveticaNeue-Thin", size: 19)!
        static let thinFont = UIFont(name: "HelveticaNeue-UltraLight", size: 19)!
        static let fontSizeToRadius: CGFloat = 0.8
        static let labelWidthToRadius: CGFloat = 2
    }
    
    // MARK: - Private Properties
    
    private var gaugeLayer = CAShapeLayer()
    private var gaugeValueLayer = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
    private var markerLayer = CAShapeLayer()
    private var label = UILabel()
    
    // MARK: - Private Computed Properties
    
    private var viewCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var radius: CGFloat {
        return min(bounds.width, bounds.height) / 2 * Constants.radiusToSizeRatio
    }
    
    private var startAngle: CGFloat {
        return CGFloat(startPosition) * Constants.radiansToDegreesRatio - CGFloat.pi / 2
    }
    
    private var endAngle: CGFloat {
        return CGFloat(endPosition) * Constants.radiansToDegreesRatio - CGFloat.pi / 2
    }
    
    private var lineWidth: CGFloat {
        return min(bounds.width, bounds.height) * Constants.lineWidthToSizeRation
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        backgroundColor = UIColor.clear
        
        initLayers()
        addLayers()
        updateValueLayers()
        
        initLabel()
        
        addSubview(label)
    }
    
    private func initLayers() {
        // gauge
        initBaseGauge(layer: gaugeLayer, startAngle: startAngle, endAngle: endAngle, color: color.cgColor, lineWidth: lineWidth)
        
        // current value of gauge
        initBaseGauge(layer: gaugeValueLayer, startAngle: startAngle, endAngle: endAngle, color: valueColor.cgColor, lineWidth: lineWidth)
        
        // background circle
        initBaseArc(layer: circleLayer, startAngle: Constants.backgroundCircleStartAngle, endAngle: Constants.backgroundCircleEndAngle, color: circleColor.cgColor, lineWidth: lineWidth * Constants.backgroundCircleWidthToLineWidth)
        
        // marker
        initBaseArc(layer: markerLayer, startAngle: startAngle, endAngle: endAngle, color: valueColor.cgColor, lineWidth: lineWidth * Constants.markerWidthToLineWidth)
    }
    
    private func addLayers() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(gaugeLayer)
        layer.addSublayer(gaugeValueLayer)
        
        layer.addSublayer(markerLayer)
    }
    
    private func updateValueLayers(duration: CFTimeInterval = 0) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        gaugeValueLayer.strokeEnd = CGFloat(value) / 100
        gaugeValueLayer.add(animation, forKey: nil)
        
        let animation1 = CABasicAnimation(keyPath: "strokeEnd")
        let animation2 = CABasicAnimation(keyPath: "strokeStart")
        animation1.duration = duration
        animation2.duration = duration
        
        markerLayer.strokeEnd = (CGFloat(value) + Constants.markerSize) / 100
        markerLayer.strokeStart =  (CGFloat(value) - Constants.markerSize) / 100

        markerLayer.add(animation1, forKey: nil)
        markerLayer.add(animation2, forKey: nil)

        CATransaction.commit()
    }
    
    private func initBaseGauge(layer targetLayer: CAShapeLayer,
                               startAngle: CGFloat,
                               endAngle: CGFloat,
                               color: CGColor,
                               lineWidth: CGFloat) {
        
        initBaseArc(layer: targetLayer, startAngle: startAngle, endAngle: endAngle, color: color, lineWidth: lineWidth)
        
        // calculate spacing so we can have full dashes
        let expectedDashSpacing = lineWidth * Constants.dashSpacingToLineWidth
        let dashSize = lineWidth * Constants.dashSizeToLineWidth
        let arcLength = (endAngle - startAngle) * radius
        let numberOfDashes = round(arcLength / (dashSize + expectedDashSpacing))
        let dashSpacing = (arcLength / numberOfDashes) - dashSize
        
        targetLayer.lineDashPattern = [
            NSNumber(value: Double(dashSize)),
            NSNumber(value: Double(dashSpacing))
        ]
        targetLayer.lineDashPhase = lineWidth
    }
    
    private func initBaseArc(layer targetLayer: CAShapeLayer,
                             startAngle: CGFloat,
                             endAngle: CGFloat,
                             color: CGColor,
                             lineWidth: CGFloat) {
        
        let path = UIBezierPath(arcCenter: viewCenter,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        targetLayer.frame       = bounds
        targetLayer.path        = path.cgPath
        targetLayer.fillColor   = UIColor.clear.cgColor
        targetLayer.strokeColor = color
        targetLayer.lineWidth   = lineWidth
    }
    
    private func initLabel() {
        let valueLabelFontSize = radius * Constants.fontSizeToRadius
        var valueLabelSize = ("    " as NSString).size(withAttributes: [NSAttributedStringKey.font: Constants.thinFont.withSize(valueLabelFontSize)])
        valueLabelSize.width = radius * Constants.labelWidthToRadius
        let valueLabelOrigin = CGPoint(x: viewCenter.x - valueLabelSize.width / 2,
                                       y: viewCenter.y - valueLabelSize.height / 2)
        label.frame = CGRect(origin: valueLabelOrigin, size: valueLabelSize)
        label.textAlignment = .center
        label.textColor = color
        label.font = Constants.thinFont.withSize(valueLabelFontSize)
        label.text = "\(value)"
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

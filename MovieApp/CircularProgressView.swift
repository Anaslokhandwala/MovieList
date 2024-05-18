//
//  CircularProgressView.swift
//  MovieApp
//
//  Created by Anas on 18/05/24.
//

import Foundation
import UIKit

class CircularProgressView: UIView {

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var progressLabel = UILabel()

    var progressColor = UIColor.green {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }

    private func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 1.5)/2, startAngle: -.pi / 2, endAngle: .pi * 1.5, clockwise: true)

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 10.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)

        setupLabel()
    }

    private func setupLabel() {
        progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        progressLabel.textAlignment = .center
        progressLabel.font = UIFont.systemFont(ofSize: 24)
        progressLabel.textColor = UIColor.white
        self.addSubview(progressLabel)
    }

    func setProgress(to progressConstant: Float, withAnimation: Bool) {
        progressLayer.strokeEnd = CGFloat(progressConstant)
        progressLabel.text = "\(Int(progressConstant * 100))%"

        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 1.0
            animation.fromValue = 0
            animation.toValue = progressConstant
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            progressLayer.add(animation, forKey: "animateprogress")
        }
    }
}

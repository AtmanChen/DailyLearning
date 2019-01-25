//
//  BarChartView.swift
//  GraphLearning
//
//  Created by 突突兔 on 2019/1/25.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit

class BarChartView: UIView {

    private let mainLayer = CALayer()
    private let scrollView = UIScrollView()
    
    let space: CGFloat = 44
    let barHeight: CGFloat = 40
    let contentSpace: CGFloat = 88
    
    
    var dataEntries: [BarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            scrollView.contentSize = CGSize(width: frame.width, height: barHeight + space * CGFloat(dataEntries.count) + contentSpace)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            dataEntries.enumerated().forEach { arg in
                let (index, barEntry) = arg
                showEntry(index: index, entry: barEntry)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        scrollView.layer.addSublayer(mainLayer)
        addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
    }
    
    private func showEntry(index: Int, entry: BarEntry) {
        let xPos: CGFloat = translateWidthValueToXPosition(value: Float(entry.score) / 100.0)
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
        drawBar(x: xPos, y: yPos)
        drawTextValue(x: xPos + 155, y: yPos + 4, textValue: "\(entry.score)")
        drawTitle(x: 16, y: yPos + 12, width: 150, height: 40, title: entry.title)
    }
    
    private func drawBar(x: CGFloat, y: CGFloat) {
        let barLayer = CALayer()
        barLayer.bounds = CGRect(x: 144, y: y, width: x, height: 44)
        barLayer.position = CGPoint(x: 144, y: y)
        barLayer.backgroundColor = UIColor(hex: 0xFF4500).cgColor
        barLayer.anchorPoint = .zero
        mainLayer.addSublayer(barLayer)
        
        let animation = CABasicAnimation()
        animation.keyPath = "bounds"
        animation.duration = 1.0
        animation.fromValue = CGRect(x: 144, y: y, width: 0, height: 44)
        animation.toValue = CGRect(x: 144, y: y, width: x, height: 44)
        barLayer.add(animation, forKey: "barBounds")
    }
    
    private func drawTextValue(x: CGFloat, y: CGFloat, textValue: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x, y: y, width: 33, height: 80)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 14).fontName as CFString, 0, nil)
        textLayer.fontSize = 14
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat = 22, title: String) {
        let titleLayer = CATextLayer()
        titleLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        titleLayer.foregroundColor = UIColor.black.cgColor
        titleLayer.backgroundColor = UIColor.clear.cgColor
        titleLayer.alignmentMode = .left
        titleLayer.contentsScale = UIScreen.main.scale
        titleLayer.font = CTFontCreateWithName(UIFont.boldSystemFont(ofSize: 14).fontName as CFString, 0, nil)
        titleLayer.fontSize = 14
        titleLayer.string = title
        mainLayer.addSublayer(titleLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat {
        let width = CGFloat(value) * (mainLayer.frame.width - space)
        return abs(width)
    }

}

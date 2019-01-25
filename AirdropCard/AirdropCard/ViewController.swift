//
//  ViewController.swift
//  AirdropCard
//
//  Created by 突突兔 on 2019/1/24.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import UIKit
import SwiftIcons
import Constraint

private let CardHeight: CGFloat = 600
private let PickerDataSources: [String] = ["Dark", "Light"]

class ViewController: UIViewController {
    
    fileprivate lazy var blur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.alpha = 0
        blur.frame = UIScreen.main.bounds
        return blur
    }()
    
    fileprivate var cardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIImageView(image: UIImage(named: "back")!)
        back.contentMode = .scaleAspectFill
        back.frame = view.bounds
        view.addSubview(back)
        
        let addButton = UIButton()
        let addWidth: CGFloat = 64
        addButton.setIcon(icon: .fontAwesomeSolid(.plusCircle), iconSize: 44, color: .black, backgroundColor: .clear, forState: .normal)
        addButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        addButton.setTitleColor(.white, for: .normal)
        addButton.frame = CGRect(x: view.frame.maxX - 10 - addWidth, y: 24, width: addWidth, height: addWidth)
        addButton.addTarget(self, action: #selector(showCard), for: .touchUpInside)
        view.addSubview(addButton)
        
        view.addSubview(blur)
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBlur)))
        
        initCardView()
    }
    
    fileprivate func initCardView() {
        cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        view.addSubview(cardView)
        cardView
            .attach(sides: [.leading, .trailing], 16)
            .attach(bottom: 20)
            .height(CardHeight)
        cardView.transform = CGAffineTransform(translationX: 0, y: CardHeight * 1.2)
        let closeCardButton = UIButton()
        closeCardButton.setIcon(icon: .fontAwesomeSolid(.windowClose), iconSize: 44, color: .black, backgroundColor: .white, forState: .normal)
        closeCardButton.addTarget(self, action: #selector(dismissBlur), for: .touchUpInside)
        cardView.addSubview(closeCardButton)
        closeCardButton
            .attach(sides: [.trailing, .top], 16)
            .height(44)
            .width(44)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.text = "选择你要的效果"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        cardView.addSubview(titleLabel)
        titleLabel
            .attach(top: 40)
            .center(axis: .x)
        
        let openIcon = UIImageView(image: UIImage(icon: .fontAwesomeSolid(.boxOpen), size: CGSize(width: 160, height: 160), textColor: UIColor(hex: 0xDC143C), backgroundColor: .white))
        cardView.addSubview(openIcon)
        openIcon
            .space(40, .below, titleLabel)
            .center(axis: .x)
            .size(width: 160, height: 160)
        
        let pickerView = UIPickerView(frame: .zero)
        pickerView.dataSource = self
        pickerView.delegate = self
        cardView.addSubview(pickerView)
        pickerView
            .space(8, .below, openIcon)
            .center(axis: .x)
            .width(200)
        
        let okButton = UIButton()
        okButton.setTitle("确定", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(hex: 0x9932CC)
        okButton.layer.cornerRadius = 4
        okButton.clipsToBounds = true
        okButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        okButton.addTarget(self, action: #selector(actionChooseBlurStyle), for: .touchUpInside)
        cardView.addSubview(okButton)
        
        okButton
            .attach(sides: [.leading, .trailing, .bottom], 16)
            .height(44)
    }
    
    @objc
    fileprivate func actionChooseBlurStyle() {
        let pickerView = cardView.subviews.filter { $0 is UIPickerView }.first! as! UIPickerView
        let seletedRow = pickerView.selectedRow(inComponent: 0)
        switch seletedRow {
        case 0:
            blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        case 1:
            blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        default: break
        }
        blur.setNeedsDisplay()
        print(view.subviews.filter { $0 is UIVisualEffectView }.count)
    }
    
    @objc
    fileprivate func showCard() {
        UIView.animate(withDuration: 0.16) {
            self.blur.alpha = 1
            self.cardView.transform = .identity
        }
    }
    
    @objc
    fileprivate func dismissBlur() {
        UIView.animate(withDuration: 0.16) {
            self.blur.alpha = 0
            self.cardView.transform = CGAffineTransform(translationX: 0, y: 1.2 * CardHeight)
        }
    }
}


extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component == 0 else {
            return 0
        }
        return PickerDataSources.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerDataSources[row]
    }
}


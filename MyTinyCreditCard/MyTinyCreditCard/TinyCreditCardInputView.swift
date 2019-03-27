//
//  TinyCreditCardInputView.swift
//  MyTinyCreditCard
//
//  Created by 突突兔 on 2019/3/27.
//  Copyright © 2019 突突兔. All rights reserved.
//

import UIKit


enum InputType: Int {
    case cardNumber = 0, cardHolder, expDate, cscNumber
}

extension InputType {
    var spaceIndex: [Int] {
        return [12, 8, 4]
    }
}


class TinyCreditCardInputView: UIView {

    
    
    var didChangeText: (String) -> Void = { _ in }
    var didTapNextButton: () -> Void = { }

    private let textField = UITextField()
    private let button = UIButton(type: .custom)
    
    var inputType: InputType = .cardNumber {
        didSet {
            switch inputType {
            case .cardNumber:
                textField.keyboardType = .numberPad
                textField.returnKeyType = .next
            case .cardHolder:
                textField.keyboardType = .default
                textField.autocorrectionType = .no
                textField.returnKeyType = .next
            case .expDate:
                let pickerView = UIPickerView()
                pickerView.dataSource = self
                pickerView.delegate = self
                textField.inputView = pickerView
            case .cscNumber:
                textField.keyboardType = .numberPad
                textField.returnKeyType = .done
            }
            
            let doneToolBar = UIToolbar()
            doneToolBar.barStyle = .blackTranslucent
            doneToolBar.tintColor = .white
            doneToolBar.items = [
                UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(resignFirstResponder)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: inputType == .cscNumber ? "Done" : "Next",
                                style: .plain,
                                target: self,
                                action: #selector(didTapToolBarNext))
            ]
            doneToolBar.sizeToFit()
            textField.inputAccessoryView = doneToolBar
        }
    }
    
    @IBInspectable var placeHolder: String? {
        set {
            textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [.foregroundColor: UIColor.gray])
        }
        get {
            return textField.placeholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    
    
    @objc
    func didTapToolBarNext() {
        didTapNextButton()
    }

}

private extension TinyCreditCardInputView {
    
    private func initView() {
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = 6
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        
        do {
            addSubview(textField)
            addSubview(button)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            button.translatesAutoresizingMaskIntoConstraints = false
            
            textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5).isActive = true
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
            button.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        textField.keyboardAppearance = .dark
        textField.textColor = .white
        textField.addTarget(self, action: #selector(formatTextField), for: .editingChanged)
        textField.addTarget(self, action: #selector(tapTextFieldReturn), for: .editingDidEndOnExit)
        
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "angle-right"), for: .normal)
        button.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    @objc
    func formatTextField(_ sender: UITextField) {
        switch inputType {
        case .cardNumber:
            let rawText = textField.text?.components(separatedBy: " ").joined() ?? ""
            var newText = String(rawText.prefix(16))
            
            for index in inputType.spaceIndex {
                guard newText.count >= index + 1 else {
                    continue
                }
                newText.insert(" ", at: String.Index(encodedOffset: index))
            }
            set(newText)
        case .cardHolder:
            set(textField.text)
        case .expDate:
            break
        case .cscNumber:
            set(textField.text)
        }
        
        didChangeText(textField.text ?? "")
    }
    
    @objc
    func tapTextFieldReturn() {
        if !button.isHidden {
            tapNextButton()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @objc
    func tapNextButton() {
        didTapNextButton()
    }
    
    private func set(_ text: String?) {
        if textField.text != text {
            textField.text = text
        }
        
        guard let t = text, t.count > 0 else {
            button.isHidden = true
            return
        }
        
        switch inputType {
        case .cardNumber:
            button.isHidden = t.count != 9
        case .cardHolder:
            button.isHidden = false
        case .expDate:
            button.isHidden = false
        case .cscNumber:
            button.isHidden = t.count < 3
        }
    }
}



extension TinyCreditCardInputView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    
    
}

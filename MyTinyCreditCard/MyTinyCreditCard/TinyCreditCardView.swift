//
//  TinyCreditCardView.swift
//  MyTinyCreditCard
//
//  Created by 突突兔 on 2019/3/26.
//  Copyright © 2019 突突兔. All rights reserved.
//

import UIKit

class TinyCreditCardView: UIView {

    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var cardFrontView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var cardBrandImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!
    
    @IBOutlet weak var cardNumberInputView: TinyCreditCardInputView!
    @IBOutlet weak var cardHolderInputView: TinyCreditCardInputView!
    @IBOutlet weak var expDateInputView: TinyCreditCardInputView!
    @IBOutlet weak var cscNumberInputView: TinyCreditCardInputView!
    
    @IBOutlet weak var cardNumberButton: UIButton!
    @IBOutlet weak var cardHolderButton: UIButton!
    @IBOutlet weak var expDateButton: UIButton!
    
    private let focusArea = UIView()
    
    private lazy var inputsView: [TinyCreditCardInputView] = [
        cardNumberInputView,
        cardHolderInputView,
        expDateInputView,
        cscNumberInputView
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            inputsView[currentPage].becomeFirstResponder()
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
    
    @IBAction func actionExpDateButton(_ sender: Any) {
        focusAreaScroll(.expDate)
        scrollView.scrollTo(InputType.expDate.rawValue)
    }
    
    @IBAction func actionCardHolderButton(_ sender: Any) {
        focusAreaScroll(.cardHolder)
        scrollView.scrollTo(InputType.cardHolder.rawValue)
    }
    
    @IBAction func actionCardNumberButton(_ sender: Any) {
        focusAreaScroll(.cardNumber)
        scrollView.scrollTo(InputType.cardNumber.rawValue)
    }
}

private extension TinyCreditCardView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func initNibView() {
        guard let cardView = TinyCreditCardView.nib
            .instantiate(withOwner: self, options: nil)
            .compactMap({ $0 as? UIView })
            .first else {
                return
        }
        
        addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func initView() {
        initNibView()
        
        backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 8
        cardContainerView.layer.masksToBounds = true
        
        focusArea.layer.borderColor = UIColor.orange.cgColor
        focusArea.layer.borderWidth = 1
        focusArea.layer.cornerRadius = 6
        cardFrontView.addSubview(focusArea)
        DispatchQueue.main.async {
            self.focusArea.frame = self.cardNumberView.frame
        }
        
        cardNumberInputView.inputType = .cardNumber
        cardHolderInputView.inputType = .cardHolder
        cardHolderLabel.isHidden = true
        expDateInputView.inputType = .expDate
        cscNumberInputView.inputType = .cscNumber
        
        cardNumberInputView.didChangeText = { [unowned self] text in
            self.cardNumberLabel.text = text
            if text.hasPrefix("4") {
                self.cardBrandImageView.image = #imageLiteral(resourceName: "visa")
            } else if text.hasPrefix("5") || text.hasPrefix("2") {
                self.cardBrandImageView.image = #imageLiteral(resourceName: "mastercard")
            } else if text.hasPrefix("3") {
                self.cardBrandImageView.image = #imageLiteral(resourceName: "amex")
            } else {
                self.cardBrandImageView.image = nil
            }
            
            if text.count == 19 {
                self.cardNumberInputView.didTapNextButton()
            }
        }
        
        cardHolderInputView.didChangeText = { [unowned self] text in
            self.cardHolderLabel.isHidden = text.isEmpty
            self.cardHolderLabel.text = text.uppercased()
        }
        
        cardNumberInputView.didTapNextButton = { [unowned self] in
            self.scrollView.scrollTo(self.cardHolderInputView.inputType.rawValue)
            self.focusArea.frame = self.cardHolderButton.frame
        }
    }
    
    private func focusAreaScroll(_ to: InputType) {
        UIView.animate(withDuration: 0.3) {
            switch to {
            case .cardNumber:
                self.focusArea.frame = self.cardNumberView.frame
            case .cardHolder:
                self.focusArea.frame = self.cardHolderButton.frame
            case .expDate:
                self.focusArea.frame = self.expDateButton.frame
            default: break
            }
        }
    }
}


fileprivate extension UIScrollView {
    func scrollTo(_ page: Int) {
        var rect = bounds
        rect.origin.x = rect.width * CGFloat(page)
        UIView.animate(withDuration: 0.5) {
            self.scrollRectToVisible(rect, animated: true)
        }
    }
}

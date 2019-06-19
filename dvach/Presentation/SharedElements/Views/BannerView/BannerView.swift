//
//  BannerView.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol BannerViewDelegate: class {
    func userAgreedWithBannerWarning()
    func userDisagreedWithBannerWarning()
}

final class BannerView: UIView, ConfigurableView {
    
    // Model
    struct Model {
        let image: UIImage
        let imageColor: UIColor
        let backgroundColor: UIColor
        let title: String
        let description: String
    }
    
    // Delegate
    public weak var delegate: BannerViewDelegate?
    
    // Layers
    private var maskLayer: CAShapeLayer?
    
    // Constraints
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Outlets
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    
    // Buttons
    private lazy var continueButton: BottomButton = {
        let continueButton = BottomButton()
        continueButton.configure(with: BottomButton.Model(text: "Продолжить",
                                                          backgroundColor: .n7Blue,
                                                          textColor: .white))
        continueButton.enablePressStateAnimation { [weak self] in
            self?.continueAction()
        }
        return continueButton
    }()
    
    private lazy var cancelButton: BottomButton = {
        let cancelButton = BottomButton()
        cancelButton.configure(with: BottomButton.Model(text: "Выйти",
                                                        backgroundColor: .n5LightGray,
                                                        textColor: .n1Gray))
        cancelButton.enablePressStateAnimation { [weak self] in
            self?.cancelAction()
        }
        return cancelButton
    }()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addAppleLikeCornerRadius()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        buttonsView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(140)
        }
        
        buttonsView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(140)
            make.leading.equalTo(continueButton.snp.trailing).offset(8)
            make.width.equalTo(continueButton.snp.width)
        }
        
        if UIDevice.current.hasNotch {
            bottomConstraint.constant = 20
        } else {
            bottomConstraint.constant = 10
        }
    }
    
    private func addAppleLikeCornerRadius() {
        let cornerRadius = CGFloat.radiusOfIphoneX(bounds: bounds)
        if maskLayer == nil {
            let maskLayer = CAShapeLayer()
            maskLayer.path =
                UIBezierPath.continuousRoundedRect(bounds,
                                                   cornerRadius: cornerRadius).cgPath
            layer.mask = maskLayer
            self.maskLayer = maskLayer
        } else {
            maskLayer?.path =
                UIBezierPath.continuousRoundedRect(bounds,
                                                   cornerRadius: cornerRadius).cgPath
        }
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: BannerView.Model) {
        backgroundColor = model.backgroundColor
        iconImageView.image = model.image.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = model.imageColor
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        descriptionLabel.sizeToFit()
    }
    
    // MARK: - Actions
    
    private func continueAction() {
        delegate?.userAgreedWithBannerWarning()
    }
    
    private func cancelAction() {
        delegate?.userDisagreedWithBannerWarning()
    }
}

//
//  BottomButton.swift
//  dvach
//
//  Created by Kirill Solovyov on 17/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension CGFloat {
    static let height: CGFloat = 45
}

final class BottomButton: UIView, ConfigurableView, PressStateAnimatable {
    
    struct Model {
        let text: String?
        var image: UIImage? = nil
        let backgroundColor: UIColor
        let textColor: UIColor
    }
    
    // Public Interface
    public var isEnabled: Bool {
        get {
            return _isEnabled
        }
        set {
            _isEnabled = newValue
        }
    }
    
    // Private Interface
    private var _isEnabled = true {
        willSet  {
            if newValue != _isEnabled {
                updateAvailability(newValue)
            }
        }
    }
    
    private var enabledColor: UIColor?
    
    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .size16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRoundedByCornerRadius()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        snp.makeConstraints { $0.height.equalTo(CGFloat.height)}
        titleStackView.addArrangedSubview(titleLabel)
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { $0.center.equalToSuperview() }
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(CGFloat.imageViewSide)
        }
    }
    
    private func updateAvailability(_ isEnable: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if isEnable {
                self?.backgroundColor = self?.enabledColor
            } else {
                if let disabledColor = self?.disabledColor {
                    self?.backgroundColor = disabledColor
                } else {
                    self?.backgroundColor = self?.backgroundColor?.withAlphaComponent(0.3)
                }
            }
        }
    }
    
    // MARK: - Public
    
    public var title: String? {
        return titleLabel.text
    }
    
    public var disabledColor: UIColor?
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: BottomButton.Model) {
        if model.image != nil {
            if titleStackView.subviews.count != 2 {
                titleStackView.insertArrangedSubview(imageView, at: 0)
            }
        }
        imageView.image = model.image
        titleLabel.text = model.text
        titleLabel.textColor = model.textColor
        backgroundColor = model.backgroundColor
        enabledColor = model.backgroundColor
        
        updateAvailability(_isEnabled)
        titleStackView.snp.updateConstraints { $0.center.equalToSuperview() }
        layoutIfNeeded()
    }
    
    func set(title: String?) {
        titleLabel.text = title
        
        updateAvailability(_isEnabled)
        titleStackView.snp.updateConstraints { $0.center.equalToSuperview() }
        layoutIfNeeded()
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let imageViewSide: CGFloat = 20
    static let imageViewToLabelOffset: CGFloat = -12
}

private extension TimeInterval {
    static let animationDuration = 0.45
}

//
//  ContextAddView.swift
//  dvach
//
//  Created by Kirill Solovyov on 23/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

typealias ContextAdCell = TableViewContainerCellBase<ContextAddView>

final class ContextAddView: UIView, SeparatorAvailable, ConfigurableView, ReusableView {

    @IBOutlet weak var fakeAnswerNumberLabel: UILabel!
    @IBOutlet weak var fakeAnswerTwoSymbolsLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var answersButton: VerticalOvalButton!
    @IBOutlet weak var moreButton: VerticalOvalButton!
    @IBOutlet weak var roundAdMarkView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var callToAction: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    private lazy var fakeNumberOfReplies: String = {
        let randomNumber = Int.random(in: 1..<13)
        return "\(randomNumber)"
    }()
    
    private lazy var fakeAnswerNumberString: String = {
        let randomNumber = Int.random(in: 1000000..<9999999)
        return "\(randomNumber)"
    }()
    
    public var id = ""
    
    public var adDescription: String {
        return "\(id)\n\(fakeAnswerNumberString)\n\(fakeNumberOfReplies)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fakeAnswerTwoSymbolsLabel.textColor = UIColor.a3Orange
        fakeAnswerNumberLabel.textColor = UIColor.a3Orange
        fakeAnswerNumberLabel.text = fakeAnswerNumberString
        textLabel.textColor = .n1Gray
        textLabel.font = UIFont.commentRegular
        textLabel.numberOfLines = 0
        title.textColor = .n1Gray
        callToAction.textColor = .n7Blue
        addBottomSeparator(with: .defaultStyle)
        roundAdMarkView.backgroundColor = .n7Blue
        moreButton.configure(with: VerticalOvalButton.Model(color: .n9LightGreen,
                                                            icon: UIImage(named: "more"),
                                                            text: nil))
        answersButton.configure(with: VerticalOvalButton.Model(color: .n4Red,
                                                               icon: UIImage(named: "answers"),
                                                               text: fakeNumberOfReplies))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.makeRoundedByCornerRadius(.radius10)
        roundAdMarkView.makeRounded()
        textLabel.sizeToFit()
    }
    
    struct Model {
        let id: String
    }
    typealias ConfigurationModel = Model
    
    func configure(with model: ContextAddView.Model) {
        self.id = model.id
    }
    
    // MARK: - ReusableView
    
    func prepareForReuse() {
        fakeAnswerNumberLabel.text = nil
        fakeAnswerTwoSymbolsLabel.text = nil
        textLabel.text = nil
        title.text = nil
        callToAction.text = nil
        image.image = nil
    }
}

// MARK: - APDNativeAdView

extension ContextAddView: APDNativeAdView {
    
    func titleLabel() -> UILabel {
        return title
    }
    
    func callToActionLabel() -> UILabel {
        return callToAction
    }
    
    func iconView() -> UIImageView {
        return image
    }
    
    func descriptionLabel() -> UILabel {
        return textLabel
    }
    
    func setRating(_ rating: NSNumber) {
        fakeAnswerNumberLabel.text = String(format: " %.1f",
                                            arguments: [rating.doubleValue])
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ContextAddView", bundle: nil)
    }
}

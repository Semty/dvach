//
//  PostCommentButtonsView.swift
//  dvach
//
//  Created by Kirill Solovyov on 09/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol PostCommentButtonsViewDelegate: AnyObject {
    func answerButtonDidTap()
    func answersButtonDidTap()
    func moreButtonDidTap(_ button: UIView)
}

final class PostCommentButtonsView: UIView, ConfigurableView {
    
    struct Model {
        let answerButtonModel: VerticalOvalButton.Model?
        let answersButtonModel: VerticalOvalButton.Model?
        let moreButtonModel: VerticalOvalButton.Model
    }
    
    // Dependencies
    weak var delegate: PostCommentButtonsViewDelegate?
    
    // Outlets
    @IBOutlet weak var answerButton: VerticalOvalButton!
    @IBOutlet weak var answersButton: VerticalOvalButton!
    @IBOutlet weak var moreButton: VerticalOvalButton!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answerButton.enableTapping { [weak self] in
            self?.delegate?.answerButtonDidTap()
        }
        
        answersButton.enableTapping { [weak self] in
            self?.delegate?.answersButtonDidTap()
        }
        
        moreButton.enableTapping { [weak self] in
            guard let self = self else { return }
            self.delegate?.moreButtonDidTap(self.moreButton)
        }
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: PostCommentButtonsView.Model) {
        // Ответить
        answerButton.isHidden = model.answerButtonModel == nil
        if let answerModel = model.answerButtonModel {
            answerButton.configure(with: answerModel)
        }
        
        // Ответы
        answersButton.isHidden = model.answersButtonModel == nil
        if let repliesModel = model.answersButtonModel {
            answersButton.configure(with: repliesModel)
        }
        
        // Еще
        moreButton.configure(with: model.moreButtonModel)
    }
}

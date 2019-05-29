//
//  TableViewContainerCell.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

/// Базовая generic-ячейка для добавления любой кофигурируемой view в таблицу-контейнер
final class TableViewContainerCellBase<T: UIView>: UITableViewCell, ConfigurableView where T: ConfigurableView, T: ReusableView {
    
    var containedView: T = T.isLoadableFromNib() ? T.fromNib() : T(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containedView)
        containedView.autoPinEdgesToSuperviewEdges()
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containedView.prepareForReuse()
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: T.ConfigurationModel) {
        containedView.configure(with: model)
    }
}

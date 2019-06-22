//
//  ConnectUsView.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class ConnectUsView: UIView, PressStateAnimatable {
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n7Blue
        titleLabel.text = "Присоединяйтесь к нам в телеге"
    }
}

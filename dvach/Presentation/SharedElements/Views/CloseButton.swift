//
//  CloseButton.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 29/04/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final public class CloseButton: UIImageView, Tappable {
    
    init() {
        super.init(frame: .zero)
        image = UIImage(named: "close_button")
        snp.makeConstraints { $0.height.width.equalTo(25) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

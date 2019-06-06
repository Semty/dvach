//
//  Category.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

enum Category: String {
    case adults = "Взрослым"
    case hidden = "Скрытые"
    case games = "Игры"
    case politics = "Политика"
    case user = "Пользовательские"
    case other = "Разное"
    case art = "Творчество"
    case theme = "Тематика"
    case technics = "Техника и софт"
    case japan = "Японская культура"
    
    static var list: [Category] {
        return [.adults, .hidden, .games, .politics, .user, .other, .art, .theme, .technics, .japan]
    }
}

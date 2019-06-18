//
//  GlobalUtils.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

public enum GlobalUtils {
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    static var base2chPath: String {
        return "https://2ch.hk"
    }
    
    static var base2chPathWithoutScheme: String {
        return "2ch.hk"
    }
    
    static var boardWarning: String {
        return """
        - Содержимое данного приложения предназначено ТОЛЬКО для лиц, достигших совершеннолетия. Если вы несовершеннолетний, нажмите "Выйти" и удалите приложение.
        
        - На данной доске может быть контент эротического содержания, а также контент, явно оскорбляющий ваши чувства. Если вы чувствуете, что ваши чувства могут быть задеты, нажмите "Выйти" и удалите приложение.
        
        - Нажав на "Продолжить", вы соглашаетесь с тем, что разработчики приложения не несут ответственности за любые неудобства, которые может понести за собой использование вами приложения, а также, что вы понимаете, что опубликованное на сайте содержимое не является собственностью или созданием Двача, однако принадлежит и создается пользователями Двача.
        """
    }
}

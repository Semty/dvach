//
//  Style.swift
//  dvach
//
//  Created by Ruslan Timchenko on 08/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

class Style {
    
    class func post(text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.commentRegular, NSAttributedString.Key.foregroundColor: UIColor.n1Gray])
    }
    
    class func em(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.font : UIFont.commentEm], range: range)
    }
    
    class func spanStyle(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.font : UIFont.commentStrong], range: range)
    }
    
    class func strong(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.font : UIFont.commentStrong], range: range)
    }
    
    class func backgroundColor(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.a2Yellow],
                           range: range)
    }
    
    class func emStrong(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.font : UIFont.commentEmStrong], range: range)
    }
    
    class func underline(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single], range: range)
    }
    
    class func spoiler(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.n5LightGray], range: range)
    }
    
    class func quote(text: NSMutableAttributedString, range: NSRange) {
        text.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.a1Green],
                           range: range)
    }
    
    class func linkPost(text: NSMutableAttributedString, range: NSRange, url: URL? = nil) {
        var attrs: [NSAttributedString.Key:Any] = [NSAttributedString.Key.foregroundColor: UIColor.a3Orange]
        if let url = url {
            attrs[NSAttributedString.Key.link] = url
        }
        text.addAttributes(attrs, range: range)
    }
}

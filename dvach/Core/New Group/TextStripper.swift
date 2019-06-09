//
//  TextStripper.swift
//  dvach
//
//  Created by Ruslan Timchenko on 08/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

class TextStripper {
    
    static func removeAllHTMLTags(in text: String) -> String {
        let str = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    static func removeAllCSSTags(in text: String) -> String {
        let str = text.replacingOccurrences(of: "<style type=\"text/css\">(.+?)</style>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    static func htmlToNormal(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#44;", with: ",")
            .replacingOccurrences(of: "&#47;", with: "/")
            .replacingOccurrences(of: "&#92;", with: "\\")
            .replacingOccurrences(of: "\\n", with: " ")
            .replacingOccurrences(of: "\\r", with: "")
            .replacingOccurrences(of: "\\t", with: " ")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "<br />", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
    }
    
    static func finishHtmlToNormal(in text: NSMutableString) {
        
        text.replaceOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        text.replaceOccurrences(of: "&nbsp;", with: "\n", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
    }
    
    static func removeAllDoubleLineBreaks(in text: NSMutableString) {
        var textReplacingState = -1
        while textReplacingState != 0 {
            textReplacingState = text.replaceOccurrences(of: "\n\n", with: "\n", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: text.length))
        }
    }
    
    static func finishHtmlToNormalString(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\\")
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }
    
    
    static func ampToNormal(in text: String) -> String {
        return text
            .replacingOccurrences(of: "&amp;", with: "&")
    }
    
    static func clean(text: String) -> String {
        return text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    static func fullClean(text: String) -> String {
        var newText = TextStripper.removeAllCSSTags(in: text)
        newText = TextStripper.removeAllHTMLTags(in: newText)
        newText = TextStripper.ampToNormal(in: newText)
        newText = TextStripper.htmlToNormal(in: newText)
        newText = TextStripper.finishHtmlToNormalString(in: newText)
        newText = TextStripper.clean(text: newText)
        return newText
    }
}

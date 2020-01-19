//
//  Extention+String.swift
//  Receipt
//
//  Created by Kirill Solovyov on 25.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias Attributes = [NSAttributedString.Key: Any]

extension String {
    
    var removeSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func substring(_ from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        var to = to
        if to >= count {
            to = count
        }
        let end = index(startIndex, offsetBy: to)
        return String(self[start ..< end])
    }
    
    func substring(in range: NSRange) -> String {
        return substring(range.location, to: range.location + range.length)
    }
    
    // MARK: - Text Parsing helpers
    
    var parsed2chPost: String {
        return removeAllCSSTags()
            .removeAllCSSScripts()
            .htmlToNormal()
            .removeAllHTMLTags()
            .ampToNormal()
            .finishHtmlToNormalString()
            .trimWhitespacesAndNewlines()
            .removeAllDoubleLineBreaks()
    }
    
    var parsed2chSubject: String {
       return htmlToNormal().finishHtmlToNormalString().trimWhitespacesAndNewlines()
    }
    
    func removeAllCSSTags() -> String {
        let str = replacingOccurrences(of: "<style[^>]*>(.+?)</style>",
                                       with: "",
                                       options: .regularExpression,
                                       range: nil)
        return str
    }
    
    func removeAllCSSScripts() -> String {
        let str = replacingOccurrences(of: "<script(.*?)>(.+?)</script>",
                                       with: "",
                                       options: .regularExpression,
                                       range: nil)
        return str
    }
    
    func removeAllHTMLTags() -> String {
        let str = replacingOccurrences(of: "<[^>]+>",
                                       with: "",
                                       options: .regularExpression,
                                       range: nil)
        return str
    }
    
    func htmlToNormal() -> String {
        return self
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
            .replacingOccurrences(of: "</br>", with: "\n")
            .replacingOccurrences(of: "<li>", with: "\n\n\u{2022} ")
    }
    
    func removeAllDoubleLineBreaks() -> String {
        var text = self
        text = text.trimmingCharacters(in: .newlines)
        while let rangeToReplace = text.range(of: "\n\n") {
            text.replaceSubrange(rangeToReplace, with: "\n")
        }
        return text
    }
    
    func finishHtmlToNormalString() -> String {
        return self
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }
    
    func ampToNormal() -> String {
        return self
            .replacingOccurrences(of: "&amp;", with: "&")
    }
    
    func trimWhitespacesAndNewlines() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func cyrillized() -> String {
        return self
            .replacingOccurrences(of: "A", with: "А")
            .replacingOccurrences(of: "a", with: "а")
            .replacingOccurrences(of: "B", with: "В")
            .replacingOccurrences(of: "C", with: "С")
            .replacingOccurrences(of: "c", with: "с")
            .replacingOccurrences(of: "E", with: "Е")
            .replacingOccurrences(of: "e", with: "е")
            .replacingOccurrences(of: "H", with: "Н")
            .replacingOccurrences(of: "K", with: "К")
            .replacingOccurrences(of: "k", with: "к")
            .replacingOccurrences(of: "M", with: "М")
            .replacingOccurrences(of: "m", with: "т")
            .replacingOccurrences(of: "n", with: "п")
            .replacingOccurrences(of: "O", with: "О")
            .replacingOccurrences(of: "o", with: "о")
            .replacingOccurrences(of: "P", with: "Р")
            .replacingOccurrences(of: "p", with: "р")
            .replacingOccurrences(of: "R", with: "Я")
            .replacingOccurrences(of: "T", with: "Т")
            .replacingOccurrences(of: "U", with: "И")
            .replacingOccurrences(of: "u", with: "и")
            .replacingOccurrences(of: "X", with: "Х")
            .replacingOccurrences(of: "x", with: "х")
            .replacingOccurrences(of: "Y", with: "У")
            .replacingOccurrences(of: "y", with: "у")
            .replacingOccurrences(of: "6", with: "б")
            .replacingOccurrences(of: "3", with: "з")
            .replacingOccurrences(of: "4", with: "ч")
            .replacingOccurrences(of: "0", with: "о")
    }
    
    // MARK: - Ranges and Slices of String
    
    func ranges(of string: String, options: CompareOptions = .regularExpression) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func slices(from: String, to: String) -> [Substring] {
        let pattern = "(?<=" + from + ").*?(?=" + to + ")"
        return ranges(of: pattern, options: .regularExpression)
            .map{ self[$0] }
    }
    
    func slices(pattern: String) -> [(substring: Substring, range: Range<Index>)] {
        let pattern = pattern
        return ranges(of: pattern, options: .regularExpression)
            .map{ (self[$0], $0) }
    }
    
    // MARK: - For Auth
    
    static func attributes(withFont font: UIFont, color: UIColor? = nil, lineSpacing: CGFloat? = nil, textAlignment: NSTextAlignment? = nil, kern: CGFloat? = nil) -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing ?? 0
        style.alignment = textAlignment ?? .natural
        
        return [NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.foregroundColor: color ?? UIColor.black,
                NSAttributedString.Key.kern: kern ?? 0]
    }
    
    static func attributes(_ attributes: [NSAttributedString.Key: Any], font: UIFont? = nil, color: UIColor? = nil) -> [NSAttributedString.Key: Any] {
        var copy = attributes
        
        if let font = font {
            copy[NSAttributedString.Key.font] = font
        }
        
        if let color = color {
            copy[NSAttributedString.Key.foregroundColor] = color
        }
        
        return copy
    }
    
    func withAttributes(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func isEmailValid() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isNameValid() -> Bool {
        let regEx = "^[\\p{L}'][\\p{L}' -]{1,25}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        let regEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
}

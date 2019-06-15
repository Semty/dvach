//
//  Extention+String.swift
//  Receipt
//
//  Created by Kirill Solovyov on 25.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

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
}

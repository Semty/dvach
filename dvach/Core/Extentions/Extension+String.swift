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
    
    // MARK: - Text Parsing helpers
    
    func convertHTMLToTextFor(text: String) -> String {
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

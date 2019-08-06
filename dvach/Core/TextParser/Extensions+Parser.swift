//
//  Extensions+Parser.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension String {
    
    // Span Style Tags
    static let styleFontBold = "font-weight: bold"
    static let styleBackgroundColor = "background-color:"
    static let styleTextColor = "color:"
    
    // Regular Expressions for Parsing
    static let linkFirstFormat = "href=\"(.*?)\""
    static let linkSecondFormat = "href='(.*?)'"
    static let regexLink = "<a[^>]*>(.*?)</a>"
    static let regexStrong = "<strong[^>]*>(.*?)</strong>"
    static let regexBold = "<b[^>]*>(.*?)</b>"
    static let regexFontColor = "<font color=(.*?)>(.*?)</font>"
    static let regexEm = "<em[^>]*>(.*?)</em>"
    static let regexUnderline = "<span class=\"u\">(.*?)</span>"
    static let regexInserted = "<ins>(.*?)</ins>"
    static let regexSpoiler = "<span class=\"spoiler\">(.*?)</span>"
    static let regexStrike = "<span class=\"s\">(.*?)</span>"
    static let regexQuote = "<span class=\"unkfunc\">(.*?)</span>"
    static let regexSpanStyle = "<span (.*?)>(.*?)</span>"
    static let regexHTML = "<[^>]*>"
    static let regexCSSStyle = "<style[^>]*>(.+?)</style>"
    static let regexCSSScript = "<script(.*?)>(.+?)</script>"
    static let regexParagraph = "<p[^>]*>(.*?)</p>"
    static let regexHeading = "<h[1|2|3][^>]*>(.*?)</h[1|2|3]>"
    
    // Set Font and Color for given text and return as NSMutableAttributedString
    func setFontAndColor() -> NSMutableAttributedString {
        return
            NSMutableAttributedString(string: self,
                                      attributes: [.font: UIFont.commentRegular,
                                                   .foregroundColor: UIColor.n1Gray])
    }
    
    // Get URL from 2ch Link (and get nil if it is not)
    func getURLFrom2chLink() -> URL? {
        guard let url = URL(string: self) else {
            return nil
        }
        
        if let host = url.host {
            // might be external link
            let wwwBaseHost = "www." + GlobalUtils.base2chPathWithoutScheme
            if wwwBaseHost.contains(host) {
                return url
            } else {
                return nil
            }
        } else {
            return url
        }
    }
    
    // Check whether is given regex exist
    func isMatch(regex: String) -> Bool? {
        if let checker = try? NSRegularExpression(pattern: regex,
                                                  options: .caseInsensitive) {
            if let result = checker.firstMatch(in: self,
                                               options: .reportProgress,
                                               range: NSRange(location: 0,
                                                              length: count)) {
                return result.range.length == count
            }
        }
        
        return nil
    }
}

extension URL {
    
    func parse2chLink() -> DvachLink? {
        
        var board: String?
        var thread: String?
        var post: String?
        
        let components = pathComponents.filter { $0 != "/" }
        
        if components.count > 0 {
            board = components[0]
            if let isItBoard = components[0].isMatch(regex: "[a-z, A-Z]+"), !isItBoard {
                return nil
            }
        }
        
        if components.count > 2 {
            thread = components[2].replacingOccurrences(of: ".html", with: "")
            if let isItThread = components[2].isMatch(regex: "[0-9]+.html"), !isItThread {
                return nil
            }
        }
        
        if let fragment = fragment {
            post = fragment
            if let isItPost = fragment.isMatch(regex: "[0-9]+"), !isItPost {
                return nil
            }
        }
        
        switch (board, thread, post) {
        case (.some(let boardId), nil, nil):
            return .board(boardId)
        case (.some(let boardId), .some(let threadId), nil):
            return .thread(boardId: boardId, threadId: threadId)
        case (.some(let boardId), .some(let threadId), .some(let postId)):
            return .post(boardId: boardId, threadId: threadId, postId: postId)
        default:
            return nil
        }
    }
}

extension NSMutableAttributedString {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    func em(range: NSRange) {
        addAttributes([.font: UIFont.commentEm], range: range)
    }
    
    func spanStyle(range: NSRange) {
        addAttributes([.font: UIFont.commentStrong], range: range)
    }
    
    func strong(range: NSRange) {
        addAttributes([.font: UIFont.commentStrong], range: range)
    }
    
    func paragraph(range: NSRange) {
        insert(NSAttributedString(string: "\n\n"), at: range.location+range.length)
        insert(NSAttributedString(string: "\n\n"), at: range.location)
    }
    
    func heading(range: NSRange) {
        insert(NSAttributedString(string: "\n\n"), at: range.location+range.length)
        insert(NSAttributedString(string: "\n"), at: range.location)
        addAttributes([.font: UIFont.commentHeading], range: range)
    }
    
    func backgroundColor(range: NSRange, color: UIColor) {
        addAttributes([.backgroundColor: color], range: range)
    }
    
    func textColor(range: NSRange) {
        addAttributes([.foregroundColor: UIColor.n12Redline], range: range)
    }
    
    func emStrong(range: NSRange) {
        addAttributes([.font: UIFont.commentEmStrong], range: range)
    }
    
    func underline(range: NSRange) {
        addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
    }
    
    func strike(range: NSRange) {
        addAttributes([.nantesLabelStrikeOut: true], range: range)
    }
    
    func spoiler(range: NSRange) {
        addAttributes([.foregroundColor: UIColor.n5LightGray], range: range)
    }
    
    func quote(range: NSRange) {
        addAttributes([.foregroundColor: UIColor.a1Green], range: range)
    }
    
    func linkPost(range: NSRange, url: URL?) {
        var attrs: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.a3Orange]
        if let url = url {
            attrs[.link] = url
        }
        addAttributes(attrs, range: range)
    }
}

extension NSMutableString {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    func finishHtmlToNormal() {
        replaceOccurrences(of: "&gt;", with: ">",
                           options: .caseInsensitive,
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "&lt;", with: "<",
                           options: .caseInsensitive,
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "&quot;", with: "\"",
                           options: .caseInsensitive,
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "&amp;", with: "&",
                           options: .caseInsensitive,
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "&nbsp;", with: "\n",
                           options: .caseInsensitive,
                           range: NSRange(location: 0, length: length))
    }
    
    func cyrillized() {
        replaceOccurrences(of: "A", with: "А",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "a", with: "а",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "B", with: "В",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "C", with: "С",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "c", with: "c",
                           range: NSRange(location: 0, length: length))
            
        replaceOccurrences(of: "E", with: "Е",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "e", with: "е",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "H", with: "Н",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "K", with: "К",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "k", with: "к",
                           range: NSRange(location: 0, length: length))
            
        replaceOccurrences(of: "M", with: "М",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "m", with: "т",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "n", with: "п",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "O", with: "О",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "o", with: "о",
                           range: NSRange(location: 0, length: length))
        
        replaceOccurrences(of: "P", with: "Р",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "p", with: "р",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "R", with: "Я",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "T", with: "Т",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "U", with: "И",
                           range: NSRange(location: 0, length: length))
        
        replaceOccurrences(of: "u", with: "и",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "X", with: "Х",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "x", with: "х",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "Y", with: "У",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "y", with: "у",
                           range: NSRange(location: 0, length: length))
        
        replaceOccurrences(of: "6", with: "б",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "3", with: "з",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "4", with: "ч",
                           range: NSRange(location: 0, length: length))
        replaceOccurrences(of: "0", with: "о",
                           range: NSRange(location: 0, length: length))
    }
    
    func removeAllTripleLineBreaks() {
        var textReplacingState = -1
        while textReplacingState != 0 {
            textReplacingState =
                replaceOccurrences(of: "\n\n\n",
                                   with: "\n\n",
                                   options: .caseInsensitive,
                                   range: NSRange(location: 0, length: length))
        }
    }
}

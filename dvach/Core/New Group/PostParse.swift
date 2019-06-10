//
//  PostParse.swift
//  dvach
//
//  Created by Ruslan Timchenko on 08/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {

    // Span Style Tags
    static let spanStyleFontBold = "font-weight: bold"
    static let spanStyleBackgroundColor = "background-color:"
    
    // Regular Expressions for Parsing
    static let linkFirstFormat = "href=\"(.*?)\""
    static let linkSecondFormat = "href='(.*?)'"
    static let regexLink = "<a[^>]*>(.*?[\\s\\S])</a>"
    static let regexStrong = "<strong[^>]*>(.*?)</strong>"
    static let regexEm = "<em[^>]*>(.*?)</em>"
    static let regexUnderline = "<span class=\"u\">(.*?)</span>"
    static let regexSpoiler = "<span class=\"spoiler\">(.*?)</span>"
    static let regexQuote = "<span class=\"unkfunc\">(.*?)</span>"
    static let regexSpanStyle = "<span (.*?)>(.*?)</span>"
    static let regexHTML = "<[^>]*>"
    static let regexCSS = "<style type=\"text/css\">(.+?)</style>"
    
    // Set Font and Color for given text and return as NSMutableAttributedString
    func setFontAndColor() -> NSMutableAttributedString {
        return
            NSMutableAttributedString(string: self,
                                      attributes: [.font: UIFont.commentRegular,
                                                   .foregroundColor: UIColor.n1Gray])
    }
}

private extension NSMutableAttributedString {
    
    func em(range: NSRange) {
        addAttributes([.font: UIFont.commentEm], range: range)
    }
    
    func spanStyle(range: NSRange) {
        addAttributes([.font: UIFont.commentStrong], range: range)
    }
    
    func strong(range: NSRange) {
        addAttributes([.font: UIFont.commentStrong], range: range)
    }
    
    func backgroundColor(range: NSRange) {
        addAttributes([.backgroundColor: UIColor.a2Yellow], range: range)
    }
    
    func emStrong(range: NSRange) {
        addAttributes([.font: UIFont.commentEmStrong], range: range)
    }
    
    func underline(range: NSRange) {
        addAttributes([.underlineStyle: NSUnderlineStyle.single], range: range)
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

private extension NSMutableString {
    
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

struct PostParse {
    
    // Public Variables (get)
    
    private(set) var attributedText: NSMutableAttributedString
    
    // Private Variables
    
    private let text: String
    
    private var attributedTextString: String {
        return attributedText.string
    }
    
    private var range: NSRange {
        return NSRange(location: 0, length: attributedTextString.count)
    }
    
    // MARK: - Initialization
    
    init(text: String) {
        self.text = text.htmlToNormal()
        
        let attributedText = self.text.setFontAndColor()
        self.attributedText = attributedText
        
        parse()
    }
    
    // MARK: - Parse String Process
    
    private func parse() {

        emAndStrongParse(in: range)
        spanStyleParse(in: range)
        //underlineParse(in: range) // Не работает
        //strikeParse(in: range) // Не реализован
        spoilerParse(in: range)
        quoteParse(in: range)
        linkParse(in: range)
        removeCSSTags(in: range)
        removeHTMLTags(in: range)
        
        attributedText.mutableString.finishHtmlToNormal()
        attributedText.mutableString.removeAllTripleLineBreaks()
    }
    
    // MARK: - Regular Expressions Helpers
    
    private func regexFind(regex regexString: String, range fullRange: NSRange, result: (NSRange) -> ()) {
        if let regex = prepareRegex(regexString) {
            
            regex.enumerateMatches(in: attributedTextString,
                                   options: .reportProgress,
                                   range: fullRange) { res, flags, stop in
                if let rng = res?.range {
                    result(rng)
                }
            }
        }
    }
    
    private func prepareRegex(_ string: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: string, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    private func regexDelete(regex regexString: String, range fullRange: NSRange) {
        regexFind(regex: regexString, range: fullRange) { range in
            if range.length != 0 {
                self.attributedText.deleteCharacters(in: range)
            }
        }
    }
    
    // MARK: - Parse Functions
    
    private func spanStyleParse(in range: NSRange) {
        var spanStyles = [NSRange]()
        
        regexFind(regex: .regexSpanStyle, range: range) { range in
            spanStyles.append(range)
        }
        
        spanStyles.forEach { range in
            
            let substring = (self.attributedTextString as NSString).substring(with: range)
            if substring.contains(String.spanStyleFontBold) {
                self.attributedText.strong(range: range)
            }
            if substring.contains(String.spanStyleBackgroundColor) {
                self.attributedText.backgroundColor(range: range)
            }
        }
    }
    
    private func emAndStrongParse(in range: NSRange) {
        var ems: [NSRange] = []
        var strongs: [NSRange] = []
        
        regexFind(regex: .regexEm, range: range) { range in
            self.attributedText.em(range: range)
            ems.append(range)
            
        }
        
        regexFind(regex: .regexStrong, range: range) { range in
            self.attributedText.strong(range: range)
            strongs.append(range)
        }
        
        for em in ems {
            for strong in strongs {
                let emStrongRange = NSIntersectionRange(em, strong)
                if emStrongRange.length != 0 {
                    attributedText.emStrong(range: emStrongRange)
                }
            }
        }
    }
    
    
    
    private func underlineParse(in range: NSRange) {
        regexFind(regex: .regexUnderline, range: range) { range in
            self.attributedText.underline(range: range)
        }
    }
    
//    private func strikeParse(in range: NSRange) {
//
//    }
    
    private func spoilerParse(in range: NSRange) {
        regexFind(regex: .regexSpoiler, range: range) { range in
            self.attributedText.spoiler(range: range)
        }
        
//        let spoilerRanges = text.ranges(of: "<span class=\"spoiler\">(.*?)</span>")
//        spoilerRanges.forEach { [weak self] range in
//            guard self != nil else { return }
//            Style.quoteParse(attrText: attributedText,
//                        text: text,
//                        range: range)
//        }
    }
    
    private func quoteParse(in range: NSRange) {
        regexFind(regex: .regexQuote, range: range) { range in
            self.attributedText.quote(range: range)
        }
        
//        let quoteRanges = text.ranges(of: "<span class=\"unkfunc\">(.*?)</span>")
//        quoteRanges.forEach { [weak self] range in
//            guard self != nil else { return }
//            Style.quoteParse(attrText: attributedText,
//                        text: text,
//                        range: range)
//        }
    }
    
    private func linkParse(in fullRange: NSRange) {
        
        guard let linkFirstFormat = prepareRegex(.linkFirstFormat) else { return }
        guard let linkSecondFormat = prepareRegex(.linkSecondFormat)  else { return }

        regexFind(regex: .regexLink, range: fullRange) { range in
            
            let fullLink = (self.attributedTextString as NSString).substring(with: range)
            let fullLinkRange = NSRange(location: 0, length: fullLink.count)
            
            var addingUrl: URL?
            var urlRange = NSRange(location: 0, length: 0)
            
            if let linkResult =
                linkFirstFormat.firstMatch(in: fullLink,
                                           options: .reportProgress,
                                           range: fullLinkRange) {
                
                if linkResult.numberOfRanges != 0 {
                    urlRange = NSMakeRange(linkResult.range.location+6,
                                           linkResult.range.length-7);
                }
            } else if let linkResult =
                linkSecondFormat.firstMatch(in: fullLink,
                                            options: .reportProgress,
                                            range: fullLinkRange) {
                
                if linkResult.numberOfRanges != 0 {
                    urlRange = NSMakeRange(linkResult.range.location+6, linkResult.range.length-7);
                }
            }
            
            if urlRange.length != 0 {
                let linkSubstring = (fullLink as NSString).substring(with: urlRange)
                let urlString = linkSubstring.ampToNormal()
                addingUrl = URL(string: urlString)
            }
            
            attributedText.linkPost(range: range, url: addingUrl)
        }
    }
    
    // MARK: - Remove Redundant Strings Functions
    
    private func removeHTMLTags(in fullRange: NSRange) {
        var ranges = [NSRange]()
        
        regexFind(regex: .regexHTML, range: fullRange) { range in
            ranges.append(range)
        }

        var shift = 0
        for range in ranges {
            let newRange = NSRange(location: range.location - shift, length: range.length)
            self.attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
    
    private func removeCSSTags(in fullRange: NSRange) {
        var cssRanges = [NSRange]()
        
        regexFind(regex: .regexCSS, range: fullRange) { range in
            cssRanges.append(range)
        }
        
        var shift = 0
        for range in cssRanges {
            let newRange = NSRange(location: range.location - shift,
                                   length: range.length)
            self.attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
}

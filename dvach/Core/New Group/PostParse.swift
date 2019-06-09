//
//  PostParse.swift
//  dvach
//
//  Created by Ruslan Timchenko on 08/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {
    // Link Formats
    static var linkFirstFormat = "href=\"(.*?)\""
    static var linkSecondFormat = "href='(.*?)'"
    
    // Regular Expressions for Parsing
    static var regexLink = "<a[^>]*>(.*?[\\s\\S])</a>"
    static var regexStrong = "<strong[^>]*>(.*?)</strong>"
    static var regexEm = "<em[^>]*>(.*?)</em>"
    static var regexUnderline = "<span class=\"u\">(.*?)</span>"
    static var regexSpoiler = "<span class=\"spoiler\">(.*?)</span>"
    static var regexQuote = "<span class=\"unkfunc\">(.*?)</span>"
    static var regexSpanStyle = "<span (.*?)>(.*?)</span>"
    static var regexHTML = "<[^>]*>"
    static var regexCSS = "<style type=\"text/css\">(.+?)</style>"
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
    
    private var regexOption: NSRegularExpression.Options {
        return NSRegularExpression.Options.caseInsensitive
    }
    
    private var regexMatchingOption: NSRegularExpression.MatchingOptions {
        return NSRegularExpression.MatchingOptions.init(rawValue: 0)
    }
    
    // MARK: - Initialization
    
    init(text: String) {
        self.text = TextStripper.htmlToNormal(in: text)
        
        let attributedText = Style.post(text: self.text)
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
        
        TextStripper.finishHtmlToNormal(in: attributedText.mutableString)
        //TextStripper.removeAllDoubleLineBreaks(in: attributedText.mutableString)
    }
    
    // MARK: - Helpful Functions
    
    private func regexFind(regex regexString: String, range fullRange: NSRange, result: (NSRange) -> ()) {
        if let regex = prepareRegex(regexString) {
            
            regex.enumerateMatches(in: attributedTextString,
                                   options: regexMatchingOption,
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
        self.regexFind(regex: regexString, range: fullRange) { range in
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
            if substring.contains("font-weight: bold") {
                Style.strong(text: self.attributedText, range: range)
            }
            if substring.contains("background-color:") {
                Style.backgroundColor(text: self.attributedText, range: range)
            }
        }
    }
    
    private func emAndStrongParse(in range: NSRange) {
        var ems: [NSRange] = []
        var strongs: [NSRange] = []
        
        self.regexFind(regex: .regexEm, range: range) { range in
            Style.em(text: self.attributedText, range: range)
            ems.append(range)
            
        }
        
        self.regexFind(regex: .regexStrong, range: range) { range in
            Style.strong(text: self.attributedText, range: range)
            strongs.append(range)
        }
        
        for em in ems {
            for strong in strongs {
                let emStrongRange = NSIntersectionRange(em, strong)
                if emStrongRange.length != 0 {
                    Style.emStrong(text: attributedText, range: emStrongRange)
                }
            }
        }
    }
    
    
    
    private func underlineParse(in range: NSRange) {
        self.regexFind(regex: .regexUnderline, range: range) { range in
            Style.underline(text: self.attributedText, range: range)
        }
    }
    
    private func strikeParse(in range: NSRange) {
        
    }
    
    private func spoilerParse(in range: NSRange) {
        self.regexFind(regex: .regexSpoiler, range: range) { range in
            Style.spoiler(text: self.attributedText, range: range)
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
        self.regexFind(regex: .regexQuote, range: range) { range in
            Style.quote(text: self.attributedText, range: range)
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
            var addingUrl: URL? = nil
            var urlRange = NSRange(location: 0, length: 0)
            
            if let linkResult = linkFirstFormat.firstMatch(in: fullLink, options: regexMatchingOption, range: fullLinkRange) {
                
                if linkResult.numberOfRanges != 0 {
                    urlRange = NSMakeRange(linkResult.range.location+6, linkResult.range.length-7);
                }
            } else if let linkResult = linkSecondFormat.firstMatch(in: fullLink, options: regexMatchingOption, range: fullLinkRange) {
                
                if linkResult.numberOfRanges != 0 {
                    urlRange = NSMakeRange(linkResult.range.location+6, linkResult.range.length-7);
                }
            }
            
            if urlRange.length != 0 {
                let urlString = TextStripper.ampToNormal(in: (fullLink as NSString).substring(with: urlRange))
                addingUrl = URL(string: urlString)
            }
            
            Style.linkPost(text: attributedText, range: range, url: addingUrl)
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
            let newRange = NSRange(location: range.location - shift, length: range.length)
            self.attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
}

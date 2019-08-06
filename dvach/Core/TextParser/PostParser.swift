//
//  PostParser.swift
//  dvach
//
//  Created by Ruslan Timchenko on 10/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PostParser {
    
    // Public Variables (get)
    
    private(set) var attributedText: NSMutableAttributedString
    private(set) var dvachLinkModels = [DvachLink]()
    
    // Private Variables
    
    private var attributedTextString: String {
        return attributedText.string
    }
    
    private var range: NSRange {
        return NSRange(location: 0, length: attributedText.length)
    }
    
    // Dependencies
    private let profanityCensor = Locator.shared.profanityCensor()
    
    // MARK: - Initialization
    
    init(text: String) {
        
        let attributedText = text.htmlToNormal().setFontAndColor()
        self.attributedText = attributedText
        
        parse()
    }
    
    // MARK: - Parse String Process
    
    private func parse() {
        
        headingParse(in: range)
        paragraphParse(in: range)
        fontColor(in: range)
        emAndStrongParse(in: range)
        boldParse(in: range)
        spanStyleParse(in: range)
        underlineParse(in: range)
        strikeParse(in: range)
        spoilerParse(in: range)
        quoteParse(in: range)
        linkParse(in: range)
        removeCSSScripts(in: range)
        removeCSSTags(in: range)
        removeHTMLTags(in: range)
        
        attributedText.mutableString.finishHtmlToNormal()
        attributedText.mutableString.removeAllTripleLineBreaks()
        
        censorProfanity()
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
        return try? NSRegularExpression(pattern: string,
                                        options: [.caseInsensitive,
                                                  .dotMatchesLineSeparators])
    }
    
    private func regexDelete(regex regexString: String, range fullRange: NSRange) {
        regexFind(regex: regexString, range: fullRange) { range in
            if range.length != 0 {
                attributedText.deleteCharacters(in: range)
            }
        }
    }
    
    // MARK: - Parse Functions
    
    private func headingParse(in range: NSRange) {
        var shift = 0
        regexFind(regex: .regexHeading, range: range) { range in
            var range = range
            range.location += shift
            attributedText.heading(range: range)
            shift += 3
        }
    }
    
    private func paragraphParse(in range: NSRange) {
        var shift = 0
        regexFind(regex: .regexParagraph, range: range) { range in
            var range = range
            range.location += shift
            attributedText.paragraph(range: range)
            shift += 4
        }
    }
    
    private func fontColor(in range: NSRange) {
        regexFind(regex: .regexFontColor, range: range) { range in
            attributedText.textColor(range: range)
        }
    }
    
    private func spanStyleParse(in range: NSRange) {
        var spanStyles = [NSRange]()
        
        regexFind(regex: .regexSpanStyle, range: range) { range in
            spanStyles.append(range)
        }
        
        spanStyles.forEach { range in
            
            let substring = attributedTextString.substring(in: range)
            if substring.contains(String.styleFontBold) {
                attributedText.strong(range: range)
            }
            
            parseBgAndFgColors(in: range)
        }
    }
    
    private func emAndStrongParse(in range: NSRange) {
        var ems: [NSRange] = []
        var strongs: [NSRange] = []
        
        regexFind(regex: .regexEm, range: range) { range in
            attributedText.em(range: range)
            ems.append(range)
            
        }
        
        regexFind(regex: .regexStrong, range: range) { range in
            attributedText.strong(range: range)
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
    
    private func boldParse(in range: NSRange) {
        regexFind(regex: .regexBold, range: range) { range in
            attributedText.strong(range: range)
            parseBgAndFgColors(in: range)
        }
    }
    
    private func underlineParse(in range: NSRange) {
        regexFind(regex: .regexUnderline, range: range) { range in
            attributedText.underline(range: range)
        }
        regexFind(regex: .regexInserted, range: range) { range in
            attributedText.underline(range: range)
        }
    }
    
    private func strikeParse(in range: NSRange) {
        regexFind(regex: .regexStrike, range: range) { range in
            attributedText.strike(range: range)
        }
    }
    
    private func spoilerParse(in range: NSRange) {
        regexFind(regex: .regexSpoiler, range: range) { range in
            attributedText.spoiler(range: range)
        }
    }
    
    private func quoteParse(in range: NSRange) {
        regexFind(regex: .regexQuote, range: range) { range in
            attributedText.quote(range: range)
        }
    }
    
    private func linkParse(in fullRange: NSRange) {
        
        guard let linkFirstFormat = prepareRegex(.linkFirstFormat) else { return }
        guard let linkSecondFormat = prepareRegex(.linkSecondFormat)  else { return }
        
        regexFind(regex: .regexLink, range: fullRange) { range in
            
            let fullLink = attributedTextString.substring(in: range)
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
                let linkSubstring = fullLink.substring(in: urlRange)
                let urlString = linkSubstring.ampToNormal()
                
                if let dvachURL = urlString.getURLFrom2chLink(),
                    let dvachLinkModel = dvachURL.parse2chLink() {
                    dvachLinkModels.append(dvachLinkModel)
                }
                
                addingUrl = URL(string: urlString)
            }
            
            attributedText.linkPost(range: range, url: addingUrl)
            parseBgAndFgColors(in: range)
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
            attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
    
    private func removeCSSTags(in fullRange: NSRange) {
        var cssRanges = [NSRange]()
        
        regexFind(regex: .regexCSSStyle, range: fullRange) { range in
            cssRanges.append(range)
        }
        
        var shift = 0
        for range in cssRanges {
            let newRange = NSRange(location: range.location - shift,
                                   length: range.length)
            attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
    
    private func removeCSSScripts(in fullRange: NSRange) {
        var cssRanges = [NSRange]()
        
        regexFind(regex: .regexCSSScript, range: fullRange) { range in
            cssRanges.append(range)
        }
        
        var shift = 0
        for range in cssRanges {
            let newRange = NSRange(location: range.location - shift,
                                   length: range.length)
            attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
    }
    
    // MARK: - Parse Background and Foreground Colors
    
    private func parseBgAndFgColors(in range: NSRange) {
        let substring = attributedTextString.substring(in: range)

        let bgColorRange = substring.range(of: String.styleBackgroundColor)
        
        if let _ = bgColorRange {
            if substring.contains(String.styleBackgroundColor + " rgb(255, 255, 255)") ||
                substring.contains(String.styleBackgroundColor + " white") {
                attributedText.backgroundColor(range: range, color: .n10WhiteIsh)
            } else {
                attributedText.backgroundColor(range: range, color: .n11EggYellow)
            }
        }
        
        if let textColorRange = substring.range(of: String.styleTextColor) {
            if let bgColorRange = bgColorRange, textColorRange.overlaps(bgColorRange) {
                return
            }
            attributedText.textColor(range: range)
        }
    }
    
    // MARK: - Censor Profanity
    
    private func censorProfanity() {
        profanityCensor.censor(attributedText, symbol: "*")
    }
}

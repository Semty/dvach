//
//  PostParser.swift
//  dvach
//
//  Created by Ruslan Timchenko on 10/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {
    
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
    static let regexCSSStyle = "<style type=\"text/css\">(.+?)</style>"
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

private extension URL {
    func parse2chLink() -> DvachLinkModel? {
        
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
            thread = components[2]
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
        
        return DvachLinkModel(board: board,
                              thread: thread?.replacingOccurrences(of: ".html",
                                                                   with: ""),
                              post: post)
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
        print(range)
        addAttributes([NSAttributedString.Key.strikethroughStyle: 2], range: range)
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

struct PostParser {
    
    // Public Variables (get)
    
    private(set) var attributedText: NSMutableAttributedString
    private(set) var dvachLinkModels = [DvachLinkModel]()
    
    public var repliedToPosts: [String] {
        var repliedToLinks = [String]()
        dvachLinkModels.forEach { linkModel in
            if let post = linkModel.post {
                repliedToLinks.append(post)
            }
        }
        return repliedToLinks
    }
    
    // Private Variables
    
    private var attributedTextString: String {
        return attributedText.string
    }
    
    private var range: NSRange {
        return NSRange(location: 0, length: attributedText.length)
    }
    
    // MARK: - Initialization
    
    init(text: String) {
        
        let attributedText = text.htmlToNormal().setFontAndColor()
        self.attributedText = attributedText
        
        parse()
    }
    
    // MARK: - Parse String Process
    
    private mutating func parse() {
        
        headingParse(in: range)
        paragraphParse(in: range)
        fontColor(in: range)
        emAndStrongParse(in: range)
        boldParse(in: range)
        spanStyleParse(in: range)
        underlineParse(in: range)
        //strikeParse(in: range) На данный момент Nantes не поддерживает striketrough
        spoilerParse(in: range)
        quoteParse(in: range)
        linkParse(in: range)
        removeCSSScripts(in: range)
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
            shift += 2
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
    
    private mutating func linkParse(in fullRange: NSRange) {
        
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
}

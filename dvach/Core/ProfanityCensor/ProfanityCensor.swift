//
//  ProfanityCensor.swift
//  dvach
//
//  Created by Ruslan Timchenko on 06/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {
    static let regexOfBannedWords = "\\b(\(BadWords.shared.string))\\b"
}

protocol IProfanityCensor {
    func censor(_ string: NSMutableAttributedString, symbol: String)
    func censor(_ string: String, symbol: String) -> String
}

final class ProfanityCensor: IProfanityCensor {
    
    func censor(_ string: NSMutableAttributedString, symbol: String) {
        guard let cyrillizedText = string.mutableCopy() as? NSMutableAttributedString else { return }
        cyrillizedText.mutableString.cyrillized()
        
        regexFind(regex: .regexOfBannedWords,
                  string: cyrillizedText.string,
                  range: NSRange(location: 0, length: cyrillizedText.length)) { [weak self] range in
                    guard let self = self else { return }
                    string.replaceCharacters(in: range,
                                             with: self.censorProfanityWord(string.mutableString.substring(with: range),
                                                                            symbol: "*"))
        }
    }
    
    func censor(_ string: String, symbol: String) -> String {
        var censorText = string
        let cyrillizedText = string.cyrillized()
        
        do {
            let regex = try NSRegularExpression(pattern: .regexOfBannedWords,
                                                options: [.caseInsensitive,
                                                          .dotMatchesLineSeparators])
            
            let results = regex.matches(in: cyrillizedText,
                                        range: NSRange(cyrillizedText.startIndex...,
                                                       in: cyrillizedText))
            _ = results.compactMap {
                Range($0.range, in: censorText).map {
                    let replacingString = String(censorText[$0])
                    censorText.replaceSubrange($0,
                                               with: censorProfanityWord(replacingString,
                                                                         symbol: symbol))
                }
            }
            return censorText
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return censorText
        }
    }
    
    private func regexFind(regex regexString: String, string: String, range fullRange: NSRange, result: (NSRange) -> ()) {
        if let regex = prepareRegex(regexString) {
            regex.enumerateMatches(in: string,
                                   options: .reportProgress,
                                   range: fullRange)
            { res, flags, stop in
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
    
    private func censorProfanityWord(_ string: String, symbol: String) -> String {
        let censorString = String(repeating: symbol, count: string.count)
        
        guard let firstCharacter = string.first else { return censorString }
        guard let lastCharacter = string.last else { return censorString }
        
        let length = string.count
        
        guard length > 1 else { return censorString }
        
        switch length {
        case 2:
            return symbol + "\(lastCharacter)"
        case 3...4:
            let symbols = String(repeating: symbol, count: length - 2)
            return "\(firstCharacter)" + symbols + "\(lastCharacter)"
        case 5:
            let firstTwoCharacters = string.substring(0, to: 2)
            let symbols = String(repeating: symbol, count: length - 3)
            return firstTwoCharacters + symbols + "\(lastCharacter)"
        case 6:
            let firstTwoCharacters = string.substring(0, to: 2)
            let lastTwoCharacters = string.substring(length - 2, to: length)
            let symbols = String(repeating: symbol, count: length - 4)
            return firstTwoCharacters + symbols + lastTwoCharacters
        default:
            let firstCharacters = string.substring(0, to: 3)
            if length == 7 {
                let lastCharacters = string.substring(length - 2, to: length)
                let symbols = String(repeating: symbol, count: length - 5)
                return firstCharacters + symbols + lastCharacters
            } else if length >= 8 {
                let lastCharacters = string.substring(length - 3, to: length)
                let symbols = String(repeating: symbol, count: length - 6)
                return firstCharacters + symbols + lastCharacters
            } else {
                return censorString
            }
        }
    }
}

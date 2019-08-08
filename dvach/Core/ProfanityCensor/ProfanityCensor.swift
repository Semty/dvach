//
//  ProfanityCensor.swift
//  dvach
//
//  Created by Ruslan Timchenko on 06/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {
    static let regexOfBannedWords = "\\w{0,5}[хx]([хx\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[уy]([уy\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[ёiлeеюийя]\\w{0,7}|\\w{0,6}[пp]([пp\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[iие]([iие\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[3зс]([3зс\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[дd]\\w{0,10}|[сcs][уy]([уy\\!@#\\$%\\^&*+-\\|\\/]{0,6})[4чkк]\\w{1,3}|\\w{0,4}[bб]([bб\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[lл]([lл\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[yя]\\w{0,10}|\\w{0,8}[её][bб][лске@eыиаa][наи@йвл]\\w{0,8}|\\w{0,4}[еe]([еe\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[бb]([бb\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[uу]([uу\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[н4ч]\\w{0,4}|\\w{0,4}[еeё]([еeё\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[бb]([бb\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[нn]([нn\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[уy]\\w{0,4}|\\w{0,4}[еe]([еe\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[бb]([бb\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[оoаaуyu@]([оoаaуyu@\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[тnнt]\\w{0,4}|\\w{0,10}[ё]([ё\\!@#\\$%\\^&*+-\\|\\/]{0,6})[б]\\w{0,6}|\\w{0,4}[pп]([pп\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[иeеi]([иeеi\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[дd]([дd\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[oоаa@еeиi]([oоаa@еeиi\\s\\!@#\\$%\\^&*+-\\|\\/]{0,6})[рr]\\w{0,12}|\\w{0,6}[cсs][уu][kк][aа]"
}

let whiteSetOfWords = Set<String>(
    ["ребенок", "ребенка", "ребенку", "ребенком", "ребеночек", "ребеночка", "ребеночку", "ребеночком", "ребёнок", "ребёнка", "ребёнку", "ребёнком", "ребёночек", "ребёночка", "ребёночку", "ребёночком", "застрахуй", "страхуй", "перестрахуй", "подстрахуй", "влюблялась", "влюблялись", "влюблялся", "влюблялось", "влюбляться", "мебель", "мебелью", "мебели", "мебельный", "мебельная", "мебельное", "небыло", "оскорблять", "сухую", "Galaxy Note", "теребил", "теребила", "теребили", "теребонькать", "теребонькаю", "теребонькал", "теребонькала", "теребонькали", "теребонькающий", "теребонькающая", "теребонькающие", "стебанул", "стебануло", "стебанула", "стебанули", "build-your", "build your", "build you", "отребляете", "хулиган", "хулиганский", "хулиганская", "хулиганскую", "хулиганску", "хулиганские", "сугублял", "сугубляла", "сугубляли", "сугубляется", "банк", "банки", "банка", "банком", "банками", "учеба", "учебка", "учебу", "учебы", "учебой", "учебный", "учебная", "учебную", "учебное", "учебной", "учёба", "учёбу", "учёбы", "учёбой", "учёбный", "учёбная", "учёбную", "учёбное", "учёбной", "пребывает", "пребывать", "пребывал", "пребывала", "пребывали", "пребывало", "пребывавший", "пребывавшая", "пребывавшие", "пребывавшое", "отреблять", "отребляю", "отреблял", "отребляла", "отребляющих", "отребляли", "отребляешь", "потребляю", "потреблять", "потреблял", "потребляла", "потребляли", "вебка", "вебкам", "вебкаммодель", "рубля", "рублях", "корабля", "трущеб", "трущёб", "трущебы", "трущёбы", "азгребать", "азгребал", "азгребала", "азгребали", "азгребавший", "азгребавшая", "азгребавшие", "loyability", "bloody", "торпедировать", "пребывание", "пребывания", "пребываю", "пребываем", "пребывающий", "пребывающая", "пребывающие", "azerbaijan", "capability", "скорблял", "скорбляла", "скорбляли", "скорблять", "гребенка", "гребенку", "гребенки", "гребенкой", "перебанил", "перебанила", "перебанили", "перебанить", "амеба", "амебы", "амебой", "амёба", "амёбы", "амёбой", "разгребать", "разгребал", "разгребала", "разгребали", "разгребающий", "разгребающая", "разгребающие", "разгребание", "разгребания", "разгребавший", "разгребавшая", "разгребавшие", "богохульство", "богохульства", "богохульством", "богахульство", "богахульства", "богахульством", "богохульник", "богахульник", "богохульница", "богахульница", "богохульники", "богахульники", "богохульницы", "богахульницы", "скорбляет", "скорбляешь", "скорблявший", "скорблявшая", "скорблявшие", "стреблять", "стреблял", "стребляла", "стребляли", "стреблявший", "стреблявшая", "стреблявшие", "стребляющий", "стребляющая", "стребляющие", "ремлебот", "ремлеботы", "ремлеботом", "ремлеботсво", "ремлеботсва", "ремлеботсвом"
    ])

let whiteArrayOfTags = [
    ".org", ".de", ".com", ".ru", ".io", ".uk", "tweet", "youtube", "vk", "tg", " б/у ", "и зд", "ебу н", "ебу т", "е бу", "еб у", "е ба", "еба н", "еба, н", "е-ба", "еб а", "е бо", "еб о", "ебо т", "ебо н", "е-бо", "e-ba", "e-bo", "e-bu", "e-by", "e ba", "e bo", "e bu", "e by", "е-бу", "ё бу", "ё-бу", "ху и", "сбер", "беларус", "белорус"
]

protocol IProfanityCensor {
    func censor(_ string: NSMutableAttributedString, symbol: String)
    func censor(_ string: String, symbol: String) -> String
}

final class ProfanityCensor: IProfanityCensor {
    
    func censor(_ string: NSMutableAttributedString, symbol: String) {
        regexFind(regex: .regexOfBannedWords,
                  string: string.string,
                  range: NSRange(location: 0, length: string.length)) { [weak self] range in
                    guard let self = self else { return }
                    let replacingString = string.mutableString.substring(with: range)
                    let lowercasedString = replacingString.lowercased()
                    if !whiteSetOfWords.contains(lowercasedString) && !isStringOkay(lowercasedString) {
                        print("\nPOST||| \(replacingString)")
                        string.replaceCharacters(in: range,
                                                 with: self.censorProfanityWord(replacingString,
                                                                                symbol: "*"))
                    }
        }
    }
    
    func censor(_ string: String, symbol: String) -> String {
        var censorText = string
        
        do {
            let regex = try NSRegularExpression(pattern: .regexOfBannedWords,
                                                options: [.caseInsensitive])
            
            let results = regex.matches(in: censorText,
                                        range: NSRange(censorText.startIndex...,
                                                       in: censorText))
            _ = results.compactMap {
                Range($0.range, in: censorText).map {
                    let replacingString = String(censorText[$0])
                    let lowercasedString = replacingString.lowercased()
                    if !whiteSetOfWords.contains(lowercasedString) && !isStringOkay(lowercasedString) {
                        print("\nPREVIEW||| \(replacingString)")
                        censorText.replaceSubrange($0,
                                                   with: censorProfanityWord(replacingString,
                                                                             symbol: symbol))
                    }
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
            let firstCharacters = string.substring(0, to: 2)
            if length == 7 {
                let lastCharacters = string.substring(length - 3, to: length)
                let symbols = String(repeating: symbol, count: length - 5)
                return firstCharacters + symbols + lastCharacters
            } else if length >= 8 {
                let lastCharacters = string.substring(length - 4, to: length)
                let symbols = String(repeating: symbol, count: length - 6)
                return firstCharacters + symbols + lastCharacters
            } else {
                return censorString
            }
        }
    }
    
    private func isStringOkay(_ string: String) -> Bool {
        if string.count >= 10 &&
            (string.contains("-") ||
                string.contains("/") ||
                string.contains(" ") ||
                string.contains(".") ||
                string.contains("=") ||
                string.contains("_")) {
            return true
        }
        
        for tag in whiteArrayOfTags {
            if string.contains(tag) {
                return true
            }
        }
        
        return false
    }
}

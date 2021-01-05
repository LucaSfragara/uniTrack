//
//  Utilities.swift
//  uniTrack
//
//  Created by Luca Sfragara on 20/12/20.
//

import Foundation
import UIKit

class Utilities{
    
    static func createAlertView(title: String, message: String?, completion: @escaping()->())->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Yes", style: .default){action in
            completion()
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        return alert
    }
    
    static func getCountryList() -> [Country]{
        
        var countries: [Country] = []
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(Country(name: name, isoCountryCode: code))
        }
        return countries
    }
}

struct Country{
    
    var name: String
    var isoCountryCode: String
    var flag: String?{
        get{
            func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
                        return scalar.value >= 0x61 && scalar.value <= 0x7A
                    }

                    func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
                        precondition(isLowercaseASCIIScalar(scalar))

                        // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
                        // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
                        return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
                    }

                    let lowercasedCode = isoCountryCode.lowercased()
                    guard lowercasedCode.count == 2 else { return nil }
                    guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

                    let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
                    return String(indicatorSymbols.map({ Character($0) }))
        }
    }
}

extension Country{
    
    init(fromIsoCountryCode code: String){
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        self.name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        self.isoCountryCode = code
    }
}

//
//  Utilities.swift
//  uniTrack
//
//  Created by Luca Sfragara on 20/12/20.
//

import Foundation
import UIKit

class Utilities{
    
    static func createAlertView(title: String, message: String?, button1Title: String = "No", button2title: String? = "yes", completion: @escaping()->())->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: button1Title, style: .cancel, handler: nil)
    
        if let doneButtonTitle = button2title{
            let doneAction = UIAlertAction(title: doneButtonTitle, style: .default){action in
                completion()
            }
            alert.addAction(doneAction)
        }
        
        alert.addAction(cancelAction)
        
        
        return alert
    }
    
    static func countryList() -> [Country]{
        
        var countries: [Country] = []
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(Country(name: name, isoCountryCode: code))
        }
        return countries
    }
    
    static func pingURL(string: String, completion: @escaping(Result<Int, LinkError>)->()){
        guard let URL = URL(string: string) else{
            completion(.failure(.cannotConvertString))
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 7
        URLSession(configuration: .default).dataTask(with: request){ (_, response, error) -> Void in
            
            guard error == nil else{

                if let error = error as? NSError, error.code == NSURLErrorTimedOut{
                    completion(.failure(.timeOutError))
                }
                completion(.failure(.generalError))
                return
                
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else{
                completion(.failure(.cannotReachHost))
                return
            }
            
            completion(.success(200))
        }.resume()
    }
    
}

enum LinkError: LocalizedError{
    case cannotConvertString
    case generalError
    case cannotReachHost
    case timeOutError
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

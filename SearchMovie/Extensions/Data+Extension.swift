//
//  Data+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import Foundation

extension Data {
    func dictionaryValue(options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
        guard let dictionaryValue = ((try? JSONSerialization.jsonObject(with: self, options: options) as? [String: Any]) as [String : Any]??) else {
            return nil
        }
        return dictionaryValue
    }
}

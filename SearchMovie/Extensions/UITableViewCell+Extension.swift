//
//  UITableViewCell+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

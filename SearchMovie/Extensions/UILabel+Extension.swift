//
//  UILabel+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import UIKit

extension UILabel {
    func addShadowToText(offset: CGSize = CGSize(width: 1, height: 2), opacity: Float = 0.90, color: UIColor = .black, radius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

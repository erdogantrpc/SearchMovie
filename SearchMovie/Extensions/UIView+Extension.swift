//
//  UIView+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import UIKit

extension UIView {
    func addBlurredBackground(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
    }
}

//
//  BaseViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: AppConstants.searchAnimation)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = true
        animationView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 150),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func toggleAnimation(showAnimation: Bool, view: UIView? = nil) {
        view?.isHidden = showAnimation
        self.view.bringSubviewToFront(animationView)
        animationView.isHidden = !showAnimation
        showAnimation ? animationView.play() : animationView.stop()
    }
}

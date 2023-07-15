//
//  UIViewController+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import UIKit

extension UIViewController {
    
    func setRootNavigationController(_ viewController: UIViewController) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let navController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
}

//
//  UIViewController+Extension.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import UIKit

extension UIViewController {
    
    func setupHideKeyboardGestureWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let navBarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        navBarTapGestureRecognizer.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setRootNavigationController(_ viewController: UIViewController) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let navController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .default) { _ in
                handler?()
            }
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
}

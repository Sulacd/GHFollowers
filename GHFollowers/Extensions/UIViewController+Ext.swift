//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Christian Diaz on 6/29/22.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
            
            if self is FollowerListVC {
                alertVC.containerView.actionButton.addTarget(self, action: #selector(self.popVC), for: .touchUpInside)
            }
        }
    }
    
    @objc private func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

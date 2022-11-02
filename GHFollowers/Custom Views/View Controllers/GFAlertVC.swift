//
//  GFAlertVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 6/29/22.
//
//  A custom reusable view controller presented when there are errors

import UIKit

class GFAlertVC: UIViewController {
    
    let containerView = GFContainerView()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
    }

    
    func configureContainerView() {
        view.addSubview(containerView)
        // Set custom text for our Alert Container
        containerView.titleLabel.text = alertTitle ?? "Something went wrong"
        containerView.actionButton.set(color: .systemPink, title: "Ok", systemImageName: "checkmark.circle")
        containerView.actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        containerView.messageLabel.text = message ?? "Unable to complete request"
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

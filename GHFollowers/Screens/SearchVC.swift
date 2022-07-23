//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 6/27/22.
//


import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let calltoActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubViews(logoImageView, usernameTextField, calltoActionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        // Shows the nav bar whenever the search view is displayed
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    // Function that is called whenever user hits return key if they input username, or the GFButton
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            // Presents the Alert VC when no username is entered
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 🙈", buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(username: usernameTextField.text!)
        // FollowersListVC's username property will never be nil when it is segued
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
// MARK: - UI Configurations and Placements
    
    func configureLogoImageView() {
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
    
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {

        calltoActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            calltoActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            calltoActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            calltoActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            calltoActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Delegate Extensions

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

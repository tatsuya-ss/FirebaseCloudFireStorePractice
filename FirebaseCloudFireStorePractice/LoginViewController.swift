//
//  LoginViewController.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var mainAddressTextField: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func loginButtonDidTap(_ sender: Any) {
        guard let email = mainAddressTextField.text,
              let password = passWordTextField.text else { return }
        FirebaseUtil().logIn(email: email, password: password) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success():
                let testVC = CloudFireStoreTestViewController.instantiate()
                testVC.modalPresentationStyle = .fullScreen
                self?.present(testVC, animated: true, completion: nil)
            }
        }
    }
    
}

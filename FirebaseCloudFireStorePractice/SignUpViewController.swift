//
//  SignUpViewController.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet private weak var mailAddressTextField: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func signUpButtonDidTap(_ sender: Any) {
        guard let mail = mailAddressTextField.text,
              let password = passWordTextField.text else { return }
        FirebaseUtil().signUp(email: mail,
                              password: password) { [weak self] result in
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

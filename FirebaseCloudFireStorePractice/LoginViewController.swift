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
        Task {
            do {
                try await FirebaseUtil().logInAsync(email: email, password: password)
                // MARK: - awaitを使ってるので処理が一時停止（サスペンションポイント）
                await MainActor.run {
                    let testVC = CloudFireStoreTestViewController.instantiate()
                    testVC.modalPresentationStyle = .fullScreen
                    self.present(testVC, animated: true, completion: nil)
                }
            } catch {
                print(error)
            }
        }
    }
    
}

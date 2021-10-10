//
//  CloudFireStoreTestViewController.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import UIKit

final class CloudFireStoreTestViewController: UIViewController {

    @IBOutlet private weak var postTextField: UITextField!
    @IBOutlet private weak var postIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func postButtonDidTap(_ sender: Any) {
        guard let post = postTextField.text,
              let postId = postIdTextField.text else { return }
        FirebaseUtil().save(post: post, postId: postId)
    }
    @IBAction private func postDocumentIdButtonDidTap(_ sender: Any) {
        guard let post = postTextField.text else { return }
        FirebaseUtil().saveDocument(post: post)
    }
}

extension CloudFireStoreTestViewController {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return vc
    }
    
}

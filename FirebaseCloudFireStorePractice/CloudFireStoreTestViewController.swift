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
    
    @IBAction private func postDocumentIdButtonDidTap(_ sender: Any) {
        guard let post = postTextField.text else { return }
        let firebaseUtil = FirebaseUtil()
        let postId = UUID().uuidString
        firebaseUtil.save(post: post, postId: postId)
        
        let image = UIImage(named: "pasta")
        guard let data = image?.pngData() else { return }
        firebaseUtil.saveStorage(postId: postId, data: data) { result in
            switch result {
            case .success(.resume):
                print("resume")
            case .success(.pause):
                print("pause")
            case .success(.progress(let percent)):
                print(String(percent))
            case .success(.success):
                print("写真の保存できました。")
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CloudFireStoreTestViewController {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return vc
    }
    
}

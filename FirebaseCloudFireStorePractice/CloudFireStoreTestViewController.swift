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
    @IBOutlet private weak var fetchImage: UIImageView!
    @IBOutlet private weak var baforeImage: UIImageView!
    
    let postId = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baforeImage.image = UIImage(named: "pasta")
    }
    
    @IBAction private func postDocumentIdButtonDidTap(_ sender: Any) {
        guard let post = postTextField.text,
              // 0.1でも0.01でも45.05kbから下がらない
              let data = UIImage(named: "pasta")?.jpegData(compressionQuality: 0.1) else { return }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        FirebaseUtil().save(post: post, postId: postId) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success:
                print("保存完了")
            case .failure(let error):
                print(error)
            }
        }
        FirebaseUtil().saveStorage(postId: postId, data: data) { result in
            switch result {
            case .success(.resume):
                print("resume")
            case .success(.pause):
                print("pause")
            case .success(.progress(let percent)):
                print(String(percent))
            case .success(.success):
                print("写真の保存できました。")
                dispatchGroup.leave()
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("全ての保存完了")
        }
    }
    
    @IBAction private func fetchButtonDidTapped(_ sender: Any) {
        FirebaseUtil().fetchLocal(id: postId) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let url):
                // 1.3mbから45.05kbで取得できた。
                guard let fileContents = try? Data(contentsOf: url) else { fatalError() }
                self.fetchImage.image = UIImage(data: fileContents)
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

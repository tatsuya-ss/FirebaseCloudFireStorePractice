//
//  CloudFireStoreTestViewController.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import UIKit

final class CloudFireStoreTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension CloudFireStoreTestViewController {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return vc
    }
    
}

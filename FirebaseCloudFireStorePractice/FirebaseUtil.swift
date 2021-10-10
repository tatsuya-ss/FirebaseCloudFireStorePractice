//
//  FirebaseUtil.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import Foundation
import Firebase

final class FirebaseUtil {
    
    func signUp(email: String,
                password: String,
                completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func logIn(email: String,
               password: String,
               completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
        
    }
    
    func save(post: String, postId: String) {
        guard let user = Auth.auth().currentUser else { return }
        let storeRef = Firestore.firestore().collection("users/\(user.uid)/posts/")
        let createdTime = FieldValue.serverTimestamp()
        let postData: [String: Any] = ["id": postId,
                                       "post": post,
                                       "createdAt": createdTime]
        storeRef.addDocument(data: postData) { error in
            if let error = error {
                print(error)
            } else {
                print("保存できました。")
            }
        }
    }
    
    func saveDocument(post: String) {
        guard let user = Auth.auth().currentUser else { return }
        let postId = UUID().uuidString
        let storeRef = Firestore.firestore().document("users/\(user.uid)/posts/\(postId)")
        let createdTime = FieldValue.serverTimestamp()
        let postData: [String: Any] = ["id": postId,
                                       "post": post,
                                       "createdAt": createdTime]
        storeRef.setData(postData, merge: true) { error in
            if let error = error {
                print(error)
            } else {
                print("保存できました。")
            }
        }
    }
    
}

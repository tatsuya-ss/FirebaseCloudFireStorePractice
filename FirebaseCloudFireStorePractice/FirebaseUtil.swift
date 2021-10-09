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
    
}

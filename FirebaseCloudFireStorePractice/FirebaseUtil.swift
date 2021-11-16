//
//  FirebaseUtil.swift
//  FirebaseCloudFireStorePractice
//
//  Created by 坂本龍哉 on 2021/10/09.
//

import Foundation
import Firebase
import FirebaseStorage

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
    
    func logInAsync(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
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
    
    func save(post: String, postId: String,
              completion: @escaping (Result<Any?, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let storeRef = Firestore.firestore().collection("users/\(user.uid)/posts/")
        let createdTime = FieldValue.serverTimestamp()
        let postData: [String: Any] = ["id": postId,
                                       "post": post,
                                       "createdAt": createdTime]
        storeRef.addDocument(data: postData) { error in
            if let error = error {
                completion(.failure(error))
                print(error)
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func saveStorage(postId: String,
                     data: Data,
                     completion: @escaping (Result<StorageStatus, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let photosRef = Storage.storage().reference().child("users/\(user.uid)/posts/\(postId).jpg")
        let uploadTask = photosRef.putData(data,
                                           metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                completion(.failure(error!))
                return
            }
            let size = metadata.size
            photosRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                print(downloadURL)
            }
            print(size)
        }
        uploadTask.observe(.resume) { snapshot in
            completion(.success(.resume))
        }
        uploadTask.observe(.pause) { snapshot in
            completion(.success(.pause))
        }
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            completion(.success(.progress(percentComplete)))
        }
        uploadTask.observe(.success) { snapshot in
            completion(.success(.success))
            uploadTask.removeAllObservers()
        }
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                completion(.failure(error))
                uploadTask.removeAllObservers()
            }
        }
    }
    
    func fetchLocal(id: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let photosRef = Storage.storage().reference().child("users/\(user.uid)/posts/\(id).jpg")
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                       .userDomainMask,
                                                       true)[0]
        let photoName = "\(id).jpg"
        let cachesURL = URL(fileURLWithPath: "\(path)/\(photoName)")
        print(cachesURL)
        // file:///var/mobile/Containers/Data/Application/DC6ED900-D31C-48AC-A18D-D372A41DE7A5/Library/Caches/F0F30DC2-0770-487C-9539-BD3F075F9E73.jpg

        let downloadTask = photosRef.write(toFile: cachesURL) { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(cachesURL))
            }
        }
        downloadTask.resume()
    }
    
}

enum StorageStatus {
    case resume
    case pause
    case progress(Double)
    case success
}

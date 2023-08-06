//
//  Image.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-06.
//

import Foundation
import UIKit
import FirebaseStorage

struct Image {
    
    // Upload one image
    static func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images").child(UUID().uuidString + ".jpg")

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    storageRef.downloadURL { url, error in
                        if let url = url {
                            completion(.success(url))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    // Upload a set of images
    static func uploadImagesToFirebaseStorage(images: Set<UIImage>, completion: @escaping (Result<Set<URL>, Error>) -> Void) {
        let storage = Storage.storage()
        var uploadedURLs: Set<URL> = []

        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()

            let storageRef = storage.reference().child("images").child(UUID().uuidString + ".jpg")

            if let imageData = image.jpegData(compressionQuality: 1.0) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        storageRef.downloadURL { url, error in
                            if let url = url {
                                uploadedURLs.insert(url)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            } else {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(uploadedURLs))
        }
    }
    
    // Load image from URL
    static func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

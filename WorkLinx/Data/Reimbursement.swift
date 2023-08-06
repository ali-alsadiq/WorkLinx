//
//  Reimbursement.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-06.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Reimbursement: Codable {
    var workSpaceId: String
    var userId: String
    var requestDate: Date
    var imagesUrls:  Set<URL>
    var amount: Double
    var description: String
    var isApproved: Bool
    
    enum CodingKeys: String, CodingKey {
        case workSpaceId
        case userId
        case requestDate
        case imagesUrls
        case amount
        case description
        case isApproved
    }
    
    func createReimbursement(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let reimbursementDocumentData = try Utils.encodeData(data: self)
            
            // Declare newDocumentRef as an optional variable outside the closure
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("reimbursement").addDocument(data: reimbursementDocumentData!) { error in
                if let error = error {
                    // Error occurred while adding the reimbursement
                    completion(.failure(error))
                } else {
                    // Reimbursement added successfully, get the ID and return it
                    if let documentID = newDocumentRef?.documentID {
                        completion(.success(documentID))
                    } else {
                        completion(.failure(NSError(domain: "ReimbursemetCreationError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding Reimbursement data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
}

//
//  TimeOff.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore

struct TimeOff: Codable {
    var workSpaceId: String
    var userId: String
    var startTime: Date
    var endTime: Date
    var isApproved: Bool
    
    enum CodingKeys: String, CodingKey {
        case workSpaceId
        case userId
        case startTime
        case endTime
        case isApproved
    }
    
    func createTimeOff(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let timeOffDocumentData = try Utils.encodeData(data: self)
            
            // Declare newDocumentRef as an optional variable outside the closure
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("timeOff").addDocument(data: timeOffDocumentData!) { error in
                if let error = error {
                    // Error occurred while adding the time off
                    completion(.failure(error))
                } else {
                    // Time Off added successfully, get the ID and return it
                    if let documentID = newDocumentRef?.documentID {
                        completion(.success(documentID))
                    } else {
                        completion(.failure(NSError(domain: "TimeOffCreationError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding TimeOff data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
}

//
//  Shift.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Shift: Codable {
    var employeeIds: [String]
    var workspaceId: String
    var date: Date
    var startTime: Date
    var endTime: Date
    //    var address: String
    
    
    enum CodingKeys: String, CodingKey {
        case employeeIds
        case workspaceId
        case date
        case startTime
        case endTime
        //        case address
    }
    
    // Create shift
    static func createShift(shift: Shift, completion: @escaping (Result<String, Error>) -> Void) {
        do{
            
            let shiftDocumentData = try Utils.encodeData(data: shift)
            
            // Declare newDocumentRef as an optional variable outside the closure
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("shifts").addDocument(data: shiftDocumentData!) { error in
                if let error = error {
                    // Error occurred while adding the workspace
                    completion(.failure(error))
                } else {
                    // Shift created successfully, get the ID and return it
                    if let documentID = newDocumentRef?.documentID {
                        completion(.success(documentID))
                    } else {
                        completion(.failure(NSError(domain: "ShiftCreationError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding shift data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}


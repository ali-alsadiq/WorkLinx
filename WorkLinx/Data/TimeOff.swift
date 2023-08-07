//
//  TimeOff.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore

struct TimeOff: Codable, Identifiable {
    var id = ""
    var workSpaceId: String
    var userId: String
    var startTime: Date
    var endTime: Date
    var isApproved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
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
                    // Time Off added successfully, get the ID and update the document
                    if let documentID = newDocumentRef?.documentID {
                        var updatedData = timeOffDocumentData ?? [:] // Make sure to replace this with your actual data
                        
                        // Set the id field to the document ID
                        updatedData["id"] = documentID
                        
                        newDocumentRef?.updateData(updatedData) { updateError in
                            if let updateError = updateError {
                                completion(.failure(updateError))
                            } else {
                                completion(.success(documentID))
                            }
                        }
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
    
    // Function to fetch an array of TimeOff by IDs from Firestore
    static func fetchtimeOffsByIDs(timeOffIDs: [String], completion: @escaping ([TimeOff]) -> Void) {
        let query = Utils.db.collection("timeOff").whereField(FieldPath.documentID(), in: timeOffIDs)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Time Off: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            
            var timeOffs: [TimeOff] = []
            
            for document in documents {
                let data = document.data()
                
                do {
                    // Use JSONSerialization to convert the Firestore document data to JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Use JSONDecoder to decode the JSON data into a User object
                    let decoder = JSONDecoder()
                    let timeOff = try decoder.decode(TimeOff.self, from: jsonData)
                    
                    timeOffs.append(timeOff)
                } catch {
                    print("Error decoding Time Off: \(error.localizedDescription)")
                }
            }
            
            completion(timeOffs)
        }
    }
}

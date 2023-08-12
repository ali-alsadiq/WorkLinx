//
//  Reimbursement.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-06.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Reimbursement: Codable, Identifiable {
    var id = UUID()
    var workSpaceId: String
    var userId: String
    var requestDate: Date
    var imagesUrls:  Set<URL>
    var amount: Double
    var description: String
    var isApproved: Bool
    var isModifiedByAdmin: Bool
    
    var status: String {
        !isApproved && !isModifiedByAdmin ? "Pending" : !isApproved ? "Rejected" : "Accepted"
    }
    
    enum CodingKeys: String, CodingKey {
        case workSpaceId
        case userId
        case requestDate
        case imagesUrls
        case amount
        case description
        case isApproved
        case isModifiedByAdmin
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
                    // Reimbursement added successfully, get the ID and update the document
                    if let documentID = newDocumentRef?.documentID {
                        var updatedData = reimbursementDocumentData ?? [:] // Make sure to replace this with your actual data
                        
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
                        completion(.failure(NSError(domain: "ReimbursementCreationError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding Reimbursement data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // Function to fetch an array of Reimbursemet by IDs from Firestore
    static func fetchReimbursementsByIDs(reimbursementOffIDs: [String], completion: @escaping ([Reimbursement]) -> Void) {
        let query = Utils.db.collection("reimbursement").whereField(FieldPath.documentID(), in: reimbursementOffIDs)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Reimbursement: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            
            var reimbursements: [Reimbursement] = []
            
            for document in documents {
                let data = document.data()
                
                do {
                    // Use JSONSerialization to convert the Firestore document data to JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Use JSONDecoder to decode the JSON data into a User object
                    let decoder = JSONDecoder()
                    let reimbursement = try decoder.decode(Reimbursement.self, from: jsonData)
                    
                    reimbursements.append(reimbursement)
                } catch {
                    print("Error decoding Reimbursement: \(error.localizedDescription)")
                }
            }
            
            completion(reimbursements)
        }
    }
}

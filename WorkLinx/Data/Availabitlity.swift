//
//  Availabitlity.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-13.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Availability: Codable {
    var id = ""
    var workSpaceId: String
    var userId: String
    var availableDays: [AvailableDay]
    
    struct AvailableDay: Codable {
        var day: String
        var startTime: Date
        var endTime: Date
        var isSet: Bool = false
        var isAvailable: Bool
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case workSpaceId
        case userId
        case availableDays
    }
    
    func createAvailabilty(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let availabiltyDocumentData = try Utils.encodeData(data: self)
            
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("availabilty").addDocument(data: availabiltyDocumentData!) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let documentID = newDocumentRef?.documentID {
                        var updatedData = availabiltyDocumentData ?? [:]
                        
                        updatedData["id"] = documentID
                        
                        newDocumentRef?.updateData(updatedData) { updateError in
                            if let updateError = updateError {
                                completion(.failure(updateError))
                            } else {
                                // add to the Workspace here
                                completion(.success(documentID))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "AvailabiltyError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding Availabilty data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // Update Reimbursement
    func setAvailabiltyData(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let availabiltyDocumentData = try Utils.encodeData(data: self)!
            
            Utils.db.collection("availabilty").document(id).setData(availabiltyDocumentData) { error in
                if let error = error {
                    print("Error updating availabilty data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    completion(.success(())) // pass something or something??
                }
            }
        } catch {
            print("Error encoding availabilty data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // Function to fetch a user by ID from Firestore
    static func getAvailabiltyByID(availabiltyID: String, completion: @escaping (Availability?) -> Void) {
        let query =  Utils.db.collection("availabilty").whereField("id", isEqualTo: availabiltyID)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching availabilty: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(nil)
                return
            }
            
            if let document = documents.first {
                let data = document.data()
                
                do {
                    // Use JSONSerialization to convert the Firestore document data to JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Use JSONDecoder to decode the JSON data into a User object
                    let decoder = JSONDecoder()
                    let availabilty = try decoder.decode(Availability.self, from: jsonData)
                    
                    completion(availabilty)
                } catch {
                    print("Error decoding avaialbilty: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    static func fetchAvailabilitesByIDs(availabilityIDs: [String], completion: @escaping ([Availability]) -> Void) {
        let query = Utils.db.collection("availabilty").whereField(FieldPath.documentID(), in: availabilityIDs)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Availability: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            
            var availabilities: [Availability] = []
            
            for document in documents {
                let data = document.data()
                
                do {
                    // Use JSONSerialization to convert the Firestore document data to JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Use JSONDecoder to decode the JSON data into a User object
                    let decoder = JSONDecoder()
                    let availabilty = try decoder.decode(Availability.self, from: jsonData)
                    
                    availabilities.append(availabilty)
                } catch {
                    print("Error decoding Availabilty: \(error.localizedDescription)")
                }
            }
            
            completion(availabilities)
        }
    }
}

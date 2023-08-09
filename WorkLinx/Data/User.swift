//
//  User.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore
import GoogleSignIn


struct User : Codable, Equatable, Hashable {
    var id: String // Add a property to store the user ID from Firestore
    var emailAddress: String
    var firstName = ""
    var lastName = ""
    var address = ""
    var workSpaces: [String] = []
    var defaultWorkspaceId: String
    var availabilityIds: [String] = []
    var timeOffRequestIds: [String] = []
    var shiftIds: [String] = []
    var reimbursementRequestIds: [String] = []
    
    // CodingKeys to specify custom mappings for Codable properties
    enum CodingKeys: String, CodingKey {
        case id
        case emailAddress
        case firstName
        case lastName
        case address
        case workSpaces
        case defaultWorkspaceId
        case availabilityIds
        case timeOffRequestIds
        case shiftIds
    }
    
    // Equatable conformance: Compare users by their ID
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Inequality operator, utilizing the `==` operator
    static func != (lhs: User, rhs: User) -> Bool {
        return !(lhs == rhs)
    }
    
    init(id: String, emailAddress: String, defaultWorkspaceId: String) {
        self.id = id
        self.emailAddress = emailAddress
        self.defaultWorkspaceId = defaultWorkspaceId
    }
    
    // Function to create a new user in Firebase Authentication
    func createUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Error occurred while creating the user
                completion(.failure(error))
            } else if let authResult = authResult {
                // User successfully created
                completion(.success(authResult))
            }
        }
    }
    
    // Function to update user data in the "usersData" collection in Firestore
    func setUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Update the document with the existing user ID
        do {
            let userDocumentData = try Utils.encodeData(data: self)
            
            Utils.db.collection("usersData").document(id).setData(userDocumentData!) { error in
                if let error = error {
                    // Print the specific error details for debugging
                    print("Error updating user data: \(error.localizedDescription)")
                    completion(.failure(error)) // Call the completion handler with the error
                } else {
                    print("User data updated successfully.")
                    Utils.workSpaceUsers.append(self)
                    completion(.success(())) // Call the completion handler with success (empty tuple)
                }
            }
        }
        catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
    
    
    // Function to fetch a user by ID from Firestore
    static func fetchUserByID(userID: String, completion: @escaping (User?) -> Void) {
        let query =  Utils.db.collection("usersData").whereField("id", isEqualTo: userID)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
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
                    let user = try decoder.decode(User.self, from: jsonData)
                    
                    completion(user)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    // Function to fetch an array of users by IDs from Firestore
    static func fetchUsersByIDs(userIDs: [String], completion: @escaping ([User]) -> Void) {
        let query = Utils.db.collection("usersData").whereField("id", in: userIDs)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            
            var users: [User] = []
            
            for document in documents {
                let data = document.data()
                
                do {
                    // Use JSONSerialization to convert the Firestore document data to JSON data
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Use JSONDecoder to decode the JSON data into a User object
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: jsonData)
                    
                    users.append(user)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                }
            }
            
            completion(users)
        }
    }
}

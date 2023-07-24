//
//  User.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore


struct User : Codable {
    var id: String // Add a property to store the user ID from Firestore
    var emailAddress: String
    var firstName = ""
    var lastName = ""
    var workSpacesAndPayRate: [WorkSpacePayRate] = []
    var defaultWorkspaceId: String
    var position = ""
    var availabilityIds: [String] = []
    var timeOffRequestIds: [String] = []
    var shiftIds: [String] = []
    
    struct WorkSpacePayRate: Codable {
        var workspaceId: String
        var payRate: Int
    }
        
    // CodingKeys to specify custom mappings for Codable properties
    enum CodingKeys: String, CodingKey {
        case id
        case emailAddress
        case firstName
        case lastName
        case workSpacesAndPayRate
        case defaultWorkspaceId
        case position
        case availabilityIds
        case timeOffRequestIds
        case shiftIds
    }
    
    init(id: String, emailAddress: String, defaultWorkspaceId: String) {
        self.id = id
        self.emailAddress = emailAddress
        self.defaultWorkspaceId = defaultWorkspaceId
    }
    
    var description: String {
        return "User ID: \(id), Email: \(emailAddress), Default Workspace ID: \(defaultWorkspaceId), First Name: \(firstName), Last Name: \(lastName), Position: \(position)"
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
                    completion(.success(())) // Call the completion handler with success (empty tuple)
                }
            }
        }
        catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
}

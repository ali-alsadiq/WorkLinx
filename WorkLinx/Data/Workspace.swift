//
//  Workspace.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-15.
//

import Foundation
import Firebase
import FirebaseFirestore

class Workspace: Codable {
    static let workspacesCollection = Firestore.firestore().collection("workspaces")
    
    var workspaceId: String // Add a property to store the workspace ID from Firestore
    var name: String
    var address: String
    var admins: [String] = []
    var employees: [Employee] = []
    var shiftIds: [String] = []
    var openShiftsIds: [String] = []
    var timeOffRequestIds: [String] = []
    var reimbursementRequestIds: [String] = []
    var positions: Positions = Positions(admins: [], employees: [])
    var invitedUsers: [String] = []
    
    struct Positions: Codable {
        var admins: [String]
        var employees: [String]
    }
    
    struct Employee: Codable {
        var employeeId: String
        var payrate: Double
        var position: String
    }
    
    enum CodingKeys: String, CodingKey {
        case workspaceId
        case name
        case address
        case admins
        case employees
        case shiftIds
        case openShiftsIds
        case timeOffRequestIds
        case reimbursementRequestIds
        case positions
        case invitedUsers
    }
    
    
    init(workspaceId: String, name: String, address: String, admins: [String], employees: [Employee]) {
        self.workspaceId = workspaceId
        self.name = name
        self.address = address
        self.admins = admins
        self.employees = employees
    }
    
    // Function to create a new workspace in Firestore
    static func createWorkspace(workspace: Workspace, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            // Encode the provided workspace object
            let workspaceDocumentData = try Utils.encodeData(data: workspace)
            
            // Declare newDocumentRef as an optional variable outside the closure
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("workspaces").addDocument(data: workspaceDocumentData!) { error in
                if let error = error {
                    // Error occurred while adding the workspace
                    completion(.failure(error))
                } else {
                    // Workspace added successfully, get the ID and return it
                    if let documentID = newDocumentRef?.documentID {
                        // Update the workspace object with the document ID
                        let updatedWorkspace = workspace
                        updatedWorkspace.workspaceId = documentID
                        
                        // Update the workspace in Firestore with the new workspaceId
                        updateWorkspace(workspace: updatedWorkspace) { _ in
                            // Call the completion handler with updated workspace
                            completion(.success(documentID))
                        }
                        
               
                    } else {
                        completion(.failure(NSError(domain: "WorkspaceCreationError", code: 0, userInfo: nil)))
                    }
                }
            }
        } catch {
            print("Error encoding workspace data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // Update workspace Data
    static func updateWorkspace(workspace: Workspace, completion: @escaping (Error?) -> Void) {
        do {
            // Encode the workspace instance to JSON data using the provided encodeData function
            guard let workspaceData = try Utils.encodeData(data: workspace) else {
                print("Error encoding Workspace data.")
                completion(NSError(domain: "WorkspaceUpdateError", code: 0, userInfo: nil))
                return
            }
            
            // Update the Firestore document with the new data
            Workspace.workspacesCollection.document(workspace.workspaceId).setData(workspaceData, merge: true) { error in
                if let error = error {
                    print("Error updating workspace: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Workspace updated successfully")
                    completion(nil)
                }
            }
        } catch {
            print("Error encoding workspace data: \(error.localizedDescription)")
            completion(error)
        }
    }
    
    // Get workspace by id
    static func getWorkspaceByID(workspaceID: String, completion: @escaping (Workspace?) -> Void) {
        guard !workspaceID.isEmpty else {
            // The workspaceID is empty, call the completion handler with nil
            completion(nil)
            return
        }
        
        workspacesCollection.document(workspaceID).getDocument { snapshot, error in
            if let error = error {
                // Handle the error
                print("Error fetching workspace: \(error)")
                completion(nil)
                return
            }
            
            guard let document = snapshot, document.exists else {
                // Workspace with the given ID does not exist, call the completion handler with nil
                completion(nil)
                return
            }
            
            guard let document = snapshot, document.exists, let data = document.data() else {
                // Workspace with the given ID does not exist or has no data, call the completion handler with nil
                completion(nil)
                return
            }
            
            do {
                // Convert the [String: Any] data to Data
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                
                // Decode the data into a Workspace object using JSONDecoder
                let workspace = try JSONDecoder().decode(Workspace.self, from: jsonData)
                completion(workspace)
            } catch {
                // Error occurred while decoding the data
                print("Error decoding workspace data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    static func updateInvitingWorkspaces(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("workspaces").whereField("invitedUsers", arrayContains: Utils.user.emailAddress).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion()
            } else {
                if let documents = querySnapshot?.documents {
                    Utils.invitingWorkspaces = documents.compactMap { document in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                            let workspace = try JSONDecoder().decode(Workspace.self, from: jsonData)
                            return workspace
                        } catch {
                            print("Error decoding workspace data: \(error)")
                            return nil
                        }
                    }
                } else {
                    // No documents found
                    Utils.invitingWorkspaces = []
                }
                
                completion()
            }
        }
    }
}

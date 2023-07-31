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
    var employees: [String] = []
    var openShiftsIds: [String] = []
    var positions: Positions = Positions(admins: [], employees: [])
    
    struct Positions: Codable {
        var admins: [String]
        var employees: [String]
    }
    
    enum CodingKeys: String, CodingKey {
        case workspaceId
        case name
        case address
        case admins
        case employees
        case openShiftsIds
        case positions
    }
    
    
    init(workspaceId: String, name: String, address: String, admins: [String], employees: [String]) {
        self.workspaceId = workspaceId
        self.name = name
        self.address = address
        self.admins = admins
        self.employees = employees
    }
    
    var description: String {
        return "Workspace ID: \(workspaceId), Name: \(name), Address: \(address), Admins: \(admins), Employees: \(employees)"
    }
    
    // Function to create a new workspace in Firestore
    static func createWorkspace(name: String, address: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            Utils.workspace = Workspace(workspaceId: "", name: name , address: address, admins: [], employees: [])
            
            let workspaceDocumentData = try Utils.encodeData(data: Utils.workspace)
            
            // Declare newDocumentRef as an optional variable outside the closure
            var newDocumentRef: DocumentReference?
            
            newDocumentRef = Utils.db.collection("workspaces").addDocument(data: workspaceDocumentData!) { error in
                if let error = error {
                    // Error occurred while adding the workspace
                    completion(.failure(error))
                } else {
                    // Workspace added successfully, get the ID and return it
                    if let documentID = newDocumentRef?.documentID {
                        Utils.workspace.workspaceId = documentID
                        completion(.success(documentID))
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
    
    // Function to add initial admin and employee to the workspace
    func addInitialAdminAndEmployee(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        admins.append(userId)
        employees.append(userId)
        
        // Update the employees and admins field in Firestore
        Workspace.workspacesCollection.document(workspaceId).setData([
            "admins": admins,
            "employees": employees
        ], merge: true) { error in
            if let error = error {
                print("Error updating employees in Firestore: \(error.localizedDescription)")
                completion(.failure(error)) // Pass the error to the completion closure
            } else {
                print("Employees updated in Firestore")
                completion(.success(())) // Call the completion handler with success (empty tuple)
            }
        }
    }
    
    
    // Function to add an employee to the workspace
    func addEmployee(userId: String, completion: @escaping (Error?) -> Void) {
        employees.append(userId)
        
        // Update the employees field in Firestore
        Workspace.workspacesCollection.document(workspaceId).setData([
            "employees": employees
        ], merge: true) { error in
            if let error = error {
                print("Error updating employees in Firestore: \(error.localizedDescription)")
                completion(error) // Pass the error to the completion closure
            } else {
                print("Employees updated in Firestore")
                completion(nil) // Pass nil to the completion closure to indicate success
            }
        }
    }
    
    // Function to add an admin to the workspace
    func addAdmin(userId: String, completion: @escaping (Error?) -> Void) {
        admins.append(userId)
        
        // Update the admins field in Firestore
        Workspace.workspacesCollection.document(workspaceId).setData([
            "admins": admins
        ], merge: true) { error in
            if let error = error {
                print("Error updating admins in Firestore: \(error.localizedDescription)")
                completion(error) // Pass the error to the completion closure
            } else {
                print("Admins updated in Firestore")
                completion(nil) // Pass nil to the completion closure to indicate success
            }
        }
    }
}

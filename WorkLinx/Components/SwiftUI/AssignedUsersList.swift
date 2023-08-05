//
//  AssignedUsersList.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-04.
//

import SwiftUI

struct AssignedUserList: View {
    @ObservedObject var userManger: UsereManager
    let onRemove: (User) -> Void
    
    var body: some View {
        List(userManger.assignedUsers, id: \.id) { user in
            HStack(spacing: 20) { // Add spacing between elements
                Text(user.firstName + " " + user.lastName)
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .onTapGesture {
                            onRemove(user)
                        }
                }
            }
        }.frame(height: 350)
    }
}

class UsereManager: ObservableObject {
    @Published var assignedUsers: [User]
    
    init(assignedUsers: [User]) {
        self.assignedUsers = assignedUsers
    }
    
    func removeUser(_ user: User) {
        assignedUsers.removeAll { $0.id == user.id }
    }
    
    func addUSer(_ user: User) {
        assignedUsers.append(user)
    }
}


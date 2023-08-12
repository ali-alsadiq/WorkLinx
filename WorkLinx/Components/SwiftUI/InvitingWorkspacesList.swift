//
//  InvitingWorkspacesList.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import SwiftUI

class WorkspaceManager: ObservableObject {
    @Published var invitingWorkspaces: [Workspace] = Utils.invitingWorkspaces

    func removeWorkspace(_ workspace: Workspace) {
        invitingWorkspaces.removeAll { $0.workspaceId == workspace.workspaceId }
        Utils.invitingWorkspaces.removeAll { $0.workspaceId == workspace.workspaceId }
    }
}

struct InvitingWorkspacesList: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    let onAccept: (Workspace) -> Void
    let onReject: (Workspace) -> Void
    
    private var workspaceBinding: Binding<[Workspace]> {
        Binding<[Workspace]>(
            get: { self.workspaceManager.invitingWorkspaces },
            set: { self.workspaceManager.invitingWorkspaces = $0 }
        )
    }
    
    var body: some View {
        List(workspaceBinding, id: \.workspaceId) { workspace in
            HStack(spacing: 20) { // Add spacing between elements
                Text(workspace.name.wrappedValue)
                Spacer()
                
                // Xcode suddenly broke on image
                
                Button(action: { onAccept(workspace.wrappedValue)} ) {
                    Text("Accept")
                        .foregroundColor(Color(Utils.darkGreen))
                }
                Button(action: { onReject(workspace.wrappedValue) }) {
                    Text("Reject")
                        .foregroundColor(Color(Utils.darkRed))
                }
            }
        }
    }
}

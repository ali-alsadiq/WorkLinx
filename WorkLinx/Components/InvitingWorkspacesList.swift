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
    
    var body: some View {
        List(workspaceManager.invitingWorkspaces, id: \.workspaceId) { workspace in
            HStack(spacing: 20) { // Add spacing between elements
                Text(workspace.name)
                Spacer()
                Button(action: {}) { // Use an empty action for the Text to prevent tapping outside the image
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.green)
                        .onTapGesture {
                            onAccept(workspace)
                        }
                }
                Button(action: {}) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .onTapGesture {
                            onReject(workspace)
                        }
                }
            }
        }
    }
}

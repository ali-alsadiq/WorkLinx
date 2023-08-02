//
//  InvitingWorkspacesList.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import SwiftUI

struct InvitingWorkspacesList: View {
    let workspaces: [Workspace]
    let onAccept: (Workspace) -> Void
    let onReject: (Workspace) -> Void
    
    var body: some View {
        List(workspaces, id: \.workspaceId) { workspace in
            HStack {
                Text(workspace.name)
                Spacer()
                Button(action: {
                    onAccept(workspace)
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green) // Change color here
                }
                Button(action: {
                    onReject(workspace)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red) // Change color here
                }
            }
        }
    }
}

//
//  EmailListView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-02.
//

import SwiftUI
import Foundation
import Combine

class EmailListManager: ObservableObject {
    @Published var emails: [String] = []
    
    func addEmail(_ email: String) {
        emails.append(email)
    }
    
    func removeEmail(_ email: String) {
        if let index = emails.firstIndex(of: email) {
            emails.remove(at: index)
        }
    }
}

struct EmailListView: View {
    @ObservedObject var emailListManager: EmailListManager
    var onEmailRemoved: () -> Void // Callback to notify when an email is removed
    @State private var emailToRemove: String?
    @State private var showAlert = false
    
    var body: some View {
        List {
            ForEach(emailListManager.emails, id: \.self) { email in
                HStack {
                    Text(email)
                    Spacer()
                    Button(action: {
                        emailToRemove = email
                        showAlert = true
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .contentShape(Rectangle())
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Remove Email"), message: Text("Are you sure you want to remove this email from the list?"),
                  primaryButton: .destructive(Text("Remove")) {
                    if let emailToRemove = emailToRemove {
                        emailListManager.removeEmail(emailToRemove)
                        onEmailRemoved() // Call the callback to notify email removal
                    }
                  }, secondaryButton: .cancel())
        }
    }
}

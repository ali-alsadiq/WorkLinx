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
}

struct EmailListView: View {
    @ObservedObject var emailListManager: EmailListManager
    
    var body: some View {
        List(emailListManager.emails, id: \.self) { email in
            Text(email)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmailListView_Previews: PreviewProvider {
    static var previews: some View {
        EmailListView(emailListManager: EmailListManager())
    }
}

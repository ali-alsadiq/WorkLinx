//
//  RequestsList.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-07.
//

import Foundation
import SwiftUI

class RequestListManger: ObservableObject {
    @Published var workspaceTimeOffs: [TimeOff] = Utils.workSpceTimeOffs
    @Published var workspaceReimbursements: [Reimbursement] = Utils.workspaceReimbursements
    @Published var tab: String = ""
    var hostingVC: RequestViewController?
   
}

struct RequestsList: View {
    @ObservedObject var requestListManger: RequestListManger
    
    private func timeOffListView() -> some View {
        let filteredTimeOffs = Utils.isAdmin ?
        requestListManger.workspaceTimeOffs :
        requestListManger.workspaceTimeOffs.filter { $0.userId == Utils.user.id }
        
        return VStack {
            Text("Time Off")
                .font(.headline)
                .padding(.top, 10)
            List {
                ForEach(filteredTimeOffs) { timeOff in
                    TimeOffRow(timeOff: timeOff, requestListManger: requestListManger)
                }
            }
        }
        .background(Color.blue.opacity(0.1))
    }
    
    private func reimbursementListView() -> some View {
        let filteredReimbursements = Utils.isAdmin ?
        requestListManger.workspaceReimbursements :
        requestListManger.workspaceReimbursements.filter { $0.userId == Utils.user.id }
        
        return VStack {
            Text("Reimbursements")
                .font(.headline)
                .padding(.top, 10)
            
            List {
                ForEach(filteredReimbursements) { reimbursement in
                    ReimbursementRow(reimbursement: reimbursement)
                }
            }
        }
        .background(Color.blue.opacity(0.1))
    }
    
    var body: some View {
        VStack (spacing: 0) {
            
            if  (requestListManger.tab == "Time Off" || requestListManger.tab == "All Requests") &&
                    ((!Utils.isAdmin && requestListManger.workspaceTimeOffs.filter { $0.userId == Utils.user.id }.count > 0)
                     || (Utils.isAdmin && requestListManger.workspaceTimeOffs.count > 0))
            {
                timeOffListView()
            }
            
            if  (requestListManger.tab == "All Requests" || requestListManger.tab == "Reimbursement") &&
                    ((!Utils.isAdmin && requestListManger.workspaceReimbursements.filter { $0.userId == Utils.user.id }.count > 0)
                     || (Utils.isAdmin && requestListManger.workspaceReimbursements.count > 0))
            {
                reimbursementListView()
            }
        }
    }
}

struct ReimbursementRow: View {
    var reimbursement: Reimbursement
    
    var userName: String {
        let user = Utils.workSpaceUsers.first{$0.id == reimbursement.userId}
        return user!.firstName + " " + user!.lastName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Created By: \(userName)")
                .font(.system(size: 14))
            
            HStack{
                Text("Request Date: ")
                
                Text("\(Utils.formattedDateWithDayName(reimbursement.requestDate))")
                    .foregroundColor(.blue)
            }
            .font(.system(size: 12, weight: .bold))
            
            Text("Number of Images: \(reimbursement.imagesUrls.count)")
                .font(.system(size: 12, weight: .bold))

            Text("Amount: $\(String(format: "%.2f",reimbursement.amount))")
                .font(.system(size: 12, weight: .bold))

            Text("Status: \(reimbursement.isApproved ? "Approved" : "Not Approved")")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(reimbursement.isApproved ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            
            // navigate to edit view
            // pass the request manger - userName - reimbursement
            print(userName)
            print(reimbursement)
        }
    }
}

struct TimeOffRow: View {
    var timeOff: TimeOff
    var requestListManger: RequestListManger
    
    var userName: String {
        let user = Utils.workSpaceUsers.first{$0.id == timeOff.userId}
        return user!.firstName + " " + user!.lastName
    }
    
    var body: some View {
        if let user = Utils.workSpaceUsers.first(where: {$0.id == timeOff.userId}) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Requested by: \(userName)")
                    .font(.system(size: 14))
                
                Text("\(Utils.formattedDateWithDayName(timeOff.startTime)) - \(Utils.formattedDateWithDayName(timeOff.endTime))")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.blue)
                
                HStack (spacing: 3){
                    Text("Status:")
                    Text(timeOff.status)
                        .foregroundColor(timeOff.status == "Accepted" ? Color(Utils.darkGreen)
                                         : timeOff.status == "Pending" ? Color(Utils.darkOrange) : Color(Utils.darkRed))
                }
                .font(.system(size: 12, weight: .bold))
               
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .onTapGesture {
                // navigate to edit view
                // pass the request manger - userName - timeOff
                print(userName)
                print(timeOff)
                let editREquestVC = EditTimeOffViewController(user: user, timeOff: timeOff)
                Utils.navigate(editREquestVC, requestListManger.hostingVC!)
                // navigate in here 
            }
        }
    }
}

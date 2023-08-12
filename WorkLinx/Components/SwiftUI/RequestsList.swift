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
        requestListManger.workspaceTimeOffs.filter {!$0.isModifiedByAdmin} :
        requestListManger.workspaceTimeOffs.filter { $0.userId == Utils.user.id }
        
        return VStack {
            Text("Time Off")
                .font(.headline)
                .padding(.top, 10)
            List {
                ForEach(filteredTimeOffs, id: \.id) { timeOff in
                    TimeOffRow(timeOff: timeOff, requestListManger: requestListManger)
                }
            }
        }
        .background(Color.blue.opacity(0.1))
    }
    
    private func reimbursementListView() -> some View {
        
        let filteredReimbursements = Utils.isAdmin ?
        requestListManger.workspaceReimbursements.filter {!$0.isModifiedByAdmin} :
        requestListManger.workspaceReimbursements.filter { $0.userId == Utils.user.id }
        
        return VStack {
            Text("Reimbursements")
                .font(.headline)
                .padding(.top, 10)
            
            List {
                ForEach(filteredReimbursements, id: \.id) { reimbursement in
                    ReimbursementRow(reimbursement: reimbursement, requestListManger: requestListManger)
                }
            }
        }
        .background(Color.blue.opacity(0.1))
    }
    
    var body: some View {
        VStack (spacing: 0) {
            
            if  (requestListManger.tab == "Time Off" || requestListManger.tab == "All Requests") &&
                    ((!Utils.isAdmin && requestListManger.workspaceTimeOffs.filter { $0.userId == Utils.user.id }.count > 0)
                     || (Utils.isAdmin && requestListManger.workspaceTimeOffs.filter { !$0.isModifiedByAdmin }.count > 0))
            {
                timeOffListView()
            }
            
            if  (requestListManger.tab == "All Requests" || requestListManger.tab == "Reimbursement") &&
                    ((!Utils.isAdmin && requestListManger.workspaceReimbursements.filter { $0.userId == Utils.user.id }.count > 0)
                     || (Utils.isAdmin && requestListManger.workspaceReimbursements.filter { !$0.isModifiedByAdmin }.count > 0))
            {
                reimbursementListView()
            }
        }
    }
}

struct ReimbursementRow: View {
    var reimbursement: Reimbursement
    var requestListManger: RequestListManger

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

            HStack (spacing: 3){
                Text("Status:")
                Text(reimbursement.status)
                    .foregroundColor(reimbursement.status == "Accepted" ? Color(Utils.darkGreen)
                                     : reimbursement.status == "Pending" ? Color(Utils.darkOrange) : Color(Utils.darkRed))
            }
            .font(.system(size: 12, weight: .bold))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            let user = Utils.workSpaceUsers.first{$0.id == reimbursement.userId}!
            let editTimeOffRequestVC = EditReimbursementViewController(user: user, reimbursement: reimbursement, requestListManger: requestListManger)
            Utils.navigate(editTimeOffRequestVC, requestListManger.hostingVC!)
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
                let editTimeOffRequestVC = EditTimeOffViewController(user: user, timeOff: timeOff, requestListManger: requestListManger)
                Utils.navigate(editTimeOffRequestVC, requestListManger.hostingVC!)
            }
        }
    }
}

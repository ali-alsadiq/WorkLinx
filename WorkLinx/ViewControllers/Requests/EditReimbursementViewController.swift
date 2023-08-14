//
//  EditReimbursementViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-11.
//

import Foundation
import UIKit

class EditReimbursementViewController: EditRequestViewController {
    
    private var user: User
    private var reimbursement: Reimbursement
    private var requestStack: UIStackView!
    private var imagesStack: UIStackView!
    private var requestListManger: RequestListManger
    
    
    private var index: Int {
        return requestListManger.workspaceReimbursements.firstIndex { $0.id == reimbursement.id }!
    }
    
    init(user: User, reimbursement: Reimbursement, requestListManger: RequestListManger) {
        self.user = user
        self.reimbursement = reimbursement
        self.requestListManger = requestListManger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setTitle(to: "Edit Reimbursement")
        
        let userNameHeader = createHeaderLabel(text: "User Name")
        let requestDateHeader = createHeaderLabel(text: "Start Date")
        let amountHeader = createHeaderLabel(text: "Amount")
        let descriptionHeader = createHeaderLabel(text: "Description")
        let imagesHeader = createHeaderLabel(text: "Attachments")
        let statusHeader = createHeaderLabel(text: "Status")
        
        // Create and configure value labels
        let userNameLabel = createLabel(text: "\(user.firstName) \(user.lastName) ",
                                        font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        let requestDateLabel = createLabel(text: "\(Utils.formattedDateWithDayName(reimbursement.requestDate))",
                                           font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        let amountLabel = createLabel(text: "$\(reimbursement.amount)",
                                      font: UIFont.systemFont(ofSize: 16))
        
        let descriptionLabel = createLabel(text: "\(reimbursement.description)",
                                           font: UIFont.systemFont(ofSize: 16, weight: .medium))
        descriptionLabel.numberOfLines = 0
        
        let imagesStack = createImagesStack(imagesUrls: reimbursement.imagesUrls)
        let imagesEmptyLabel = createLabel(text: "No Attachments",
                                           font: UIFont.systemFont(ofSize: 16, weight: .medium))
        
        
        let statusLabel = createLabel(text: "\(reimbursement.status)",
                                      font: UIFont.systemFont(ofSize: 16))
        
        statusLabel.textColor = reimbursement.status == "Pending" ? Utils.darkOrange
        : reimbursement.status == "Rejected" ? Utils.darkRed
        : Utils.darkGreen
        
        
        requestStack = UIStackView()
        
        requestStack = UIStackView(
            arrangedSubviews: [
                createStackView(headerLabel: userNameHeader, valueLabel: userNameLabel),
                createStackView(headerLabel: requestDateHeader, valueLabel: requestDateLabel),
                createStackView(headerLabel: amountHeader, valueLabel: amountLabel),
                createStackView(headerLabel: descriptionHeader, valueLabel: descriptionLabel),
            ])
        
        if reimbursement.imagesUrls.count > 0 {
            requestStack.addArrangedSubview(createStackView(headerLabel: imagesHeader, imagesStack: imagesStack))
        } else {
            requestStack.addArrangedSubview(createStackView(headerLabel: imagesHeader, valueLabel: imagesEmptyLabel))
        }
        
        requestStack.addArrangedSubview(createStackView(headerLabel: statusHeader, valueLabel: statusLabel))
                                            
        
        requestStack.axis = .vertical
        requestStack.spacing = 15
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        requestStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(requestStack)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 25),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -10),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            requestStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            requestStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            requestStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            requestStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        if reimbursement.imagesUrls.count > 0 {
            NSLayoutConstraint.activate([
                imagesStack.widthAnchor.constraint(equalTo: requestStack.widthAnchor),
                imagesStack.centerXAnchor.constraint(equalTo: requestStack.centerXAnchor)
            ])
        }
        
        scrollView.contentSize = requestStack.bounds.size
    }
    
    private func createImagesStack(imagesUrls: Set<URL>) -> UIStackView {
        imagesStack = UIStackView()
        imagesStack.axis = .vertical
        imagesStack.spacing = 10
        imagesStack.alignment = .center
        
        let maxImageSize: CGFloat = 200.0
        
        for url in imagesUrls {
            Image.loadImageFromURL(url) { [unowned self] image in
                
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    
                    let imageViewHeight: CGFloat
                    let imageViewWidth: CGFloat
                    
                    let imageAspectRatio = image!.size.width / image!.size.height
                    
                    if imageAspectRatio > 1.0 {
                        imageViewWidth = maxImageSize
                        imageViewHeight = maxImageSize / imageAspectRatio
                    } else {
                        imageViewHeight = maxImageSize
                        imageViewWidth = maxImageSize * imageAspectRatio
                    }
                    
                    // layout conflixt with next 2 lines
                    imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
                    imageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
                    imageView.isUserInteractionEnabled = true
                    imageView.addGestureRecognizer(tapGesture)
                    
                    self.imagesStack.addArrangedSubview(imageView)
                }
            }
        }
        return imagesStack
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view as? UIImageView {
            let fullScreenImageVC = FullScreenImageViewController()
            
            fullScreenImageVC.imageView.image = tappedImageView.image
            
            fullScreenImageVC.modalPresentationStyle = .formSheet
            present(fullScreenImageVC, animated: true, completion: nil)
        }
    }
    
    override func approveButtonTapped() {
        reimbursement.isApproved = true
        reimbursement.isModifiedByAdmin = true
        
        reimbursement.setReimbursementData { _ in }
        
        requestListManger.workspaceReimbursements[index] = reimbursement
        requestListManger.hostingVC?.setupInfoMessageView()
        
       
        goBack()
    }
    
    override func rejectButtonTapped() {
        reimbursement.isApproved = false
        reimbursement.isModifiedByAdmin = true
        
        reimbursement.setReimbursementData { _ in }
        
        requestListManger.workspaceReimbursements[index] = reimbursement
        requestListManger.hostingVC?.setupInfoMessageView()

       
        
        goBack()
    }
    
    override func cancelButtonTapped() {
        requestListManger.workspaceReimbursements.remove(at: index)
        reimbursement.removeReimbursement(requestVC: requestListManger.hostingVC!) { _ in}
        
        requestListManger.hostingVC?.setupInfoMessageView()
        goBack()
    }
}

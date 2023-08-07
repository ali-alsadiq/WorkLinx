//
//  AddRequestViewController.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-06.
//

import UIKit
import SwiftUI

class AddRequestViewController: UIViewController, UITextViewDelegate {
    
    var tab: String
    var addButton: UIBarButtonItem!
    private var timeOffButton: UIButton!
    private var reimbursementButton: UIButton!
    private var amountTextField: UITextField!
    private var descriptionTextView: UITextView!
    private var isEmptyDescription = true
    private var addImagesButton: UIButton!
    static var selectedImages: Set<UIImage> = []
    
    public var requestVC: RequestViewController
    
    @ObservedObject private var requestListManger = RequestListManger()

    var selectedStartDate = Date()
    var selectedEndDate = Date()
    
    private var selectedStartDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.selectedStartDate },
            set: { self.selectedStartDate = $0 }
        )
    }
    
    private var selectedEndDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.selectedEndDate },
            set: { self.selectedEndDate = $0 }
        )
    }
    
    private var compactStartDatePicker: UIHostingController<CompactDatePickerView>!
    private var compactEndDatePicker: UIHostingController<CompactDatePickerView>!
    private var dateSelectorStack: UIStackView!
    
    init(tab: String, requestListManger: RequestListManger, requestVC: RequestViewController){
        self.tab = tab
        self.requestListManger =  requestListManger
        self.requestVC = requestVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        let navigationBar = CustomNavigationBar(title: "Add Request")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        addButton = UIBarButtonItem()
        addButton.title = "Add"
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        navigationBar.items?.first?.rightBarButtonItem = addButton
        navigationBar.items?.first?.leftBarButtonItem = backButton
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        timeOffButton = UIButton(type: .system)
        timeOffButton.setTitle("Time Off", for: .normal)
        timeOffButton.addTarget(self, action: #selector(timeOffButtonTapped), for: .touchUpInside)
        timeOffButton.layer.borderWidth = 1.0
        timeOffButton.layer.borderColor = UIColor.gray.cgColor
        timeOffButton.setTitleColor(.darkGray, for: .normal)
        timeOffButton.backgroundColor = .white
        timeOffButton.layer.cornerRadius = 15
        timeOffButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        reimbursementButton = UIButton(type: .system)
        reimbursementButton.setTitle("Reimbursement", for: .normal)
        reimbursementButton.addTarget(self, action: #selector(reimbursementButtonTapped), for: .touchUpInside)
        reimbursementButton.layer.borderWidth = 1.0
        reimbursementButton.layer.borderColor = UIColor.gray.cgColor
        reimbursementButton.setTitleColor(.darkGray, for: .normal)
        reimbursementButton.backgroundColor = .white
        reimbursementButton.layer.cornerRadius = 15
        reimbursementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        // Add form elements to a stack
        let buttonsStack = UIStackView(arrangedSubviews: [timeOffButton, reimbursementButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Time Off request form
        
        compactStartDatePicker = UIHostingController(
            rootView: CompactDatePickerView(selectedDate: selectedStartDateBinding, label: "Start Date")
        )
        
        compactEndDatePicker = UIHostingController(
            rootView: CompactDatePickerView(selectedDate: selectedEndDateBinding, label: "End Date")
        )
        
        addChild(compactStartDatePicker)
        addChild(compactEndDatePicker)
        
        compactStartDatePicker.view.translatesAutoresizingMaskIntoConstraints = false
        compactEndDatePicker.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(compactStartDatePicker.view)
        view.addSubview(compactEndDatePicker.view)
        
        
        NSLayoutConstraint.activate([
            compactStartDatePicker.view.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 40),
            compactStartDatePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compactStartDatePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            compactEndDatePicker.view.topAnchor.constraint(equalTo: compactStartDatePicker.view.bottomAnchor, constant: 20),
            compactEndDatePicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            compactEndDatePicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        compactStartDatePicker.didMove(toParent: self)
        compactEndDatePicker.didMove(toParent: self)
        
        
        // Reimbursement request form
        amountTextField = CustomTextField(placeholder: "Enter amount", textContentType: .name)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.addTarget(self, action: #selector(amountTextFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(amountTextField)
        
        descriptionTextView = UITextView()
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.text = "Enter description..." // Placeholder text
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        
        view.addSubview(descriptionTextView)
        
        addImagesButton = UIButton(type: .system)
        addImagesButton.setTitle("Add Images", for: .normal)
        addImagesButton.addTarget(self, action: #selector(addImagesButtonTapped), for: .touchUpInside)
        addImagesButton.layer.borderWidth = 2.0
        addImagesButton.layer.borderColor = UIColor.systemOrange.cgColor
        addImagesButton.setTitleColor(.black, for: .normal)
        addImagesButton.backgroundColor = .systemOrange.withAlphaComponent(0.8)
        addImagesButton.layer.cornerRadius = 15
        addImagesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addImagesButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addImagesButton)

        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 20),
            amountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),
            
            addImagesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addImagesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            addImagesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addImagesButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        // Set default form
        switch tab
        {
        case "All Requests", "Time Off", "My Time Off":
            timeOffButtonTapped()
        default:
            reimbursementButtonTapped()
        }
    }
    
    @objc func addImagesButtonTapped() {
        let imageSelectionVC = ImageSelectionViewController()
        let navigationController = UINavigationController(rootViewController: imageSelectionVC)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        // Filter out non-numeric characters
        textField.text = textField.text?.filter { "0123456789".contains($0) }
    }
    
    @objc func addButtonTapped() {
        
        if tab == "Time Off" {
            
            if selectedStartDate >= selectedEndDate {
                let message = "The selected start date should be earlier than the end date."
                Utils.showAlert(title: "Invalid Dates", message: message, viewController: self)
                
                // Adjust dates
                return
            }
            
            if selectedStartDate < Calendar.current.startOfDay(for: Date()) {
                let message = "The selected start date should be earlier than the current."
                Utils.showAlert(title: "Invalid Dates", message: message, viewController: self)

                // Adjust dates
                return
            }
            
            // Create an instance of TimeOff with the required data
            let newTimeOff = TimeOff(
                workSpaceId: Utils.workspace.workspaceId,
                userId: Utils.user.id,
                startTime: selectedStartDate,
                endTime: selectedEndDate,
                isApproved: false
            )

            // Call the createTimeOff function
            newTimeOff.createTimeOff { [weak self] result in
                switch result {
                case .success(let timeOffId):
                    // Update static data
                    Utils.user.timeOffRequestIds.append(timeOffId)
                    Utils.workspace.timeOffRequestIds.append(timeOffId)
                    Utils.workSpceTimeOffs.append(newTimeOff)
                    self?.requestListManger.workspaceTimeOffs.append(newTimeOff)
                    
                    // Update Firebase
                    Workspace.updateWorkspace(workspace: Utils.workspace) { _ in }
                    Utils.user.setUserData() { _ in }
                    
                    // Go back to previous page
                    // update table in the parent view
                    self?.requestVC.setupInfoMessageView()
                    self?.dismiss(animated: true)
                    
                case .failure(let error):
                    print("Error creating time off request: \(error.localizedDescription)")
                }
            }
        }
        
        if tab == "Reimbursement" {
            if let amountText = amountTextField.text, !amountText.isEmpty {

                if let amountValue = Double(amountText) {
                    
                    if AddRequestViewController.selectedImages.count > 0 {
                        
                        Image.uploadImagesToFirebaseStorage(images: AddRequestViewController.selectedImages) { [weak self] result in
                            
                            switch result {
                            case .success(let uploadedURLs):
                                print("Uploaded URLs: \(uploadedURLs)")
                                self?.createReimbursement(imagesUrls: uploadedURLs, amount: amountValue)
                                
                                // update table in the parent view

                            case .failure(let error):
                                print("Error uploading images: \(error)")
                            }
                        }
                    }
                    else {
                        createReimbursement(amount: amountValue)
                    }
                } else {
                    let message = "You must enter a valid amount"
                    Utils.showAlert(title: "Invalid Amount", message: message, viewController: self)
                    return
                }
            } else {
                let message = "You must enter a valid amount"
                Utils.showAlert(title: "Empty Amount", message: message, viewController: self)
                return
            }
        }
        
        dismiss(animated: true)
    }
    
    private func createReimbursement(imagesUrls:  Set<URL> = [], amount: Double) {
        
        let newReimbursement = Reimbursement(
            workSpaceId: Utils.workspace.workspaceId,
            userId: Utils.user.id,
            requestDate: Date(),
            imagesUrls: imagesUrls,
            amount: amount,
            description: descriptionTextView.text!,
            isApproved: false)
        
        Utils.workspaceReimbursements.append(newReimbursement)
        requestListManger.workspaceReimbursements.append(newReimbursement)
        
        newReimbursement.createReimbursement(){ [unowned self] result in
            switch result {
            case .success(let documentID):
                // Update static data
                Utils.user.reimbursementRequestIds.append(documentID)
                Utils.workspace.reimbursementRequestIds.append(documentID)
                
                // Update Firebase
                Utils.user.setUserData() { _ in }
                Workspace.updateWorkspace(workspace: Utils.workspace) { _ in }
                
                // Go back to previous page
                requestVC.setupInfoMessageView()
                self.dismiss(animated: true)
                
            case .failure(let error):
                print("Error creating reimbursement: \(error.localizedDescription)")
            }}
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func timeOffButtonTapped() {
        tab = "Time Off"
        
        reimbursementButton.setTitleColor(.darkGray, for: .normal)
        reimbursementButton.backgroundColor = .white
        
        timeOffButton.setTitleColor(.white, for: .normal)
        timeOffButton.backgroundColor = .darkGray
        
        amountTextField.isHidden = true
        descriptionTextView.isHidden = true
        addImagesButton.isHidden = true
        
        compactStartDatePicker.view.isHidden = false
        compactEndDatePicker.view.isHidden = false
    }
    
    @objc func reimbursementButtonTapped() {
        tab = "Reimbursement"
        
        timeOffButton.setTitleColor(.darkGray, for: .normal)
        timeOffButton.backgroundColor = .white
        
        reimbursementButton.setTitleColor(.white, for: .normal)
        reimbursementButton.backgroundColor = .darkGray
        
        amountTextField.isHidden = false
        descriptionTextView.isHidden = false
        addImagesButton.isHidden = false
        
        compactStartDatePicker.view.isHidden = true
        compactEndDatePicker.view.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            isEmptyDescription = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description..."
            textView.textColor = UIColor.lightGray
            isEmptyDescription = true
        }
    }
}

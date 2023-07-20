import UIKit

class RegisterEmployerViewController: UIViewController {
    var texboxComopanyName: CustomTextField!
    var textBoxAddress: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add nav bar
        let navigationBar = CustomNavigationBar(title: "Create Your Workspace")
        let backButton = BackButton(text: nil, target: self, action: #selector(goBack))
        
        navigationBar.items?.first?.leftBarButtonItem = backButton
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Text fields
        texboxComopanyName = CustomTextField(placeholder: "Name", textContentType: .organizationName)
        textBoxAddress = CustomTextField(placeholder: "Address", textContentType: .fullStreetAddress)
        
        // Create the vertical stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add textfields to the stack
        stackView.addArrangedSubview(texboxComopanyName)
        stackView.addArrangedSubview(textBoxAddress)
        
        view.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        
        // Create a UIButton
        let createButton = UIButton(type: .system)
        createButton.setTitle("Crerate Workspace", for: .normal)
        createButton.backgroundColor = .darkGray
        createButton.setTitleColor(.white, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UIButton to the view
        view.addSubview(createButton)
        
        // Set constraints for the UIButton
        NSLayoutConstraint.activate([
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 65) // Adjust height as needed
        ])
        
        createButton.addTarget(self, action: #selector(createBttnTapped), for: .touchUpInside)
    }
    
    @objc func createBttnTapped() {
        // Check if the text fields are not empty
        guard let companyName = texboxComopanyName.text, !companyName.isEmpty,
              let address = textBoxAddress.text, !address.isEmpty else {
            // Show alert for empty fields
            showEmptyFieldsAlert()
            return
        }
        
        // Check if the workspace name is unique
        if isWorkspaceNameUnique(companyName) {
            // Create the workspace
            let newWorkspace = Workspace(name: companyName, address: address)
            
            // Make it the default workspace for the user
            Utils.user.defaultWorkspace = newWorkspace
            
            // Append the workspace and pay rate to the user's workSpacesAndPayRate
            Utils.user.workSpacesAndPayRate.append((workspace: newWorkspace, payRate: 0))
            
            // Add the user to the employees and admins array of the new workspace
            newWorkspace.admins.append(Utils.user)
            newWorkspace.employees.append(Utils.user)
            
            DataProvider.workSpaces.append(newWorkspace)
            
            // Navigate to the dashboard view
            Utils.navigate("DashboardView", self)
        } else {
            // Show alert for non-unique workspace name
            showNonUniqueNameAlert()
        }
    }
    
    func isWorkspaceNameUnique(_ name: String) -> Bool {
        // Check if there is any workspace with the same name
        return !DataProvider.workSpaces.contains { $0.name == name }
    }
    
    func showEmptyFieldsAlert() {
        let alertController = UIAlertController(title: "Empty Fields",
                                                message: "Please enter a name and address for the workspace.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showNonUniqueNameAlert() {
        let alertController = UIAlertController(title: "Workspace Name must be unique",
                                                message: "A workspace with the same name already exists. Please enter a unique name.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
}

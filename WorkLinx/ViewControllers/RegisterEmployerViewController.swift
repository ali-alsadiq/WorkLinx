import UIKit

class RegisterEmployerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStackview()
        
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
    }
    
    @objc func goBack() {
        // Pop the current view controller from the navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createStackview() {
        let stackView = UIStackView()
        stackView.frame = view.bounds
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        
        let fields = ["First Name", "Last Name", "Email", "Qualified Positions"]
        
        for fieldText in fields {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2) // Adjust the alpha and color to your preference
            containerView.layer.cornerRadius = 0 // Optional: Add corner radius for rounded corners
            containerView.layer.borderColor = UIColor.black.cgColor // Set border color to black
            containerView.layer.borderWidth = 1 // Set border width
            
            let label = UILabel()
            label.text = fieldText
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            containerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: containerView.topAnchor),
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20), // Add left padding
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20), // Add right padding
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            stackView.addArrangedSubview(containerView)
            
            // Adjust containerView's constraints
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0), // Align with stackView's leading edge
                containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0) // Align with stackView's trailing edge
            ])
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100), // Adjust the constant to move the stackView further down
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0), // Align with view's leading edge
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0) // Align with view's trailing edge
        ])
    }
}


// Hello

import UIKit

class DocumentsViewController: UIViewController {

    let fakeDocuments = ["Resume.pdf", "Proposal.docx", "MeetingNotes.txt", "FinancialReport.pdf", "Agenda.pptx"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Create a navigation bar
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Create a navigation item
        let navigationItem = UINavigationItem()
        
        // Create a back button
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // Create a title label
        let titleLabel = UILabel()
        titleLabel.text = "Documents"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        navigationItem.titleView = titleLabel
        
        navigationBar.items = [navigationItem]
        
        // Configure collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        // Create collection view
        let documentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        documentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        documentsCollectionView.backgroundColor = .white
        view.addSubview(documentsCollectionView)
        
        NSLayoutConstraint.activate([
            documentsCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            documentsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            documentsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            documentsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        documentsCollectionView.dataSource = self
        documentsCollectionView.delegate = self
        documentsCollectionView.register(DocumentCollectionViewCell.self, forCellWithReuseIdentifier: "DocumentCell")
        
        // Add buttons
        let uploadButton = UIButton()
        uploadButton.setTitle("Upload Files", for: .normal)
        uploadButton.backgroundColor = .systemGreen
        uploadButton.layer.cornerRadius = 8
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadButton)
        
        let shareButton = UIButton()
        shareButton.setTitle("Share", for: .normal)
        shareButton.backgroundColor = .systemGreen
        shareButton.layer.cornerRadius = 8
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            uploadButton.widthAnchor.constraint(equalToConstant: 120),
            uploadButton.heightAnchor.constraint(equalToConstant: 40),
            
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 120),
            shareButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func uploadButtonTapped() {
        // Handle upload button tap
    }

    @objc func shareButtonTapped() {
        // Handle share button tap
    }
}

extension DocumentsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeDocuments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath) as! DocumentCollectionViewCell
        cell.documentNameLabel.text = fakeDocuments[indexPath.item]
        
        // Set the background image
        let folderImage = UIImageView(image: UIImage(named: "Folder.png"))
        folderImage.contentMode = .scaleAspectFit
        cell.backgroundView = folderImage
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenWidth = collectionView.bounds.width
            let spacing: CGFloat = 16
            let itemWidth = (screenWidth - 4 * spacing) / 3 // Distribute 3 items in one row with spacing

            return CGSize(width: itemWidth, height: itemWidth + 30)
        }
}

class DocumentCollectionViewCell: UICollectionViewCell {
    let documentNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(documentNameLabel)
        contentView.backgroundColor = .clear // Set the background color to clear
        
        documentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            documentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            documentNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            documentNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            documentNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

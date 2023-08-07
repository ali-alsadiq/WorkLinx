//
//  ImageInputView.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-06.
//

import UIKit
import Photos

class ImageSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var imagesSet: Set<UIImage> = []
    private var images: [UIImage] {
        return Array(imagesSet)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Images"
        setupCollectionView()
        setupNavigationBar()
        checkPhotoLibraryAccess()
    }
    
    private func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            setupCollectionView()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.setupCollectionView()
                    } else {
                        // Denied access
                    }
                }
            }
        case .denied, .restricted:
            // Denied or restricted access
            break
        default:
            break
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.bounds.width - 20) / 3, height: (view.bounds.width - 20) / 3)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var fetchedImages: [UIImage] = []
        
        fetchResult.enumerateObjects { asset, index, stop in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .exact
            
            let targetWidth = min(CGFloat(asset.pixelWidth) / 4, 500)
            let originalAspectRatio = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth)
            let targetHeight = targetWidth * originalAspectRatio
            let targetSize = CGSize(width: targetWidth, height: targetHeight)

            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let image = image {
                    fetchedImages.append(image)
                }
            }
        }
        
        imagesSet = Set(fetchedImages)
        
        collectionView.reloadData()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let selectedImage = images[indexPath.item]
        let isSelected = AddRequestViewController.selectedImages.contains(selectedImage)
        cell.configure(with: selectedImage, isSelected: isSelected)
        return cell
    }

    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.item]
        
        if AddRequestViewController.selectedImages.contains(selectedImage) {
            AddRequestViewController.selectedImages.remove(selectedImage)
        } else {
            AddRequestViewController.selectedImages.insert(selectedImage)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

class ImageCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var checkmarkImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupCheckmarkImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    private func setupCheckmarkImageView() {
        checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkImageView.contentMode = .scaleAspectFill
        checkmarkImageView.clipsToBounds = true
        checkmarkImageView.tintColor = .systemGreen
        checkmarkImageView.isHidden = true
        contentView.addSubview(checkmarkImageView)
        
        // Adjust the checkmark position as needed
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            checkmarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 25),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    func configure(with image: UIImage, isSelected: Bool) {
        imageView.image = image
        checkmarkImageView.isHidden = !isSelected
    }
}

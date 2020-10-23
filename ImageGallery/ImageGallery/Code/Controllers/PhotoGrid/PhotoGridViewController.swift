//
//  PhotoGridViewController.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridViewProtocol: BaseViewProtocol {
    
    func showPhotos()
}

protocol PhotoGridConfigurableViewProtocol: class {
    
    func set(viewModel: PhotoGridViewModelProtocol)
}

class PhotoGridViewController: UIViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var cvPhotos: UICollectionView!
    
    // MARK: - Private properties
    
    private var viewModel:PhotoGridViewModelProtocol?
    private let itemsPerRow: CGFloat = 2
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PHOTOS".localized()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
    
    private func setupTableView() {
        
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
        registerNib()
    }
    
    private func registerNib() {
        cvPhotos.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
}

// MARK: - PhotoGridViewProtocol

extension PhotoGridViewController: PhotoGridViewProtocol {
    
    func showPhotos() {
        cvPhotos.reloadData()
    }
}

// MARK: - PhotoGridViewProtocol

extension PhotoGridViewController: PhotoGridConfigurableViewProtocol {
    
    func set(viewModel: PhotoGridViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoGridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = 20 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0,
                            left: 20.0,
                            bottom: 10.0,
                            right: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoGridViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let photoCellViewModelsCount = viewModel?.getPhotoCellViewModels().count ?? 0
        return photoCellViewModelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell {
            
            let photosCellViewModel = viewModel?.getPhotoCellViewModels()
            let photoCellViewModel = photosCellViewModel?[indexPath.row]
            cell.photoCellViewModel = photoCellViewModel
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

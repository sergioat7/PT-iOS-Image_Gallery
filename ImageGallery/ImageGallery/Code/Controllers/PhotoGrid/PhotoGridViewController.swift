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
    func showLoading()
    func hideLoading()
}

protocol PhotoGridConfigurableViewProtocol: class {
    
    func set(viewModel: PhotoGridViewModelProtocol)
}

class PhotoGridViewController: BaseViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var etSearch: UITextField!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private var viewModel:PhotoGridViewModelProtocol?
    private let itemsPerRow: CGFloat = 2
    private let marginsHorizontal: CGFloat = 20
    private let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PHOTOS".localized()
        configViews()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
    
    private func configViews() {
        etSearch.delegate = self
    }
    
    private func setupCollectionView() {
        
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
        registerNib()
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        cvPhotos.refreshControl = refreshControl
    }
    
    private func registerNib() {
        
        cvPhotos.register(UINib(nibName: "PhotoCollectionViewCell",
                                bundle: nil),
                          forCellWithReuseIdentifier: Constants.cellName)
    }
    
    private func loadMore() {
        viewModel?.searchPhotos()
    }
    
    @objc private func reloadData() {
        
        viewModel?.reloadData()
        viewModel?.searchPhotos()
    }
}

// MARK: - PhotoGridViewProtocol

extension PhotoGridViewController: PhotoGridViewProtocol {
    
    func showPhotos() {
        
        cvPhotos.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showLoading() {
        aiLoading.startAnimating()
    }
    
    func hideLoading() {
        aiLoading.stopAnimating()
    }
}

// MARK: - PhotoGridViewProtocol

extension PhotoGridViewController: PhotoGridConfigurableViewProtocol {
    
    func set(viewModel: PhotoGridViewModelProtocol) {
        self.viewModel = viewModel
    }
}

// MARK: - UITextFieldDelegate

extension PhotoGridViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text {
            
            viewModel?.setTags(tags: text)
        }
        textField.resignFirstResponder()
        return true
      }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoGridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvWidth = collectionView.frame.width - marginsHorizontal - marginsHorizontal
        let contentSize = cvWidth - ( marginsHorizontal * (itemsPerRow - 1) )
        let itemSize = contentSize / itemsPerRow
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0,
                            left: marginsHorizontal,
                            bottom: 10.0,
                            right: marginsHorizontal)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellName, for: indexPath)
        let photosCellViewModel = viewModel?.getPhotoCellViewModels() ?? []
        
        if let photoCell = cell as? PhotoCollectionViewCell,
              photosCellViewModel.count > 0 {
            
            let photoCellViewModel = photosCellViewModel[indexPath.row]
            photoCell.photoCellViewModel = photoCellViewModel
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photoCellViewModelsCount = viewModel?.getPhotoCellViewModels().count ?? 0
        if indexPath.item == (photoCellViewModelsCount - 1) {
            loadMore()
        }
    }
}

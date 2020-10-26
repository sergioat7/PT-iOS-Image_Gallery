//
//  PhotoGridViewController.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoGridConfigurableViewProtocol: class {
    
    func set(viewModel: PhotoGridViewModelProtocol)
}

class PhotoGridViewController: BaseViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var etSearch: UITextField!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var ivNoResults: UIImageView!
    
    // MARK: - Private properties
    
    private var viewModel:PhotoGridViewModelProtocol?
    private let disposeBag = DisposeBag()
    private let itemsPerRow: CGFloat = 2
    private let marginsHorizontal: CGFloat = 20
    private let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PHOTOS".localized()
        configViews()
        registerNib()
        setupCollectionView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
    
    private func configViews() {
        
        etSearch.placeholder = "SEARCH".localized()
        ivNoResults.isHidden = false
    }
    
    private func registerNib() {
        
        cvPhotos.register(UINib(nibName: "PhotoCollectionViewCell",
                                bundle: nil),
                          forCellWithReuseIdentifier: Constants.cellName)
    }
    
    private func setupCollectionView() {
        
        cvPhotos.contentInset = UIEdgeInsets(top: 10.0,
                                             left: marginsHorizontal,
                                             bottom: 10.0,
                                             right: marginsHorizontal)
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        cvPhotos.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        
        etSearch.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            
            if let text = self.etSearch.text {

                self.aiLoading.startAnimating()
                self.viewModel?.setTags(tags: text)
                self.viewModel?.reloadData()
                self.viewModel?.searchPhotos()
            }
            self.etSearch.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        cvPhotos
            .rx
            .willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in

                let photoCellViewModelsCount = self.viewModel?.getPhotoCellViewModelsValue().count ?? 0
                if indexPath.item == (photoCellViewModelsCount - 1) {
                    self.viewModel?.searchPhotos()
                }
            })).disposed(by: disposeBag)

        cvPhotos
            .rx
            .itemSelected
            .subscribe(onNext:{ indexPath in

                let photoCellViewModels = self.viewModel?.getPhotoCellViewModelsValue()
                if let fullImageUrlString = photoCellViewModels?[indexPath.row].fullImageUrl,
                   let fullImageUrl = URL(string: fullImageUrlString) {
                    self.viewModel?.presentImageFullScreen(imageUrl: fullImageUrl)
                }
            }).disposed(by: disposeBag)
        
        cvPhotos
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel?
            .getLoading()
            .bind(to: aiLoading.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel?
            .getLoading()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel?
            .getError()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorResponse in
                
                self.showError(message: errorResponse.message,
                               handler: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .getPhotoCellViewModels()
            .bind(to: cvPhotos.rx.items(cellIdentifier: Constants.cellName, cellType: PhotoCollectionViewCell.self)) { (row,photo,cell) in
                cell.photoCellViewModel = photo
            }.disposed(by: disposeBag)
        
        viewModel?
            .getPhotoCellViewModels()
            .subscribe(onNext: { photos in
                self.ivNoResults.isHidden = photos.count > 0
            }).disposed(by: disposeBag)
    }
    
    @objc private func reloadData() {
        
        viewModel?.reloadData()
        viewModel?.searchPhotos()
    }
}

// MARK: - PhotoGridConfigurableViewProtocol

extension PhotoGridViewController: PhotoGridConfigurableViewProtocol {
    
    func set(viewModel: PhotoGridViewModelProtocol) {
        self.viewModel = viewModel
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
}

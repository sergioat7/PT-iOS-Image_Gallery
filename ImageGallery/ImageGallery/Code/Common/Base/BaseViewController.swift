//
//  BaseViewController.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 21/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import PopupDialog

protocol BaseViewProtocol: class {
    
    func showError(message: String, handler: (() -> Void)?)
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let message = "Showing " + NSStringFromClass(self.classForCoder)
        print(message)
    }
    
    // MARK: - BaseViewProtocol
    
    func showError(message: String, handler: (() -> Void)?) {
        
        let popup = PopupDialog(title: "APP_NAME".localized(),
                                message: message.localized())
        setupDialog()
        
        let button = DefaultButton(title: "ERROR_BUTTON_ACCEPT".localized(),
                                   dismissOnTap: true) {
            handler?()
        }
     
        popup.addButtons([button])
        present(popup,
                animated: true,
                completion: nil)
    }
    
    // MARK: - Private functions
    
    private func setupDialog() {
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor = .white
        dialogAppearance.titleColor = .black
        dialogAppearance.titleTextAlignment = .center
        dialogAppearance.messageColor = .black
        dialogAppearance.messageTextAlignment = .center
        
        let buttonAppearance = DefaultButton.appearance()
        buttonAppearance.titleColor = .black
    }
}

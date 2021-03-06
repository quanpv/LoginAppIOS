//
//  BaseViewController.swift
//  LoginApp
//
//  Created by Quan Pham Van on 7/18/18.
//  Copyright © 2018 QuanPV. All rights reserved.
//

import MBProgressHUD
import Foundation
import UIKit
import Toaster

class BaseViewController: UIViewController {
    var loading: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        self.configureViewModel()
    }
    
    func configureViewModel()  {}
}

extension BaseViewController {
    func showLoading() {
        self.loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loading!.contentColor = Color.omiseGOBlue.uiColor()
        self.loading!.bezelView.style = .solidColor
        self.loading!.bezelView.color = UIColor.white
        self.loading!.mode = .indeterminate
    }
    
    func hideLoading() {
        if let loading = self.loading {
            loading.hide(animated: true)
        }
    }
    
    private func setupToast(_ toast: Toast) {
        toast.view.font = Font.avenirBook.withSize(15)
        toast.duration = Delay.long
    }
    
    func showMessage(_ message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let messageToast = Toast(text: message)
        self.setupToast(messageToast)
        messageToast.show()
    }
    
    func showError(withMessage message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let errorToast = Toast(text: message)
        self.setupToast(errorToast)
        errorToast.view.backgroundColor = UIColor.red
        errorToast.view.textColor = UIColor.white
        errorToast.show()
    }
    
}

class BaseTableViewController: UITableViewController {
    var loading: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.configureViewModel()
    }
    
    func configureViewModel() {}
}

extension BaseTableViewController {
    func showLoading(withMessage message: String? = nil) {
        self.loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loading!.label.text = message
        self.loading!.contentColor = Color.omiseGOBlue.uiColor()
        self.loading!.bezelView.style = .solidColor
        self.loading!.bezelView.color = UIColor.white
        self.loading!.mode = .indeterminate
    }
    
    func hideLoading() {
        if let loading = self.loading {
            loading.hide(animated: true)
        }
    }
    
    private func setupToast(_ toast: Toast) {
        toast.view.font = Font.avenirBook.withSize(15)
        toast.duration = Delay.long
    }
    
    func showMessage(_ message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let messageToast = Toast(text: message)
        self.setupToast(messageToast)
        messageToast.show()
    }
    
    func showError(withMessage message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let errorToast = Toast(text: message)
        self.setupToast(errorToast)
        errorToast.view.backgroundColor = UIColor.red
        errorToast.view.textColor = UIColor.white
        errorToast.show()
    }
}


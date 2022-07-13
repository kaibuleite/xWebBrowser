//
//  ViewController.swift
//  xWebBrowser
//
//  Created by 177955297@qq.com on 06/10/2021.
//  Copyright (c) 2021 177955297@qq.com. All rights reserved.
//

import UIKit
import xWebBrowser

class ViewController: UIViewController {
    
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var childContainer: UIView!
    @IBOutlet weak var childHeightLayout: NSLayoutConstraint!
    
    // MARK: - Child
    let childWeb = xWebBrowserViewController.xDefaultViewController()
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.childWeb.isShowCloseBtn = false
        
        DispatchQueue.main.async {
            self.addChildren()
        }
    }
    
    override func addChildren() {
        self.xAddChild(viewController: self.childWeb, in: self.childContainer)
        self.childWeb.addReloadCompleted {
            [weak self] (finish) in
            guard let self = self else { return }
            let h = self.childWeb.contentSize.height
            print(finish, h)
            self.childHeightLayout.constant = h
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        self.childWeb.load(url: "https://www.baidu.com/s?wd=%E7%99%BE%E5%BA%A6%E7%83%AD%E6%90%9C&sa=ire_dl_gh_logo_texing&rsv_dl=igh_logo_pcs")
    }

}


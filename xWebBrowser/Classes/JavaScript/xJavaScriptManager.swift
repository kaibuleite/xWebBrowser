//
//  xJavaScriptManager.swift
//  xSDK
//
//  Created by Mac on 2020/9/16.
//

import UIKit
import WebKit

public class xJavaScriptManager: NSObject, WKScriptMessageHandler {

    // MARK: - Handler
    /// 收到JS事件回调
    public typealias xHandlerReceiveWebJS = (String, WKScriptMessage) -> Void
    
    // MARK: - Public Property
    /// js事件名列表
    public var jsNameArray = [String]()
    
    // MARK: - Private Property
    /// 弱引用浏览器
    weak var currentWebBrowser : xWebBrowserViewController?
    /// 回调
    var handlerReceive : xHandlerReceiveWebJS?
    
    // MARK: - 内存释放
    deinit {
        self.currentWebBrowser = nil
        self.handlerReceive = nil
        print("🗑 xJavaScriptManager")
    }
    
    // MARK: - WKScriptMessageHandler
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage)
    {
        let name = message.name
        let msg = message
        // message.body
        self.handlerReceive?(name, msg)
    }
}

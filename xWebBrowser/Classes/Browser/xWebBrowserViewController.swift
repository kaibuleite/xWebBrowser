//
//  xWebBrowserViewController.swift
//  xWebBrowser
//
//  Created by Mac on 2021/6/10.
//

import UIKit
import WebKit
import xExtension

/// 方法详情可以参考 https://www.jianshu.com/p/747b7a1dfd06
open class xWebBrowserViewController: UIViewController {

    // MARK: - Handle
    /// 点击关闭按钮回调
    public typealias xHandlerCloseWeb = () -> Void
    /// 网页加载完成回调
    public typealias xHandlerReloadCompleted = (Bool) -> Void
    
    // MARK: - IBOutlet Property
    /// 安全区域容器
    @IBOutlet weak var safeView: UIView!
    /// 关闭按钮
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK: - IBInspectable Property
    /// 是否显示关闭按钮
    @IBInspectable public var isShowCloseBtn : Bool = true
    /// 是否显示加载进度条(默认显示)
    @IBInspectable public var isShowLoadingProgress : Bool = true
    /// 进度条颜色
    @IBInspectable public var loadingProgressColor : UIColor = UIColor.blue.withAlphaComponent(0.5)
    
    // MARK: - Public Property
    public var contentSize = CGSize.zero
    /// 浏览器主体
    public let web = WKWebView.init(frame: .zero, configuration: .init())
    /// JavaScript 管理器
    public let jsMgr = xJavaScriptManager()
    
    // MARK: - Private Property
    /// 响应进度条
    let progressView = UIProgressView()
    /// 点击关闭按钮回调
    var closeWebHandler : xHandlerCloseWeb?
    /// 页面加载完成回调
    var reloadCompletedHandler : xHandlerReloadCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.removeJavaScriptMethod()
        self.removeObserver()
        self.web.uiDelegate = nil
        self.web.navigationDelegate = nil
        self.closeWebHandler = nil
        self.reloadCompletedHandler = nil
        print("🗑 xWebBrowserViewController")
    }
    
    // MARK: - Open Override Func
    /// 实例化对象
    open override class func xDefaultViewController() -> Self {
        let vc = Self.xNew(xib: nil)
        return vc
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.closeBtn.isHidden = !self.isShowCloseBtn
        self.progressView.isHidden = !self.isShowLoadingProgress
        self.progressView.progress = 0
        self.jsMgr.currentWebBrowser = self
        // 进度条
        self.progressView.progressTintColor = self.loadingProgressColor
        self.progressView.trackTintColor = .groupTableViewBackground
        self.progressView.isHidden = true
        self.safeView.addSubview(self.progressView)
        self.safeView.bringSubviewToFront(self.closeBtn)
        // 网页
        self.web.allowsBackForwardNavigationGestures = true // 是否支持手势返回
//        self.web.uiDelegate = self
        self.web.navigationDelegate = self
        self.safeView.addSubview(web)
        // 其他
        self.addObserver()
        self.updateWebConfig()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.view.bounds
        self.web.frame = frame
        frame.size.height = 2
        self.progressView.frame = frame
    }
    
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress" {
            let progress = Float(self.web.estimatedProgress)
            self.progressView.progress = progress
        }
    }
    
    // MARK: - IBAction Private Func
    @IBAction func closeBtnClick()
    {
        if let handler = self.closeWebHandler {
            // 如果有自定义关闭回调，则执行该回调
            handler()
            return
        }
        guard let nvc = self.navigationController else {
            // 如果没有自带导航栏，则模态退出
            self.dismiss(animated: true, completion: nil)
            return
        }
        if self.isEqual(nvc.children.first) == false {
            // 自己不是导航栏根视图，则退出
            nvc.popViewController(animated: true)
            return
        }
        print("⚠️ 请添加关闭事件")
    }
    
    // MARK: - Open Func
    /// 更新Web配置
    open func updateWebConfig()
    {
        let config = self.web.configuration
        // 可用允许触发网页 JavaScript
        config.preferences.javaScriptEnabled = true
        /*
        // 是否允许播放 AirPlay
        config.allowsAirPlayForMediaPlayback = true
        // 媒体播放的类型 (audio/video)
        config.mediaTypesRequiringUserActionForPlayback = .video
        // 媒体自动播放
        config.requiresUserActionForMediaPlayback = true
        // 是否允许播放 AirPlay
        config.allowsAirPlayForMediaPlayback = true
        // 媒体播放是否可以全屏控制
        config.allowsInlineMediaPlayback = true
        // 跨域
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
         */
    }
    /// 加载URL地址
    /// - Parameter str: 地址
    open func load(url str: String)
    {
        guard let url = URL.init(string: str) else { return }
        let req = URLRequest.init(url: url)
        self.web.load(req)
    }
    /// 加载HTML字符串
    /// - Parameter html: HTML字符串
    open func load(html : String)
    {
        self.web.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: - Public Func
    /// 刷新当前网页
    public func reload()
    {
        self.web.reload()
    }
    /// 清理浏览器缓存
    public func clearCache()
    {
        //allWebsiteDataTypes清除所有缓存
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let timeStamp = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: timeStamp) {
            print("缓存清理完成")
        }
    }
    
    // MARK: - 回调
    /// 添加关闭回调（退出界面啥的）
    /// - Parameter handler: 回调
    public func addCloseWeb(handler : @escaping xHandlerCloseWeb)
    {
        self.closeBtn.isHidden = !self.isShowCloseBtn
        self.closeWebHandler = handler
    }
    /// 添加页面加载完成回调
    /// - Parameter handler: 回调
    public func addReloadCompleted(handler : @escaping xHandlerReloadCompleted)
    {
        self.reloadCompletedHandler = handler
    }
    // MARK: - JS事件
    /// 添加 JS 事件
    public func addJavaScriptMethod(list : [String])
    {
        self.removeJavaScriptMethod()
        self.jsMgr.jsNameArray = list
        let config = self.web.configuration
        let uc = config.userContentController
        for name in list {
            uc.add(self.jsMgr, name: name)
        }
    }
    /// 添加收到JS事件回调
    public func addReceiveJavaScriptMethod(handler : @escaping xJavaScriptManager.xHandlerReceiveWebJS)
    {
        self.jsMgr.handlerReceive = handler
    }
    /// 调用JS事件
    public func evaluateJavaScript(code : String,
                                   handler : @escaping (Any?, Error?) -> Void)
    {
        self.web.evaluateJavaScript(code,
                                    completionHandler: handler)
    }
    /// 移除 JS 事件
    public func removeJavaScriptMethod()
    {
        let config = self.web.configuration
        let uc = config.userContentController
        for name in self.jsMgr.jsNameArray {
            uc.removeScriptMessageHandler(forName: name)
        }
        self.jsMgr.jsNameArray.removeAll()
    }
    
    // MARK: - 观察者
    /// 添加观察者
    private func addObserver()
    {
        self.web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    /// 移除观察者
    private func removeObserver()
    {
        self.web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

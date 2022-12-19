//
//  xWebBrowserViewController+WKNavigationDelegate.swift
//  xWebBrowser
//
//  Created by Mac on 2021/6/10.
//

import UIKit
import WebKit

extension xWebBrowserViewController: WKNavigationDelegate {
    
    // MARK: - 启动导航
    /// 当Web视图开始接收Web内容时调用
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    open func webView(_ webView: WKWebView,
                      didCommit navigation: WKNavigation!)
    {
        print(">>> 开始接收Web内容")
    }
    /// 当Web内容开始在Web视图中加载时调用，这个方法在上一个方法之前
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    open func webView(_ webView: WKWebView,
                      didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(">>> Web内容开始在Web视图中加载")
        // 判断是否显示加载进度条
        self.progressView.isHidden = !self.isShowLoadingProgress
        self.progressView.progress = 0 // 重置进度
    }
    
    // MARK: - 响应服务器行为
    /// 当Web视图接收服务器重定向时调用，主机地址被重定向时调用
    /// 这个场景 比如:你要访问一个界面，但是你没有登录，所以直接跳转到一个登陆界面
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    open func webView(_ webView: WKWebView,
                      didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)
    {
        print(">>> 网页重定向")
    }
    
    // MARK: - 认证
    /// 当Web视图需要对认证挑战作出响应时调用
    /// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - challenge: <#challenge description#>
    ///   - completionHandler: <#completionHandler description#>
    open func webView(_ webView: WKWebView,
                      didReceive challenge: URLAuthenticationChallenge,
                      completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        // 没用过
    }
    
    // MARK: - 出错处理
    /// 在导航过程中发生错误时调用，跳转失败时调用
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    ///   - error: 错误信息
    open func webView(_ webView: WKWebView,
                      didFail navigation: WKNavigation!,
                      withError error: Error)
    {
        print(">>> 跳转失败 \(error.localizedDescription)")
        // 隐藏加载进度条
        self.progressView.isHidden = true
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(false)
    }
    
    /// 当Web视图加载内容时发生错误时调用，页面加载失败
    /// 没有网络，加载地址，进入的是这个回调
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    ///   - error: 错误信息
    open func webView(_ webView: WKWebView,
                      didFailProvisionalNavigation navigation: WKNavigation!,
                      withError error: Error)
    {
        print(">>> 页面加载失败 \(error.localizedDescription)")
        // 隐藏加载进度条
        self.progressView.isHidden = true
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(false)
    }
    
    // MARK: - 跟踪加载进程
    /// 跳转成功,页面加载完毕时调用
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigation: 一个对象WKNavigation包含跟踪网页加载进度的信息
    open func webView(_ webView: WKWebView,
                      didFinish navigation: WKNavigation!)
    {
        print(">>> 网页加载完成")
        self.progressView.isHidden = true  // 隐藏加载进度条
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(true)
    }
    
    /// 当Web视图的Web内容处理终止时调用
    /// 9.0才能使用，web内容处理中断时会触发
    /// - Parameter webView: 调用委托方法的Web视图
    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView)
    {
        print(">>> 网页内容处理终止")
    }
    
    // MARK: - 是否允许跳转
    /// 决定是否允许或取消导航, 在发送请求之前，决定是否跳转
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigationAction: 发送的请求信息
    ///   - decisionHandler: 执行策略
    open func webView(_ webView: WKWebView,
                      decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        
    }
    
    /// 决定是否在其响应已知之后允许或取消导航，在收到响应后，决定是否跳转
    /// - Parameters:
    ///   - webView: 调用委托方法的Web视图
    ///   - navigationResponse: 接收到的响应信息
    ///   - decisionHandler: 执行策略
    open func webView(_ webView: WKWebView,
                      decidePolicyFor navigationResponse: WKNavigationResponse,
                      decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        
    }
     
}


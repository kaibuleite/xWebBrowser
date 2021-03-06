//
//  xWebBrowserViewController+WKNavigationDelegate.swift
//  xWebBrowser
//
//  Created by Mac on 2021/6/10.
//

import UIKit
import WebKit

// MARK: - WKNavigationDelegate
extension xWebBrowserViewController: WKNavigationDelegate {
    
    /// 准备加载页面
    public func webView(_ webView: WKWebView,
                        didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("准备加载页面")
        // 判断是否显示加载进度条
        self.progressView.isHidden = !self.isShowLoadingProgress
        self.progressView.progress = 0 // 重置进度
    }
    
    /// 内容开始加载(view的过渡动画可在此方法中加载)
    public func webView(_ webView: WKWebView,
                        didCommit navigation: WKNavigation!)
    {
        print("内容开始加载")
    }
    
    /// 导航过程中发生错误时调用(跳转失败)
    public func webView(_ webView: WKWebView,
                        didFail navigation: WKNavigation!,
                        withError error: Error)
    {
        print("导航发生错误 \(error.localizedDescription)")
        // 隐藏加载进度条
        self.progressView.isHidden = true
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(false)
    }
    
    /// Web视图加载内容时发生错误时调用(没有网络，加载地址)
    public func webView(_ webView: WKWebView,
                        didFailProvisionalNavigation navigation: WKNavigation!,
                        withError error: Error)
    {
        print("网页加载内容时发生错误时 \(error.localizedDescription)")
        // 隐藏加载进度条
        self.progressView.isHidden = true
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(false)
    }
    
    /// 服务器重定向，主机地址被重定向时调用
    public func webView(_ webView: WKWebView,
                        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)
    {
        print("网页重定向")
    }
    
    /// 网页加载完成时
    public func webView(_ webView: WKWebView,
                        didFinish navigation: WKNavigation!)
    {
        print("网页加载完成")
        self.progressView.isHidden = true  // 隐藏加载进度条
        self.contentSize = webView.scrollView.contentSize
        self.reloadCompletedHandler?(true)
    }
    
}


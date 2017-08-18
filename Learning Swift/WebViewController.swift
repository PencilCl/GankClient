//
//  WebViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 18/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    fileprivate var webView: WKWebView!
    
    private lazy var closeButton: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(close))
        return buttonItem
    }()
    
    var url: URL? {
        didSet {
            if webView != nil {
                loadUrl(url: url)
            }
        }
    }
    
    @IBAction func moreMenu(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openUsingSafariAction = UIAlertAction(title: "使用Safari打开", style: .default) { [weak self] action in
            if self != nil {
                UIApplication.shared.open(self!.url!)
            }
        }
        let closeAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        controller.addAction(openUsingSafariAction)
        controller.addAction(closeAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        addWebView()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        loadUrl(url: url)
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func updateNavigationItems() {
        guard var leftButtons = navigationItem.leftBarButtonItems else {
            return
        }
        
        if webView.canGoBack {
            if leftButtons.count == 1 {
                leftButtons.append(closeButton)
            }
        } else if (leftButtons.count > 1) {
            leftButtons.remove(at: 1)
        }
        navigationItem.setLeftBarButtonItems(leftButtons, animated: false)
    }
    
    private func addWebView() {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        
        let size = UIScreen.main.bounds
        webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), configuration: webViewConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        view.sendSubview(toBack: webView)
    }
    
    private func loadUrl(url: URL?) {
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        log.debug("deinit: \(type(of: self))")
    }
}

extension WebViewController: WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            if progress >= 1.0 {
                progressView.alpha = 0
            } else {
                progressView.setProgress(progress, animated: true)
            }
        } else {
            self.title = webView.title
        }
        
        updateNavigationItems()
    }
}

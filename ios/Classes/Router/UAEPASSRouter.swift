//
//  Router.swift
//  UaePassDemo
//
//  Created by Mohammed Gomaa on 12/30/18.
//  Copyright © 2018 Mohammed Gomaa. All rights reserved.
//

import UIKit
import WebKit

extension WKProcessPool {
    static let shared = WKProcessPool()
}

extension WKWebViewConfiguration {
    static var shared: WKWebViewConfiguration {
        let source: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);"
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        conf.processPool = WKProcessPool.shared
        return conf
    }
}

@objc public class UAEPASSRouter: NSObject {
    
    @objc public static let shared = UAEPASSRouter()
    @objc public var uaePassToken: String!
    @objc public var webView: WKWebView!
    /// private constructor
    public override init() {
        uploadSignDocumentResponse = nil
        environmentConfig = UAEPassConfig(clientID: "", clientSecret: "", env: .qa)
        spConfig = SPConfig(redirectUriLogin: "", scope: "", state: "", successSchemeURL: "", failSchemeURL: "")
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.shared)
        uaePassToken = ""
    }
    @objc public var environmentConfig: UAEPassConfig
    @objc public var spConfig: SPConfig
    public var uploadSignDocumentResponse: UploadSignDocumentResponse?
}

extension String {
    public func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

import UIKit
import MixinServices
import WebKit

class PostWebViewController: WebViewController {
    
    private var message: MessageItem!
    private var html: String?
    
    class func presentInstance(message: MessageItem, asChildOf parent: UIViewController) {
        let vc = PostWebViewController(nib: R.nib.webView)
        vc.message = message
        vc.view.frame = parent.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parent.addChild(vc)
        parent.view.addSubview(vc.view)
        vc.didMove(toParent: parent)
        
        vc.view.center.y = parent.view.bounds.height * 3 / 2
        UIView.animate(withDuration: 0.5) {
            UIView.setAnimationCurve(.overdamped)
            vc.view.center.y = parent.view.bounds.height / 2
        }
        
        AppDelegate.current.mainWindow.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPageTitleConstraint.priority = .defaultLow
        webView.navigationDelegate = self
        guard let content = message.content else {
            return
        }
        DispatchQueue.global().async {
            let html = MarkdownConverter.htmlString(from: content, richFormat: true)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.html = html
                self.webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBackground(pageThemeColor: .background)
        }
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory, let html = html {
            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
    }
    
    override func moreAction(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: R.string.localizable.chat_message_menu_forward(), style: .default, handler: { (_) in
            let vc = MessageReceiverViewController.instance(content: .messages([self.message]))
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        controller.addAction(UIAlertAction(title: Localized.DIALOG_BUTTON_CANCEL, style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
}

extension PostWebViewController: WKNavigationDelegate {
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        guard let url = navigationAction.request.url else {
//            decisionHandler(.allow)
//            return
//        }
//        guard url != postContainerUrl else {
//            decisionHandler(.allow)
//            return
//        }
//        
//        defer {
//            decisionHandler(.cancel)
//        }
//        
//        if UrlWindow.checkUrl(url: url, fromWeb: true) {
//            return
//        }
//        guard let parent = parent else {
//            return
//        }
//        MixinWebViewController.presentInstance(with: .init(conversationId: "", initialUrl: url), asChildOf: parent)
//    }
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let markdown = message.content
//        let isImageEnabled = "true"
//        let escapedMarkdown = markdown.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? markdown
//        let script = "window.showMarkdown('\(escapedMarkdown)', \(isImageEnabled));"
//        webView.evaluateJavaScript(script, completionHandler: nil)
//    }
    
}

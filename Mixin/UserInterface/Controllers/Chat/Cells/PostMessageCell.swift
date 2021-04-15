import UIKit
import WebKit

class PostMessageCell: TextMessageCell {
    
    #if DEBUG_POST_LAYOUT
    let textView = UITextView()
    #endif
    
    let webView = WKWebView()
    let expandImageView = UIImageView(image: R.image.conversation.ic_message_expand())
    let trailingInfoBackgroundView = TrailingInfoBackgroundView()
    
    override func prepare() {
        messageContentView.addSubview(webView)
        messageContentView.addSubview(trailingInfoBackgroundView)
        super.prepare()
        messageContentView.addSubview(expandImageView)
        forwarderImageView.alpha = 0.9
        encryptedImageView.alpha = 0.9
        statusImageView.alpha = 0.9
        contentLabel.isHidden = true
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.isUserInteractionEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        #if DEBUG_POST_LAYOUT
        messageContentView.addSubview(textView)
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.alpha = 0.15
        #endif
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        webView.evaluateJavaScript("document.body.remove()")
    }
    
    override func render(viewModel: MessageViewModel) {
        super.render(viewModel: viewModel)
        let expandImageMargin: CGFloat
        if viewModel.style.contains(.received) {
            expandImageMargin = 9
        } else {
            expandImageMargin = 16
        }
        let origin = CGPoint(x: viewModel.backgroundImageFrame.maxX - expandImageView.frame.width - expandImageMargin,
                             y: viewModel.backgroundImageFrame.origin.y + 8)
        expandImageView.frame.origin = origin
        if let viewModel = viewModel as? PostMessageViewModel {
            webView.frame = viewModel.webViewFrame
            webView.loadHTMLString(viewModel.html, baseURL: Bundle.main.bundleURL)
            trailingInfoBackgroundView.frame = viewModel.trailingInfoBackgroundFrame
            #if DEBUG_POST_LAYOUT
            textView.frame = viewModel.webViewFrame
            textView.attributedText = viewModel.contentAttributedString
            #endif
        }
    }
    
}

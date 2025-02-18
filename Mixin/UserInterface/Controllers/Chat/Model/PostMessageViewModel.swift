import UIKit
import SwiftyMarkdown
import MixinServices

class PostMessageViewModel: TextMessageViewModel, BackgroundedTrailingInfoViewModel {
    
    override var statusNormalTintColor: UIColor {
        .white
    }
    
    override var trailingInfoColor: UIColor {
        .white
    }
    
    override var maxNumberOfLines: Int? {
        10
    }
    
    override var contentAttributedString: NSAttributedString {
        let maxNumberOfLines = self.maxNumberOfLines ?? 10
        var lines = [String]()
        rawContent.enumerateLines { (line, stop) in
            lines.append(line)
            if lines.count == maxNumberOfLines {
                stop = true
            }
        }
        let string = lines.joined(separator: "\n")
        let md = SwiftyMarkdown(string: string)
        md.link.color = .theme
        let size = Counter(value: 15)
        for style in [md.body, md.h6, md.h5, md.h4, md.h3, md.h2, md.h1] {
            style.fontSize = CGFloat(size.advancedValue)
        }
        return md.attributedString()
    }
    
    var trailingInfoBackgroundFrame = CGRect.zero
    
    override func layout(width: CGFloat, style: MessageViewModel.Style) {
        super.layout(width: width, style: style)
        layoutTrailingInfoBackgroundFrame()
    }
    
    override func linkRanges(from string: String) -> [Link.Range] {
        []
    }
    
}

extension PostMessageViewModel: SharedMediaItem {
    
    var messageId: String {
        message.messageId
    }
    
    var createdAt: String {
        message.createdAt
    }
    
}

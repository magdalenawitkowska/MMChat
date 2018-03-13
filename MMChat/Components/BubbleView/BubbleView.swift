//
//  BubbleView.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 09.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import UIKit

enum BubbleAlignment {
    case Left
    case Right
}

class BubbleView: UIView {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: BubbleView!
    @IBOutlet var messageLeftConstraint: NSLayoutConstraint!
    @IBOutlet var messageRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTailView: TailView!
    @IBOutlet weak var rightTailView: TailView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        messageView.backgroundColor = UIColor.blue
        messageView.layer.cornerRadius = 10.0
    }
    
    func configure() {
        Bundle.main.loadNibNamed("BubbleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.backgroundColor = UIColor.blue
        messageView.layer.cornerRadius = 10.0
        
    }
    
    func configureBubbleView(text: String, backgroundColor: UIColor, textColor: UIColor, bubbleAlignment: BubbleAlignment, showTail: Bool) {
        messageLabel.text = text
        
        messageView.backgroundColor = backgroundColor
        messageLabel.textColor = textColor
        
        messageLeftConstraint.isActive = bubbleAlignment == .Left
        messageRightConstraint.isActive = bubbleAlignment == .Right
        
        messageLabel.textAlignment = bubbleAlignment == .Left ? NSTextAlignment.left : NSTextAlignment.right
        
        rightTailView.isHidden = bubbleAlignment == .Left || !showTail
        leftTailView.isHidden = bubbleAlignment == .Right || !showTail
        
        rightTailView.color = backgroundColor
        leftTailView.color = backgroundColor
        
        rightTailView.setNeedsDisplay()
        leftTailView.setNeedsDisplay()
        
        leftTailView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    
}

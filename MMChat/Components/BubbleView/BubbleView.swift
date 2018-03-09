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
    @IBOutlet weak var messageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTailView: TailView!
    @IBOutlet weak var rightTailView: TailView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
    
    func configureBubbleView(text: String, backgroundColor: UIColor, textColor: UIColor, bubbleAlignment: BubbleAlignment) {
        messageLabel.text = text
        
        messageView.backgroundColor = backgroundColor
        messageLabel.textColor = textColor
        
        messageLeftConstraint.isActive = bubbleAlignment == .Left
        messageRightConstraint.isActive = bubbleAlignment == .Right
        
        messageLabel.textAlignment = bubbleAlignment == .Left ? NSTextAlignment.left : NSTextAlignment.right
        
        rightTailView.isHidden = bubbleAlignment == .Left
        leftTailView.isHidden = bubbleAlignment == .Right
        
        rightTailView.color = backgroundColor
        leftTailView.color = backgroundColor
        
        rightTailView.draw(rightTailView.frame)
         leftTailView.draw(leftTailView.frame)
        
        leftTailView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    
}

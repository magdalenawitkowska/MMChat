//
//  ChatViewController.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 10.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import UIKit
import InputBarAccessoryView

class ChatViewController: UITableViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        bar.inputTextView.textColor = MMChatColors.textGray
        bar.sendButton.title = "SEND"
        bar.sendButton.tintColor = MMChatColors.textGray
        bar.separatorLine.isHidden = true
        
        return bar
        }()
    
    override var inputAccessoryView: UIView? {
        return bar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    // MARK: - InputBarAccessoryViewDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        conversation.messages.append(SampleData.Message(user: SampleData.shared.currentUser, text: text))
//        inputBar.inputTextView.text = String()
//        let indexPath = IndexPath(row: conversation.messages.count - 1, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

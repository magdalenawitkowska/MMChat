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
import RxDataSources
import RxSwift
import RxCocoa

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


class ChatViewController: UITableViewController {
    
    var viewModel: ChatViewModel!
    var disposeBag: DisposeBag!
    var indexPathOfAppendedCell: IndexPath?
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        bar.inputTextView.textColor = MMChatColors.textGray
        bar.sendButton.title = "SEND"
        bar.sendButton.tintColor = MMChatColors.textGray
        bar.separatorLine.isHidden = true
        
        bar.inputTextView.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        
        return bar
        }()
    
    override var inputAccessoryView: UIView? {
        return bar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ChatViewModel()
        disposeBag = DisposeBag()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88.0
        
        self.tableView.scrollsToTop = false
        
        setUpBindings()
        
        self.title = "👩"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🔄", style: UIBarButtonItemStyle.plain, target: self, action: #selector(switchUser))
    }
    
    func setUpBindings() {
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { [unowned self] dataSource, tableView, indexPath, message in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell

                let bubbleColor = message.sentByMe ? MMChatColors.raspberryRed : MMChatColors.lightGray
                let bubbleTextColor = message.sentByMe ? UIColor.white : UIColor.black
                let align = message.sentByMe ? BubbleAlignment.Right : BubbleAlignment.Left
                
                cell.bubbleView.configureBubbleView(text: message.text, backgroundColor: bubbleColor, textColor: bubbleTextColor, bubbleAlignment: align, showTail: self.viewModel.messageShouldHaveTail(indexPath: indexPath))
                
                cell.layoutIfNeeded()
                
                cell.readLabel.text = message.displaySeen ? "✔️Read" : ""
                
                if let ip = self.indexPathOfAppendedCell, indexPath == ip {
                    cell.contentView.alpha = 0.0
                }
                
                return cell
        })
        

        //dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: UITableViewRowAnimation.automatic, reloadAnimation: UITableViewRowAnimation.automatic, deleteAnimation: UITableViewRowAnimation.automatic)
        
        viewModel.dataSource.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let text = viewModel.getHeaderOfSection(sectionNumber: section) {
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
            header.headerLabel.text = text
            return header
        } else {
            return UIView()
        }
    }
    
    @objc func switchUser() {
        self.title = viewModel.firstUserIsActive ? "👩" : "👨"
        viewModel.switchUser()
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    // MARK: - InputBarAccessoryViewDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        viewModel.appendNewMessage(text: text)
        
        inputBar.inputTextView.text = String()
        
        var lastSection = viewModel.dataSource.value.count - 1
        if var items = viewModel.dataSource.value[safe: lastSection] {
            var lastRow = items.items.count - 1
            var indexPath = IndexPath(row: lastRow, section: lastSection)
            indexPathOfAppendedCell = indexPath
            var cell = self.tableView.cellForRow(at: indexPath)
            cell?.contentView.alpha = 0.0
            
            DispatchQueue.main.async {
                
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                var cell = self.tableView.cellForRow(at: indexPath)
                self.animateBubbleView(indexPath: indexPath, fromMessage: self.viewModel.flatMessageArray.array.last!, toCellPosition: cell!.frame, completion: {
                    cell?.contentView.alpha = 1.0
                    self.indexPathOfAppendedCell = nil
                })
                
            }

        }
    }
    
    func animateBubbleView(indexPath: IndexPath, fromMessage: Message, toCellPosition: CGRect, completion: @escaping () -> ()) {
        var keyWindow = UIApplication.shared.keyWindow
        //var inputFrame = bar.convert(bar.inputTextView.frame, to: (view.window?.screen.fixedCoordinateSpace)!)
        var redView = BubbleView(frame: bar.frame)
        
        redView.backgroundColor = UIColor.clear
        
        redView.configureBubbleView(text: fromMessage.text, backgroundColor: MMChatColors.raspberryRed, textColor: UIColor.white, bubbleAlignment: BubbleAlignment.Right, showTail: viewModel.messageShouldHaveTail(indexPath: indexPath))
        
        redView.messageView.alpha = 0.0
        var newFrame = tableView.convert(toCellPosition, to: bar)
        
        bar.addSubview(redView)
        bar.bringSubview(toFront: redView)

        UIView.animate(withDuration: 0.6, animations: {
            redView.frame = newFrame
            redView.messageView.alpha = 1.0
        }) { completed in
            completion()
            redView.removeFromSuperview()
        }
        
        
    }
}

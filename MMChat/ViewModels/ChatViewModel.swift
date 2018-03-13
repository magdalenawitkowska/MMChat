//
//  ChatViewModel.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 10.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Bond

class ChatViewModel {
    
    let newSectionTimeInterval = 20.0 * 60 * 60
    let showTailTimeInterval = 20.0
    
    var idCount = 0
    var dataSource = Variable<([Section])>([])
    var dateFormatter = DateFormatter()
    var disposeBag = DisposeBag()
    var lastSeenMessageId = -1
    var flatMessageArray = MutableObservableArray<Message>()
    
    init() {
        setDateFormatter()
        observeFlatArrayChange()
    }
    
    func setDateFormatter() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.doesRelativeDateFormatting = true
    }

    
    /// Observing flat message array and apply changes to dataSource
    func observeFlatArrayChange() {
        flatMessageArray.observeNext { [unowned self] event in
            
            switch event.change {
            case .inserts(let indices):
                for index in indices {
                    let newMessage = self.flatMessageArray[index]
                    self.appendNewMessageToDataSource(newMessage: newMessage)
                    
                    self.changeDisplaySeenStatusMessageOfId(id: self.lastSeenMessageId, displaySeen: false)
                    self.lastSeenMessageId = -1
                    
                }
            case .updates(let indices):
                for index in indices {
                    var updatedMessage = self.flatMessageArray[index]
                    if updatedMessage.seen == true && updatedMessage.sentByMe && index == self.flatMessageArray.count - 1 {
                        self.changeDisplaySeenStatusMessageOfId(id: self.lastSeenMessageId, displaySeen: false)
                        updatedMessage.displaySeen = true
                        self.lastSeenMessageId = updatedMessage.id
                    }
                    self.changeMessage(updatedMessage: updatedMessage)
                }
            default:
                break
            }
        }
    }
    
    //MARK: - Functions changing data source
    
    /// Append new message to dataSource so it reflects message flat array
    ///
    /// - Parameter newMessage
    func appendNewMessageToDataSource(newMessage: Message) {
        let newSection = Section(header: self.dateFormatter.string(from: newMessage.date), items: [newMessage])
        if self.dataSource.value.count > 0 {
            if let lastMessage = self.getLastMessage() {
                if Date().timeIntervalSince(lastMessage.date) < newSectionTimeInterval {
                    self.dataSource.value[self.dataSource.value.count - 1].items.append(newMessage)
                    return
                }
            }
        }
        self.dataSource.value.append(newSection)
    }
    
    
    /// Reload message from dataSource
    ///
    /// - Parameter updatedMessage
    func changeMessage(updatedMessage: Message) {
        for i in (0 ... dataSource.value.count - 1).reversed() {
            for j in (0 ... dataSource.value[i].items.count - 1).reversed() {
                if dataSource.value[i].items[j].id == updatedMessage.id {
                    dataSource.value[i].items[j] = updatedMessage
                }
            }
        }
    }
    
    
    /// Apply display seen status change to data Source
    ///
    /// - Parameters:
    ///   - id
    ///   - displaySeen
    func changeDisplaySeenStatusMessageOfId(id: Int, displaySeen: Bool) {
        for i in (0 ... dataSource.value.count - 1).reversed() {
            for j in (0 ... dataSource.value[i].items.count - 1).reversed() {
                if dataSource.value[i].items[j].id == id {
                    dataSource.value[i].items[j].displaySeen = displaySeen
                }
            }
        }
    }
    
    //MARK: - Functions called from the view, changing flat message array
    
    /// Append new message to flat Array
    ///
    /// - Parameter text
    func appendNewMessage(text: String) {
        idCount += 1
        let newMessage = Message(text: text, sentByMe: true, date: Date(), id: idCount, seen: false, displaySeen: false)
        flatMessageArray.append(newMessage)
        
        let index = flatMessageArray.count - 1
        
        //New message is 'read' autmatically after 5 seconds
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [unowned self] _ in
            self.flatMessageArray[index].seen = true
        }
        
        //New message is 'echoed' autmatically after 10 seconds
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [unowned self] _ in
            self.idCount += 1
            let newMessage = Message(text: text, sentByMe: false, date: Date(), id: self.idCount, seen: false, displaySeen: false)
            self.flatMessageArray.append(newMessage)
        }
    }
    
    //MARK - Helpers
    
    
    /// Retrieve last message
    ///
    /// - Returns
    func getLastMessage() -> Message? {
         if let lastSection = dataSource.value.last, let lastMessage = lastSection.items.last {
            return lastMessage
        }
        return nil
    }

    
    /// Check if message should have tail (message was sent 20s or more after previous one)
    ///
    /// - Parameter indexPath
    /// - Returns
    func messageShouldHaveTail(indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        if let messages = dataSource.value[safe: section], let message = messages.items[safe: indexPath.row], let prevMessage = messages.items[safe: indexPath.row - 1] {
            
            if message.date.timeIntervalSince(prevMessage.date) < showTailTimeInterval && message.sentByMe == prevMessage.sentByMe {
                return false
            }
        }
        return true
    }
    
    
    /// Retrieve section header
    ///
    /// - Parameter sectionNumber
    /// - Returns
    func getHeaderOfSection(sectionNumber: Int) -> String? {
        if let section = dataSource.value[safe: sectionNumber] {
            return section.header
        }
        return nil
    }
}

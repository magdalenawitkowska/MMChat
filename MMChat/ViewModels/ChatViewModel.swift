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

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ChatViewModel {
    
    var idCount = 1
    var dataSource = Variable<([Section])>([])
    var dateFormatter = DateFormatter()
    var firstUserIsActive = true
    var disposeBag = DisposeBag()
    var lastSeenMessageId: Int?
    
    init() {
//        let message1 = Message(text: "Hey Mario!", sentByMe: true, date: Date(), id: 0)
//        let message2 = Message(text: "Hey Madziu!", sentByMe: false, date: Date(), id: 1)
//        let section = Section(header: "Today", items: [message1, message2])
//
//        dataSource.value = [section]
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.doesRelativeDateFormatting = true
    
    }
    
    func changeDisplaySeenStatusMessageOfId(id: Int, displaySeen: Bool) {
        for i in (0 ... dataSource.value.count - 1).reversed() {
            for j in (0 ... dataSource.value[i].items.count - 1).reversed() {
                if dataSource.value[i].items[j].id == id {
                    dataSource.value[i].items[j].displaySeen = displaySeen
                }
            }
        }
    }
    
    
    func appendNewMessage(text: String) {
        idCount += 1
        let newMessage = Message(text: text, sentByMe: true, date: Date(), id: idCount, seen: idCount % 2 == 0, displaySeen: false)
        let newSection = Section(header: dateFormatter.string(from: newMessage.date), items: [newMessage])
        if dataSource.value.count > 0 {
            if let lastMessage = getLastMessage() {
                if Date().timeIntervalSince(lastMessage.date) < 20 * 60 * 60 {
                    dataSource.value[dataSource.value.count - 1].items.append(newMessage)
                    return
                }
            }
        }
        dataSource.value.append(newSection)
        
        
        var timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
            self?.dataSource.value[0].items[(self?.dataSource.value[0].items.count)! - 1].seen = true
            
//            if let lastMessage = self?.getLastMessage() {
//                if lastMessage.sentByMe {
//                    self?.changeDisplaySeenStatusMessageOfId(id: lastMessage.id, displaySeen: true)
//                }
//            }
        }
    }
    
    func getLastMessage() -> Message? {
         if let lastSection = dataSource.value.last, let lastMessage = lastSection.items.last {
            return lastMessage
        }
        return nil
    }
    
    func switchUser() {
        firstUserIsActive = !firstUserIsActive
        
        for (sectionIndex, section) in dataSource.value.enumerated() {
            for var (index, row) in section.items.enumerated() {
                dataSource.value[sectionIndex].items[index].sentByMe = !row.sentByMe
            }
        }
    }
    
    func messageShouldHaveTail(indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        if let messages = dataSource.value[safe: section], let message = messages.items[safe: indexPath.row], let prevMessage = messages.items[safe: indexPath.row - 1] {
            
            if message.date.timeIntervalSince(prevMessage.date) < 20.0 && message.sentByMe == prevMessage.sentByMe {
                print(message.date.timeIntervalSince(prevMessage.date))
                return false
            }
        }
        return true
    }
    
    func getHeaderOfSection(sectionNumber: Int) -> String? {
        if let section = dataSource.value[safe: sectionNumber] {
            return section.header
        }
        return nil
    }
}

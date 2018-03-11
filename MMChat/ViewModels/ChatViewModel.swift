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
    
    init() {
        let message1 = Message(text: "Hey Mario!", sentByMe: true, date: Date(), id: 0)
        let message2 = Message(text: "Hey Madziu!", sentByMe: false, date: Date(), id: 1)
        let section = Section(header: "Today", items: [message1, message2])
        
        dataSource.value = [section]
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.doesRelativeDateFormatting = true
    }
    
    
    func appendNewMessage(text: String) {
        idCount += 1
        let newMessage = Message(text: text, sentByMe: true, date: Date(), id: idCount)
        dataSource.value[0].items.append(newMessage)
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
        if let section = dataSource.value[safe: sectionNumber], let firstMessage = section.items[safe: 0] {
            return dateFormatter.string(from: firstMessage.date)
        }
        return nil
    }
}

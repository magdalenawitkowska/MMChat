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
    
    init() {
        var message1 = Message(text: "Hey Mario!", sentByMe: true, date: Date(), id: 0)
        var message2 = Message(text: "Hey Madziu!", sentByMe: false, date: Date(), id: 1)
        
        var section = Section(header: "Today", items: [message1, message2])
        
        dataSource.value = [section]
    }
    
    
    func appendNewMessage(text: String) {
        idCount += 1
        var newMessage = Message(text: text, sentByMe: true, date: Date(), id: idCount)
        dataSource.value[0].items.append(newMessage)
    }
    
    func messageShouldHaveTail(indexPath: IndexPath) -> Bool {
        var section = indexPath.section
        if let messages = dataSource.value[safe: section], let message = messages.items[safe: indexPath.row], let prevMessage = messages.items[safe: indexPath.row - 1] {
            
            if message.date.timeIntervalSince(prevMessage.date) < 20.0 && message.sentByMe == prevMessage.sentByMe {
                print(message.date.timeIntervalSince(prevMessage.date))
                return false
            }
        }
        return true
    }
}

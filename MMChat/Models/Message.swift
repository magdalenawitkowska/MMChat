//
//  Message.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 10.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import RxDataSources

struct Message: IdentifiableType, Equatable {

    var text: String
    var sentByMe: Bool
    var date: Date
    var id: Int
    var seen: Bool
    var displaySeen: Bool
    
    typealias Identity = Int
    var identity : Identity { return id }
}

/// Function conforming to equatable protocol used to check if message object has changed
func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id && lhs.sentByMe == rhs.sentByMe && lhs.displaySeen == rhs.displaySeen
}

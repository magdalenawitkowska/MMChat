//
//  Section.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 10.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import RxDataSources

/// Section to represent elements of RxTableViewSectionedAnimatedDataSource
struct Section {
    var header: String
    var items: [Item]
}

extension Section: SectionModelType {
    
    typealias Item = Message
    
    var identity: String {
        return header
    }
    
    init(original: Section, items: [Message]) {
        self = original
        self.items = items
    }
}


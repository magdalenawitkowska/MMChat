//
//  Collection+SafeIndex.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 12.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//
//  DelegateList.swift
//  dvach
//
//  Created by Ruslan Timchenko on 19.01.2020.
//  Copyright © 2020 Kirill Solovyov. All rights reserved.
//

import Foundation

final class DelegateList<T>: Sequence {
    
    private let delegatesHashTable = NSHashTable<AnyObject>.weakObjects()
    
    func addDelegate(_ delegate: T) {
        delegatesHashTable.add(delegate as AnyObject)
    }
    
    func removeDelegate(_ delegate: T) {
        delegatesHashTable.remove(delegate as AnyObject)
    }
        
    // MARK: - Sequence
    
    public func makeIterator() -> Array<T>.Iterator {
        let delegates = delegatesHashTable.allObjects.compactMap { $0 as? T}
        return delegates.makeIterator()
    }
}

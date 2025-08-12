//
//  Observable.swift
//  ShoppingList
//
//  Created by YoungJin on 8/12/25.
//

import Foundation

final class Observable<T> {
    
    var value: T {
        didSet {
            print("didSet", oldValue, value)
            closure?(value)
        }
    }
    
    private var closure: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
        print("Obsevable Init")
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}

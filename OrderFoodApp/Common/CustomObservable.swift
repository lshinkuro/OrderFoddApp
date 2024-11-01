//
//  Observable.swift
//  OrderFoodApp
//
//  Created by Phincon on 23/10/24.
//

import Foundation

typealias VoidClosure = () -> Void
open class CustomObservable<T: Any> {
    private let thread: DispatchQueue
    
    public var observer: T? {
        willSet(newValue) {
            if let newValue = newValue {
                self.thread.async {
                    self.subscribe?(newValue)
                }
            }
        }
    }
    
    public var value: T? {
        return observer
    }
    
    public var subscribe: ((T?) -> ())?
    
    public init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
        self.thread = dispatcherThread
        self.observer = value
    }
}

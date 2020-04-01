//
//  Bindable.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet{
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
}

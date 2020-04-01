//
//  MyCollectionReusableView.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import UIKit

class MyCollectionReusableView: UICollectionReusableView {
        
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

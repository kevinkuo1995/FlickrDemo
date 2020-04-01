//
//  SearchData.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}

struct PhotoData: Decodable {
    let pages: Int
    let photo: [Photo]
}

struct SearchData: Decodable {
    let photos: PhotoData
}

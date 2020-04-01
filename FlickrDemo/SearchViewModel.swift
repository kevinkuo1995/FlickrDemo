//
//  SearchViewModel.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel {
    
    var bindableIsFormValid = Bindable<Bool>()
    
    var searchText: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var per_page: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    
    func checkFormValidity(){
        let isFormValid = searchText?.isEmpty == false && per_page?.isEmpty == false
        extractedFunc(isFormValid)
    }
    
    fileprivate func extractedFunc(_ isFormValid: Bool) {
        bindableIsFormValid.value = isFormValid
        
    }
    
    func downloadImage(url: URL, handler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                handler(image)
            } else {
                handler(nil)
            }
        }
        task.resume()
    }

    
    func downloadData(page: Int , completion: @escaping (SearchData?) -> ()) {
        
        let urlString = searchText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
        if let urlString = urlString, let per_page = per_page, let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c6dfba0732a584316e0a995683df68be&text=\(urlString)&per_page=\(per_page)&page=\(page)&format=json&nojsoncallback=1") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {
                    completion(searchData)
                }else {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
}

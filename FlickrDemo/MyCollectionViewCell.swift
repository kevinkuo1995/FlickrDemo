//
//  MyCollectionViewCell.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    var photo:Photo?
    
    var favoritePhoto:Dictionary<String, String>?
    
    var resultViewController: ResultViewController?
    
    var favoriteViewController: FavoriteViewController?
    
    let myImageView:UIImageView = {
       let miv = UIImageView()
        miv.contentMode = .scaleToFill
        miv.clipsToBounds = true
        return miv
    }()
    
    let myTextTitle:UILabel = {
        let mtt = UILabel()
        mtt.textAlignment = .center
        mtt.numberOfLines = 0
        mtt.font = .systemFont(ofSize: 12)
        return mtt
    }()
    
    let saveButton: UIButton = {
       let sb = UIButton()
        sb.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: frame.height * 2 / 3).isActive = true
        
        addSubview(myTextTitle)
        myTextTitle.translatesAutoresizingMaskIntoConstraints = false
        myTextTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myTextTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        myTextTitle.topAnchor.constraint(equalTo: myImageView.bottomAnchor).isActive = true
        myTextTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        saveButton.addTarget(self, action: #selector(saveToFavorite(button:)), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func saveToFavorite(button:UIButton) {
        print("save")
        print(photo?.title,favoritePhoto?["text"])
        
        if let photo = photo {
            self.resultViewController?.saveToLocal(photo: photo)
            print("result")
        }else if let favoritePhoto = favoritePhoto{
            self.favoriteViewController?.removeFavorite(favoritePhoto: favoritePhoto)
            print("favorite")
        }
    }
    
}

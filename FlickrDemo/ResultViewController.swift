//
//  ResultViewController.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var photos = [Photo]()
    
    var pagesCount = 1
    
    var pagesLimit:Int?

    let searchViewModel:SearchViewModel
    
    var favoriteList:Array<Dictionary<String, String>> = {
        var fl = [Dictionary<String, String>]()
        if let list = UserDefaults.standard.array(forKey: "list") as? [Dictionary<String, String>]{
            fl = list
            return fl
        }
        return fl
    }()
    
    lazy var myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
    
    lazy var layout:UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        l.minimumLineSpacing = 5
        
        l.itemSize = CGSize(width: CGFloat(view.frame.width)/2 - 10.0,height: CGFloat(view.frame.width)/2 - 10.0)
        
        l.headerReferenceSize = CGSize(width: view.frame.width, height: 40)
        
        l.footerReferenceSize = CGSize(width: view.frame.width, height: 40)
        return l
    }()
    
    
    init(searchViewModel:SearchViewModel) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.favoriteList)

        setupLayout()
        
        searchViewModel.downloadData(page: 1) { (data) in
            if let data = data {
                self.pagesLimit = data.photos.pages
                if self.photos.count == 0 {
                    self.photos = data.photos.photo
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                }else {
                    self.photos += data.photos.photo
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func setupLayout() {
        
        myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        myCollectionView.register(MyCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "myFooter")
        myCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "myHeader")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        view.addSubview(myCollectionView)
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        myCollectionView.backgroundColor = .white
        
        view.backgroundColor = .white
    }
    
    func saveToLocal(photo:Photo) {
        favoriteList.append(["title" : photo.title, "imageUrl": photo.imageUrl.absoluteString])
        UserDefaults.standard.set(self.favoriteList, forKey: "list")
        
        let vc = UIAlertController(title: "加到我的最愛囉", message: "可以在我的最愛分頁看到喔", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        vc.addAction(okAction)
        present(vc, animated: true, completion: nil)
    }

}

extension ResultViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.photo = photo
        cell.resultViewController = self
        cell.myTextTitle.text = photo.title
        searchViewModel.downloadImage(url: photo.imageUrl) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    cell.myImageView.image = image
                }
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = myCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myFooter", for: indexPath) as! MyCollectionReusableView
            
            return footerView
        }else {
            let headerView = myCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myHeader", for: indexPath) 
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == photos.count - 1 {
                if pagesCount < pagesLimit ?? 1000000 {
                    pagesCount += 1
                }else {
                    pagesCount = pagesLimit ?? 1000000
                }
                print(pagesCount,pagesLimit)
                searchViewModel.downloadData(page: pagesCount) { (data) in
                    if let data = data {
                        if self.photos.count == 0 {
                            self.photos = data.photos.photo
                            DispatchQueue.main.async {
                                self.myCollectionView.reloadData()
                            }
                        }else {
                            self.photos += data.photos.photo
                            DispatchQueue.main.async {
                                self.myCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.startAnimating()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.stopAnimating()
//        }
//    }
    
}

//extension UICollectionView {
//  func reloadDataSmoothly() {
//    UIView.setAnimationsEnabled(false)
//    CATransaction.begin()
//
//    CATransaction.setCompletionBlock { () -> Void in
//      UIView.setAnimationsEnabled(true)
//    }
//
//    reloadData()
//
//    CATransaction.commit()
//  }
//}

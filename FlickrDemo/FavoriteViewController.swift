//
//  FavoriteViewController.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    var favoriteList = [Dictionary<String, String>]()
    
    let searchViewModel = SearchViewModel()
    
    lazy var myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
    
    lazy var layout:UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        l.minimumLineSpacing = 5
        
        l.itemSize = CGSize(width: CGFloat(view.frame.width)/2 - 10.0,height: CGFloat(view.frame.width)/2 - 10.0)
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let list = UserDefaults.standard.array(forKey: "list") as? [Dictionary<String, String>] {
            favoriteList = list
        }
        print(self.favoriteList)

        
        myCollectionView.reloadData()
    }
    
    fileprivate func setupLayout() {
        
        myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "myFavoriteCell")
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func removeFavorite(favoritePhoto: Dictionary<String, String>) {
        if let index = favoriteList.firstIndex(where: { $0["imageUrl"] == favoritePhoto["imageUrl"]
        }){
            favoriteList.remove(at: index)
            UserDefaults.standard.set(favoriteList, forKey: "list")
            myCollectionView.reloadData()
            
            let vc = UIAlertController(title: "移除我的最愛", message: "已經從我的最愛移除囉", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            vc.addAction(okAction)
            present(vc, animated: true, completion: nil)
        }
    }
        
}

extension FavoriteViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myFavoriteCell", for: indexPath) as! MyCollectionViewCell
        
        let photo = favoriteList[indexPath.row]
        cell.myTextTitle.text = photo["title"]
        cell.favoriteViewController = self
        cell.favoritePhoto = photo
        
        if let urlString =  photo["imageUrl"] , let url = URL(string: urlString){
            searchViewModel.downloadImage(url: url) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.myImageView.image = image
                    }
                }
            }
        }
        
        
        return cell
    }
    
    
}

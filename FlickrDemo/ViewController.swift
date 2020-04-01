//
//  ViewController.swift
//  FlickrDemo
//
//  Created by KUO Chin Wei on 2020/3/31.
//  Copyright © 2020 KUO Chin Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let searchViewModel = SearchViewModel()
    
    let searchTextField: UITextField = {
        let stf = UITextField()
        stf.placeholder = "輸入關鍵字"
        stf.textAlignment = .center
        stf.layer.borderWidth = 1
        stf.layer.borderColor = UIColor.black.cgColor
        stf.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        return stf
    }()
    
    let per_pageTextField: UITextField = {
        let ptf = UITextField()
        ptf.placeholder = "輸入數量(上限500)"
        ptf.keyboardType = .numberPad
        ptf.textAlignment = .center
        ptf.layer.borderWidth = 1
        ptf.layer.borderColor = UIColor.black.cgColor
        ptf.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        return ptf
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("搜尋圖片", for: .normal)
        button.setTitleColor(#colorLiteral(red: 246/255, green: 243/255, blue: 241/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .gray
        button.setTitleColor(.lightGray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchViewModel.bindableIsFormValid.bind { (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.searchButton.isEnabled = isFormValid
            self.searchButton.backgroundColor = isFormValid ? .black : .gray
        }
        
        setupLayout()
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == searchTextField {
            searchViewModel.searchText = textField.text
            print(searchViewModel.searchText as Any)
        }else {
            searchViewModel.per_page = textField.text
        }
    }
    
    @objc fileprivate func handleSearch() {
        if searchViewModel.searchText?.isBlank != true {
            let resultController = ResultViewController(searchViewModel: self.searchViewModel)
            navigationController?.pushViewController(resultController, animated: true)
        }
    }
    
    fileprivate func setupLayout() {
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3 ).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true

        
        view.addSubview(per_pageTextField)
        per_pageTextField.translatesAutoresizingMaskIntoConstraints = false
        per_pageTextField.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor).isActive = true
        per_pageTextField.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor).isActive = true
        per_pageTextField.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40).isActive = true
        per_pageTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: per_pageTextField.bottomAnchor, constant: 40).isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension String {
    var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
}

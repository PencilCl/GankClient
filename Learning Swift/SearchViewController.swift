//
//  SearchViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 16/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController: UISearchController! = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "搜索真的好了！不骗你！"
        searchBar.tintColor = UIColor.tintColor
        searchBar.barTintColor = UIColor.backgroundColor
        searchBar.backgroundColor = UIColor.white
        // 设置borderWidth和color隐藏黑线条
        // borderWidth = 0将使得borderColor属性失效
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.backgroundColor.cgColor
        searchBar.sizeToFit()
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        // 在Storyboard设置header将不能固定header，设置tableHeaderView可以让header不滚动
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.isActive = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        searchController.searchResultsUpdater = nil
        searchController.isActive = false
        searchController.searchBar.delegate = nil
        log.debug("deinit: \(type(of: self))")
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        log.debug("search text: \(searchController.searchBar.text!)")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GankData", for: indexPath)
        return cell
    }
}

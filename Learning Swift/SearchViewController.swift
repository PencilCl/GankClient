//
//  SearchViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 16/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var loadMore = true
    var isFetching = false
    var page = 1
    var searchResult = [Gank]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var i = 5
    
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
        searchController.searchBar.delegate = self
        // 在Storyboard设置header将不能固定header，设置tableHeaderView可以让header不滚动
        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        bindSearchBar()
    }
    
    private func bindSearchBar() {
        searchController.searchBar.rx.text.orEmpty
        .throttle(1, scheduler: MainScheduler.asyncInstance)
        .distinctUntilChanged()
        .flatMapLatest { [weak self] query -> Observable<[Gank]> in
            Observable.create({ observer -> Disposable in
                self?.page = 1
                self?.loadMore = true
                self?.isFetching = false
                if query.isEmpty {
                    self?.searchResult.removeAll()
                    self?.loadMore = false
                } else {
                    GankService.search(content: query, page: 1, { (ganks, error) in
                        if let error = error {
                            log.error("search error \(error)")
                        }
                        observer.onNext(ganks)
                    })
                }
                return Disposables.create { }
            })
        }
        .observeOn(MainScheduler.instance)
        .subscribe { [weak self] event in
            if let ganks = event.element {
                self?.searchResult = ganks
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.tableHeaderView = searchController.searchBar
        navigationController?.setNavigationBarHidden(true, animated: true)
        log.debug("view will appear")
        searchController.isActive = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.tableHeaderView = searchController.searchBar
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        searchController.searchResultsUpdater = nil
        searchController.isActive = false
        searchController.searchBar.delegate = nil
        log.debug("deinit: \(type(of: self))")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "GankDetail":
                if let gankCV = segue.destination as? WebViewController,
                    let url = sender as? String {
                    gankCV.url = URL(string: url)!
                }
            default:
                break
            }
        }
    }
    
    func fetchMoreSearchResult() {
        if !loadMore || isFetching {
            return
        }
        isFetching = true
        
        let searchContent = searchController.searchBar.text!
        GankService.search(content: searchContent, page: page) { [weak self] (ganks, error) in
            guard let text = self?.searchController.searchBar.text,
                text == searchContent else {
                return
            }
            
            self?.isFetching = false
            if let error = error {
                log.error("search error \(error)")
                return
            }
            
            if ganks.count < REQUEST_NUMS {
                self?.loadMore = false
            }
                
            self?.searchResult += ganks
            self?.tableView.reloadData()
        }
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
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GankData", for: indexPath) as! GankTableViewCell
        cell.gank = searchResult[indexPath.row]
        
        if indexPath.row == searchResult.count - 1 {
            fetchMoreSearchResult()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let gank = searchResult[indexPath.row]
        let url = gank.url!
        
        if let category = Category(rawValue: gank.type!),
            category == Category.meizi {
            present(PhotoBrowser.photoBrowserController(url: url), animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "GankDetail", sender: url)
        }
    }
}

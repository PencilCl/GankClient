//
//  TodayViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class TodayViewController: UIViewController {
    var categoryPos: [Int: Category] = [:]
    
    var data: [Category: [Gank]] = [:] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    var imageUrl: String? {
        didSet {
            if let url = imageUrl {
                log.debug(url)
                imageView.setImage(url: url) { [weak self] in
                    guard self != nil else { return }
                    // 更新tableHeaderView和tableView的高度
                    let tableView = self!.tableView!
                    let tableHeaderView = self!.tableHeaderView!
                    
                    let tableViewContentSize = tableView.contentSize
                    let originHeaderHeight = tableHeaderView.frame.height
                    
                    let imageSize = self!.imageView.image!.size
                    let headerHeight = imageSize.height * SCREEN_WIDTH / imageSize.width + 46
                    tableHeaderView.frame.size = CGSize(width: tableHeaderView.frame.width, height: headerHeight)
                    let offset = headerHeight - originHeaderHeight
                    tableView.contentSize = CGSize(width: tableViewContentSize.width, height: tableViewContentSize.height + offset)
                    
                    // 使用reloadData方法刷新视图 (layoutIfNeeded无效)
                    // 否则视图tableHeaderView将会挡住数据
                    tableView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage)))
        
        updateDateLabel()
        
        updateData()
    }
    
    private func updateData() {
        GankService.fetchLatestData { [weak self] (ganks, error) in
            if self == nil { return }
            
            if error != nil {
                self?.handleGankError(error!)
                return
            }
            
            self?.handleGanksData(ganks)
        }
    }
    
    private func updateData(date: Date) {
        GankService.getSomedayData(date: date) { [weak self] (ganks) in
            self?.handleGanksData(ganks)
        }
    }
    
    /*
     处理Gank数组数据
     1. 将其转换为[Category: [Gank]]格式
     2. 获取image url
     3. 更新日期
     */
    private func handleGanksData(_ ganks: [Gank]) {
        if ganks.count == 0 {
            return
        }
        
        updateDateLabel(date: ganks.first!.publishedAt! as Date)
        
        var data = self.data
        var categoryPos = self.categoryPos
        data.removeAll()
        categoryPos.removeAll()
        var indexCategory: [Category: Int] = [:]
        
        for i in 0..<ganks.count {
            let gank = ganks[i]
            if let category = Category(rawValue: gank.type!) {
                if category == .meizi {
                    self.imageUrl = gank.url!
                    continue
                }
                if let index = indexCategory[category] {
                    data[categoryPos[index]!]!.append(gank)
                } else {
                    indexCategory[category] = categoryPos.count
                    categoryPos[categoryPos.count] = category
                    data[category] = [gank]
                }
            }
        }
        
        self.categoryPos = categoryPos
        self.data = data
    }
    
    /*
     更新日期信息
     */
    private func updateDateLabel(date: Date = Date()) {
        let components = Calendar.current.dateComponents([.day, .month], from: date)
        monthLabel.text = "\(components.month!)月"
        dayLabel.text = "\(components.day!)"
    }
    
    private func handleGankError(_ error: GankError) {
        switch error {
        case .requestError:
            log.error("请求失败")
        case .unkownError:
            log.error("未知错误")
        }
    }
    
    @objc func showImage() {
        var images = [SKPhoto]()
        if let image = imageView.image {
            let photo = SKPhoto.photoWithImage(image)
            images.append(photo)
        } else if let url = imageUrl {
            let photo = SKPhoto.photoWithImageURL(url)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        } else {
            log.debug("没有图片可以显示")
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "GankDetail":
                if let gankCV = segue.destination as? WebViewController,
                    let url = sender as? String {
                    gankCV.url = URL(string: url)!
                }
            case "History":
                if let cV = segue.destination as? CalendarViewController {
                    cV.chosenDate = { [weak self] date in
                        self?.updateData(date: date)
                    }
                }
            default:
                break
            }
        }
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = categoryPos[section],
            let count = data[category]?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeader"),
            let header = cell as? HeaderTableViewCell,
            let category = categoryPos[section] {
            header.title = category.rawValue
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GankData", for: indexPath) as! GankTableViewCell
        
        let gank = data[categoryPos[indexPath.section]!]![indexPath.row]
        cell.showTypeLabel = false
        cell.gank = gank
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let gank = data[categoryPos[indexPath.section]!]![indexPath.row]
        
        performSegue(withIdentifier: "GankDetail", sender: gank.url!)
    }
}

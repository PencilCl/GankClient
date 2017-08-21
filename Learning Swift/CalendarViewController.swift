//
//  CalendarViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 16/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    fileprivate var historyDates = [Date]()
    
    // 回调函数
    var chosenDate: (_ date: Date) -> Void = { _ in  }
    var scrollToDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { [weak self] visibleDates in
            self?.calendarView.scrollToDate(self?.scrollToDate ?? Date(), animateScroll: false)
            self?.handleMonthChanged(visibleDates: visibleDates)
        }
        
        updateHistoryDate();
    }
    
    private func updateHistoryDate() {
        GankService.getHistory { [weak self] dates in
            self?.historyDates = dates
            self?.calendarView.reloadData()
        }
    }
    
    func handleCellState(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCollectionViewCell else { return }

        if historyDates.contains(cellState.date) {
            validCell.selectedBg.isHidden = false
            validCell.dateLabel.textColor = UIColor.white
        } else {
            validCell.selectedBg.isHidden = true
            validCell.dateLabel.textColor = UIColor.black
            if cellState.dateBelongsTo != .thisMonth {
                validCell.dateLabel.textColor = UIColor.lightGray
            }
        }
        
    }
    
    func handleMonthChanged(visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "YYYY"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        monthLabel.text = formatter.string(from: date).toChineseMonth
    }
    
    deinit {
        log.debug("deinit: \(type(of: self))")
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2015 05 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: Date())
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate  {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        
        handleCellState(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if historyDates.contains(cellState.date) {
            // 查看历史干货数据
            log.debug("select date: \(date.toString())")
            chosenDate(date)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleMonthChanged(visibleDates: visibleDates)
    }
}

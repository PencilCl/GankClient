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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { [weak self] visibleDates in
            self?.handleMonthChanged(visibleDates: visibleDates)
        }
    }
    
    func handleCellState(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCollectionViewCell else { return }
        
        if validCell.isSelected {
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
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
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
        handleCellState(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellState(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleMonthChanged(visibleDates: visibleDates)
    }
}

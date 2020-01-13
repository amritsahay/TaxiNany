//
//  RatingVC.swift
//  TaxiNanny
//
//  Created by ip-d on 22/07/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import JTAppleCalendar

class RatingVC: UIViewController {
    @IBOutlet weak var calendarview: JTAppleCalendarView!
    @IBOutlet weak var year : UILabel!
    @IBOutlet weak var month : UILabel!
    
    @IBAction func previous(_ sender: Any) {
        self.calendarview.scrollToSegment(.previous)
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarview.scrollToSegment(.next)
    }
    
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalender()
        self.calendarview.scrollToDate(Date(),animateScroll:false)
        // self.calendarview.selectDates([Date()])
        // Do any additional setup after loading the view.
    }
    func setupCalender(){
        calendarview.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState)  {
        guard let validcell = view as? CalendarCollectionViewCell else {return}
        if cellState.isSelected{
            
            validcell.date_label.textColor = UIColor.blue
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validcell.date_label.textColor = UIColor.black
            }else{
                validcell.date_label.textColor = UIColor.gray
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState)  {
        guard let validcell = view as? CalendarCollectionViewCell else {return}
        if cellState.isSelected{
            validcell.dateview.isHidden = false
        }else{
            validcell.dateview.isHidden = true
        }
    }

}

extension RatingVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var startDate = Date()
        var endDate = Date()
        if let calendarStartDate = formatter.date(from: "01 01 18"),
            let calendarEndndDate = formatter.date(from: "31 12 20") {
            startDate = calendarStartDate
            endDate = calendarEndndDate
        }
        parameters = ConfigurationParameters(startDate: startDate,
                                             endDate: endDate,
                                             calendar:Calendar.current,
                                             generateInDates: .forAllMonths,
                                             generateOutDates: .tillEndOfRow,
                                             firstDayOfWeek: .sunday,
                                             hasStrictBoundaries: true)
        return parameters
    }
}

extension RatingVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCollectionViewCell
        cell.date_label.text = cellState.text
    }
    
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.date_label.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        formatter.dateFormat = "dd MMMM yyyy"
       
        //  updateDateDetailLabel(date: date)
        // loadAppointmentsForDate(date: date)
        
        // calendarViewDateChanged()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        //        let date = visibleDates.monthDates.first!.date
        //        formatter.dateFormat = "yyyy"
        //        year.text = formatter.string(from: date)
        //        formatter.dateFormat = "MMMM"
        //        month.text = formatter.string(from: date)
        //        if appointmentScrolled {
        //            setupViewsFromCalendar(from: visibleDates)
        //        }
    }
}

//
//  ViewController.swift
//  kitbykirti
//
//  Created by Appy on 10/02/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit
import VACalendar
import Firebase

class CalenderViewController: UIViewController {
    // MARK: Constants
    let noteToNoteslist = "NoteToNoteslist"
    let noteToMonthlylist = "NoteToMonthlylist"
    let noteToWeeklist = "NoteToWeeklist"
    let noteToDaylist = "NoteToDaylist"
    
    @IBOutlet weak var monthsImgView: UIImageView!
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL YYYY"
            
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                dateFormatter: dateFormatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
            monthHeaderView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
            
        }
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    var calendarView: VACalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.monthDelegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.setSupplementaries([
            (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
            (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
        ])
        view.addSubview(calendarView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height * 0.6
            )
            calendarView.setup()
        }
    }
    
    @IBAction func changeMode(_ sender: Any) {
        calendarView.changeViewType()
    }
    
    // MARK: Actions
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    // MARK: Button Actions
    @IBAction func allButtonDidTouch(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            performSegue(withIdentifier: noteToDaylist, sender: sender)
            break
        case 101:
            performSegue(withIdentifier: noteToWeeklist, sender: sender)
            break
        case 102:
            performSegue(withIdentifier: noteToMonthlylist, sender: sender)
            break
        default:
            performSegue(withIdentifier: noteToNoteslist, sender: sender)
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == noteToDaylist{
            //var vc = segue.destination as! DayListTableVC
            //vc.data = "Data you want to pass"
        }
    }
    
    
}

extension CalenderViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension CalenderViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension CalenderViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension CalenderViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        UserDefaults.standard.set(dateFormatter.string(from: calendarView.startDate).lowercased(), forKey: "MONTHNAME")
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        UserDefaults.standard.set(dateFormatter1.string(from: calendarView.startDate).lowercased(), forKey: "DAYNAME")
        print(dates)
    }
    
}
extension CalenderViewController: VACalendarMonthDelegate {
    func monthDidChange(_ currentMonth: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        UserDefaults.standard.set(dateFormatter.string(from: currentMonth).lowercased(), forKey: "MONTHNAME")
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        UserDefaults.standard.set(dateFormatter1.string(from: currentMonth).lowercased(), forKey: "DAYNAME")
        
        let monthImgName = "\(dateFormatter.string(from: currentMonth).lowercased())month"
        self.monthsImgView.image = UIImage.init(named: monthImgName)
    }
}


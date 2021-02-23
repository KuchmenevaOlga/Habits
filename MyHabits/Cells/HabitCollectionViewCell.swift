//
//  HabitTableViewCell.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 05.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    private var habit: Habit?
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.toAutoLayout()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray2
        label.toAutoLayout()
        return label
    }()
    
    private let timesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.toAutoLayout()
        return label
    }()
    
    private var doneView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 3
        view.clipsToBounds = true
        return view
    }()
    
    private let checkView: UIImageView = {
        let view = UIImageView()
        view.toAutoLayout()
        view.layer.cornerRadius = 18
        view.image = UIImage(systemName: "checkmark.circle.fill")
        view.isHidden = true
        return view
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
       
        let tapDoneView = UITapGestureRecognizer(target: self, action: #selector(doneHabitToday))
        doneView.addGestureRecognizer(tapDoneView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
  
    var updateData: () -> Void = {}
    
    private lazy var calendar: Calendar = .current
    
    func configure(habit: Habit, update: @escaping () -> Void) {
        updateData = update
        
        self.habit = habit
        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        dateLabel.text = habit.dateString
        doneView.layer.borderColor = habit.color.cgColor
        checkView.tintColor = habit.color
        if habit.isAlreadyTakenToday {
            addCheckOnView()
        } else {
            checkView.isHidden = true
        }
        timesLabel.text = "Подряд: \(times(habit: habit))"
    }
 
    func times(habit: Habit) -> Int {
        var countDays = 0
        let habitsDate = habit.trackDates.reversed()
        var lastDay = NSDate()  as Date
        if !habit.isAlreadyTakenToday {
            lastDay = NSDate() as Date - (60*60*24) //дни подряд могут считаться и от предыдущего дня, если сегодня еще незатрекана привычка
        }
        var lastTrackDateDay = dayOfDate(date: lastDay) ?? 32 //32-несуществующий день
        
        for date in habitsDate{
            if let trackDateDay = dayOfDate(date: date){
                if trackDateDay == lastTrackDateDay{
                    countDays += 1
                    lastDay = lastDay as Date - (60*60*24) //берем следующий предыдущий день
                    lastTrackDateDay = dayOfDate(date: lastDay) ?? 32
                } else {
                    return countDays
                }
            }
        }
        return countDays
    }
    func dayOfDate(date: Date) -> Int? {
        calendar.dateComponents([.day], from: date).day
    }
    
    @objc func doneHabitToday() {
        if habit!.isAlreadyTakenToday {
            return
        }
        addCheckOnView()
        HabitsStore.shared.track(habit!)
        updateData()
    }
    
    func addCheckOnView() {
        checkView.isHidden = false
    }
    
}

extension HabitCollectionViewCell{
    
    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(timesLabel)
        contentView.addSubview(doneView)
        doneView.addSubview(checkView)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }
        
        timesLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().inset(20)
        }
        
        doneView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        checkView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

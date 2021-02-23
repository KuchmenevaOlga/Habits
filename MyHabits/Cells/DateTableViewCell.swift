//
//  DateTableViewCell.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 10.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        return label
    }()
    
    private let checkTimeView: UIImageView = {
        let view = UIImageView()
        view.toAutoLayout()
        view.image = UIImage(systemName: "checkmark")
        view.tintColor = UIColor(named: "purple")
        view.isHidden = true
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(index: Int, habit: Habit) {
        let date = HabitsStore.shared.dates[index]
        timeLabel.text = HabitsStore.shared.trackDateString(forIndex: index)
        checkTimeView.isHidden = !HabitsStore.shared.habit(habit, isTrackedIn: date)
    }
}

extension DateTableViewCell {
    private func setupLayout() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(checkTimeView)

        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        checkTimeView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(12)
        }
    }
}

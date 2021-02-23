//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 04.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit
import SnapKit

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {

    private var timeDefault: String
    private var habit: Habit?
    private var actionHabit: ActionWithHabit
    private var owner: UIViewController?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.toAutoLayout()
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "название"
        return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.toAutoLayout()
        textField.textColor = UIColor(named: "blue")
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return textField
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "цвет"
        return label
    }()
    
    private var colorView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.backgroundColor = UIColor(named: "orange")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let timeNameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "время"
        return label
    }()
    
    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Каждый день в "
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = UIColor(named: "purple")
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let timeDatePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .time
        date.preferredDatePickerStyle = .wheels
        date.toAutoLayout()
        return date
    }()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    private lazy var deleteHabitLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Удалить привычку"
        label.isUserInteractionEnabled = true
        if actionHabit == .create {
            label.isHidden = true
        } else {
            label.isHidden = false
        }
        return label
    }()
    
    init(habit: Habit, owner: UIViewController) {
        self.habit = habit
        actionHabit = .edit
        self.timeDefault = formatter.string(from: habit.date)
        self.colorView.backgroundColor = habit.color
        self.nameTextField.text = habit.name
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.actionHabit = .create
        self.timeDefault = "11:00 PM"
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        timeLabel.text = timeDefault
       
        if let date = formatter.date(from: timeDefault) {
            timeDatePicker.date = date
        }
        timeDatePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
     
        nameTextField.addTarget(self, action:  #selector(checkName), for: .editingChanged)
        
        let tapColorView = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        colorView.addGestureRecognizer(tapColorView)
        
        let tapDeleteHabit = UITapGestureRecognizer(target: self, action: #selector(deleteHabit))
        deleteHabitLabel.addGestureRecognizer(tapDeleteHabit)
        
        setupLayout()
    }
    
    func setNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = actionHabit == .create ? "Создать" : "Править"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelCreateHabit))
        
        navBar.tintColor = UIColor(named: "purple")
        checkName()
    }
    
    @objc func timeChanged() {
        timeDefault = formatter.string(from: timeDatePicker.date)
        timeLabel.text = timeDefault
    }
    
    @objc func checkName() {
        self.navigationItem.rightBarButtonItem?.isEnabled = nameTextField.text?.isEmpty == false
    }
    
    @objc func changeColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    @objc func saveHabit() {
        guard let nameHabit = nameTextField.text else { return }
        let store = HabitsStore.shared
        if actionHabit == .create {
            let newHabit = Habit(name: nameHabit,
                                    date: timeDatePicker.date,
                                    color: colorView.backgroundColor ?? .red)
            store.habits.append(newHabit)
        } else {
            if let oldHabit = habit {
                oldHabit.name = nameHabit
                oldHabit.date = timeDatePicker.date
                oldHabit.color = colorView.backgroundColor ?? .red
            }
            store.save()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelCreateHabit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteHabit() {
        guard let habitForDelete = self.habit else {
            return
        }
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habitForDelete.name)?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            if let index = HabitsStore.shared.habits.firstIndex(of: habitForDelete) {
                HabitsStore.shared.habits.remove(at: index)
                if let ownerController = self.owner {
                    ownerController.navigationController?.popViewController(animated: false)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HabitViewController {
    
    func setupLayout() {
        view.addSubview(stackView)
        stackView.addSubview(nameLabel)
        stackView.addSubview(nameTextField)
        stackView.addSubview(colorLabel)
        stackView.addSubview(colorView)
        stackView.addSubview(timeNameLabel)
        stackView.addSubview(everyDayLabel)
        stackView.addSubview(timeLabel)
        view.addSubview(timeDatePicker)
        view.addSubview(deleteHabitLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
//            make.bottom.equalTo(view.safeAreaInsets.top).inset(200)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
//            make.leading.equalToSuperview()
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview()
        }

        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview()
        }

        colorView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        timeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(colorView.snp.bottom).offset(15)
            make.leading.equalToSuperview()
        }

        everyDayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeNameLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(everyDayLabel.snp.centerY)
            make.leading.equalTo(everyDayLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-15)
        }

        timeDatePicker.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.width.equalToSuperview()
        }

        deleteHabitLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
}

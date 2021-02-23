//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 08.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    private var habit: Habit?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: String(describing: DateTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(habit: Habit) {
        super.init(nibName: nil, bundle: nil)
        self.habit = habit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = habit?.name
    }
    
    @objc func editHabit()  {
        guard let habitEdit = habit else {
            return
        }
        let habitViewController = HabitViewController(habit: habitEdit, owner: self)
        let navController = UINavigationController(rootViewController: habitViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

extension HabitDetailsViewController {
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = false
        navBar.prefersLargeTitles = false
        navBar.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editHabit))
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DateTableViewCell.self), for: indexPath) as! DateTableViewCell
        print(HabitsStore.shared.dates.count)
        cell.configure(index: HabitsStore.shared.dates.count - 1 - indexPath.row, habit: habit!)
        return cell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}

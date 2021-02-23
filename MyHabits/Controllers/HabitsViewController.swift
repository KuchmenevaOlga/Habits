//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 03.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit
import SnapKit

class HabitsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        
        collectionView.toAutoLayout()
        collectionView.backgroundColor = UIColor(named: "white")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        setupNavigationBar()
    }
    
    @objc func addHabit() {
        let habitViewController = HabitViewController()
        let navController = UINavigationController(rootViewController: habitViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

extension HabitsViewController {
    func setupNavigationBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = false
        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "Сегодня"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addHabit))
        
    }
    
    private func setupLayout(){
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16*2)
        if indexPath.row == 0 {
            return CGSize(width: width, height: 60)
        } else {
            return CGSize(width: width, height: 130)
        }
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cellProgress: ProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),for: indexPath) as! ProgressCollectionViewCell
            cellProgress.configure(progress: HabitsStore.shared.todayProgress)
            return cellProgress
        } else {
            let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self),for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.row - 1]

            cell.configure(habit: habit, update: {collectionView.reloadData()})
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
        collectionView.deselectItem(at: indexPath, animated: true)
        let habit = HabitsStore.shared.habits[indexPath.row - 1]
        let habitDetailsViewController = HabitDetailsViewController(habit: habit)
        self.navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
    }
}

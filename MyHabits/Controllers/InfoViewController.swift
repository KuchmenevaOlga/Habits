//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 03.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let infoTitleLabel: UILabel = {
        let view = UILabel()
        view.text = Information.heading
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        view.toAutoLayout()
        return view
    }()
    
    private let infoTextLabel: UILabel = {
        let view = UILabel()
        view.text  =  Information.info
        view.textColor = .black
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.toAutoLayout()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(infoTitleLabel)
        scrollView.addSubview(infoTextLabel)
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().inset(16)
        }
        
        infoTextLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(-16)
            make.width.equalTo(view.frame.width - 32)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

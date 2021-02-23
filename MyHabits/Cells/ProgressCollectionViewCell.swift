//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 05.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()

    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.toAutoLayout()
        view.tintColor = UIColor(named: "purple")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
       
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    func configure(progress: Float) {
        if progress ==  1 {
            statusLabel.text = "Молодец, на сегодня все!"
        } else {
            statusLabel.text = "Все получится!"
        }
        percentLabel.text = "\(String(format:"%.f", progress * 100))%"
        progressView.progress = progress
    }
}
 
extension ProgressCollectionViewCell {
    private func setupLayout() {
        contentView.addSubview(statusLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(progressView)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().inset(12)
        }
        
        percentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(statusLabel.snp.centerY).inset(4)
            make.trailing.equalToSuperview().inset(12)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}

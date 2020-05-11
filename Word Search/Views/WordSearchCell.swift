//
//  WordSearchCell.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-09.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import UIKit

class WordSearchCell: UICollectionViewCell {
    
    var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = .center
        contentView.addSubview(titleLabel!)
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        titleLabel?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        titleLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

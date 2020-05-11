//
//  ListTableViewCell.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-11.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    private var lineView: UIView?
    var showLine: Bool = false {
        didSet {
            if showLine {
                lineView?.isHidden = false
            }else{
                lineView?.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lineView = UIView(frame: CGRect.zero)
        lineView?.backgroundColor = UIColor.red
        lineView?.isHidden = true
        lineView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lineView!)
    
        lineView?.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        lineView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        lineView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0).isActive = true
        lineView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

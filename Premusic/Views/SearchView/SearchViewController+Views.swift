//
//  SearchViewController+Views.swift
//  Premusic
//
//  Created by 林達也 on 2017/10/02.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit

extension SearchViewController {
    final class Cell: UITableViewCell {
        let artworkImageView = UIImageView()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

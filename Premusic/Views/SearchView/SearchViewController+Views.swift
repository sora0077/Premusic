//
//  SearchViewController+Views.swift
//  Premusic
//
//  Created by 林達也 on 2017/10/02.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AutolayoutHelper
import PINRemoteImage

extension SearchViewController {
    final class Cell: UICollectionViewCell {
        let artworkImageView = UIImageView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            contentView.addSubview(artworkImageView)
            artworkImageView.autolayout.edges.equal(to: contentView.autoresizing.edges)

            clipsToBounds = true
            artworkImageView.contentMode = .scaleAspectFill
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            artworkImageView.pin_cancelImageDownload()
            artworkImageView.image = nil
        }
    }
}

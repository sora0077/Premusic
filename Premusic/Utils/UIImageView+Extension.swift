//
//  UIImageView+Extension.swift
//  Premusic
//
//  Created by 林達也 on 2017/09/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import PINRemoteImage
import PremusicCore

extension UIImageView {
    func setImage(with artwork: Entity.Artwork?, size: CGFloat) {
        pin_setImage(from: artwork?.url(size: Int(ceil(size * UIScreen.main.scale))))
    }
}

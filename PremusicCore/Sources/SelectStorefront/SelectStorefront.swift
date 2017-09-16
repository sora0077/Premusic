//
//  SelectStorefront.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/13.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct SelectStorefront {}

public protocol Presenter {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

public extension Presenter {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

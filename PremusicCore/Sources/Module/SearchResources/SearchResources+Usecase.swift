//
//  SearchResources+Usecase.swift
//  PremusicCore
//
//  Created by 林 達也 on 2017/09/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Module.SearchResources {
    final class Usecase {
        let repos: (search: SearchRepositoryImpl, dummy: Int)
        
        init() throws {
            let storefront = StorefrontRepositoryImpl()
            storefront.
        }
        
    }
}

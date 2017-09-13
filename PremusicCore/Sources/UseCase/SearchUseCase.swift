//
//  SearchUseCase.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/09.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

struct UseCase {}

extension UseCase {
    final class Search {
        let repos = (search: SearchRepositoryImpl(storefront: "jp"), dummy: 0)
    }
}

//
//  Storefront.swift
//  iTunesService
//
//  Created by 林達也 on 2017/07/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

func appleStorrefront(store: String, language: String) -> String {
    func get(store: String, language: String) -> String? {
        guard let store = storecodes[store], let language = languagecodes[language] else { return nil }
        return "\(store)-\(language)"
    }
    return get(store: store, language: language) ?? get(store: "jp", language: "ja-jp")!
}

private let storecodes: [String: String] = [
    "us": "143441",
    "jp": "143462"]

private let languagecodes: [String: String] = [
    "ja-jp": "9"]

//United States 143441
//Argentina 143505
//Australia 143460
//Belgium 143446
//Brazil 143503
//Canada 143455
//Chile 143483
//China 143465
//Colombia 143501
//Costa Rica 143495
//Croatia 143494
//Czech Republic 143489
//Denmark 143458
//Deutschland 143443
//El Salvador 143506
//Espana 143454
//Finland 143447
//France 143442
//Greece 143448
//Guatemala 143504
//Hong Kong 143463
//Hungary 143482
//India 143467
//Indonesia 143476
//Ireland 143449
//Israel 143491
//Italia 143450
//Korea 143466
//Kuwait 143493
//Lebanon 143497
//Luxembourg 143451
//Malaysia 143473
//Mexico 143468
//Nederland 143452
//New Zealand 143461
//Norway 143457
//Osterreich 143445
//Pakistan 143477
//Panama 143485
//Peru 143507
//Phillipines 143474
//Poland 143478
//Portugal 143453
//Qatar 143498
//Romania 143487
//Russia 143469
//Saudi Arabia 143479
//Schweitz/Suisse 143459
//Singapore 143464
//Slovakia 143496
//Slovenia 143499
//South Africa 143472
//Sri Lanka 143486
//Sweden 143456
//Taiwan 143470
//Thailand 143475
//Turkey 143480
//United Arab Emirates 143481
//United Kingdom 143444
//Venezuela 143502
//Vietnam 143471
//Japan 143462

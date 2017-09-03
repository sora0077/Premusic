//
//  RequestAlias.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/07/31.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import AppleMusicKit

typealias GetStorefront = AppleMusicKit.GetStorefront<
    Entity.Storefront.Attributes>
typealias GetMultipleStorefronts = AppleMusicKit.GetMultipleStorefronts<
    Entity.Storefront.Attributes>
typealias GetAllStorefronts = AppleMusicKit.GetAllStorefronts<
    Entity.Storefront.Attributes>

typealias GetSong = AppleMusicKit.GetSong<
    Entity.Song.Attributes,
    Entity.Album.Attributes,
    Entity.Artist.Attributes,
    Entity.Genre.Attributes,
    Entity.Storefront.Attributes>

typealias GetMultipleSongs = AppleMusicKit.GetMultipleSongs<
    Entity.Song.Attributes,
    Entity.Album.Attributes,
    Entity.Artist.Attributes,
    Entity.Genre.Attributes,
    Entity.Storefront.Attributes>

typealias GetAlbum = AppleMusicKit.GetAlbum<
    Entity.Album.Attributes,
    Entity.Song.Attributes,
    Entity.MusicVideo.Attributes,
    Entity.Artist.Attributes,
    Entity.Storefront.Attributes>

typealias GetMultipleAlbums = AppleMusicKit.GetMultipleAlbums<
    Entity.Album.Attributes,
    Entity.Song.Attributes,
    Entity.MusicVideo.Attributes,
    Entity.Artist.Attributes,
    Entity.Storefront.Attributes>

typealias GetCharts = AppleMusicKit.GetCharts<
    Entity.Song.Attributes,
    Entity.MusicVideo.Attributes,
    Entity.Album.Attributes,
    Entity.Genre.Attributes,
    Entity.Storefront.Attributes>

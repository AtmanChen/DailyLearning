//
//  Album.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation


struct Album: Decodable {
    /*id, name, albumArtWork, artist*/
    let id: String
    let name: String
    let albumArtWork: String
    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case albumArtWork = "album_art_work"
        case artist
    }
}

extension Album {
    init?(data: Data) {
        guard let album = try? JSONDecoder().decode(Album.self, from: data) else {
            return nil
        }
        self = album
    }
}

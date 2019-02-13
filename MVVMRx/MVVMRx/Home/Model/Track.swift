//
//  Track.swift
//  MVVMRx
//
//  Created by 突突兔 on 2019/2/13.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation


struct Track: Decodable {
    
    /*
     let id, name, trackArtWork, trackAlbum: String
     let artist: String
     */
    let id: String
    let name: String
    let trackArtWork: String
    let trackAlbum: String
    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case trackArtWork = "track_art_work"
        case trackAlbum = "track_album"
        case artist
    }
}

extension Track {
    
    init?(data: Data) {
        do {
            let track = try JSONDecoder().decode(Track.self, from: data)
            self = track
        } catch {
            print(error)
            return nil
        }
    }
}

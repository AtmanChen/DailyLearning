//
//  Unsplash.swift
//  MyPapr
//
//  Created by 突突兔 on 2019/2/16.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import TinyNetworking


enum Unsplash {
    
    /// get the list of all photos
    case photos(page: Int?, perPage: Int?, orderBy: OrderBy?)
    
    /// get the list of all photos
    case curatedPhotos(page: Int?, perPage: Int?, orderBy: OrderBy?)
}

extension Unsplash: ResourceType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("FAILED: https://api.unsplash.com")
        }
        return url
    }
    
    var endpoint: Endpoint {
        switch self {
        case .photos:
            return .get(path: "/photos")
        case .curatedPhotos:
            return .get(path: "/photos/curated")
        }
    }
    
    var task: Task {
        let noBracketsAndLiteralBoolEncoding = URLEncoding(
            arrayEncoding: .noBrackets,
            boolEncoding: .literal
        )
        
        switch self {
        case let .curatedPhotos(pageNumber, photosPerpage, orderBy):
            var params: [String: Any] = [:]
            params["page"] = pageNumber
            params["per_page"] = photosPerpage
            params["order_by"] = orderBy
            return .requestWithParameters(params, encoding: URLEncoding())
        default:
            return .requestWithParameters([:], encoding: URLEncoding())
        }
    }
    
    var headers: [String : String] {
        let clientID = Constants.UnsplashSettings.clientID
        guard let token = UserDefaults.standard.string(forKey: clientID) else {
            return ["Authorization": "Client-ID \(clientID)"]
        }
        return ["Authorization": "Bearer \(token)"]
    }
}

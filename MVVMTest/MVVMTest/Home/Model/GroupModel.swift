//
//  GroupModel.swift
//  MVVMTest
//
//  Created by 突突兔 on 2019/2/15.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import ObjectMapper

struct GroupModel: Mappable {
    
    var name: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
}

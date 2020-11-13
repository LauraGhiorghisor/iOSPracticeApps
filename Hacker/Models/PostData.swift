//
//  PostData.swift
//  Hacker
//
//  Created by Laura Ghiorghisor on 16/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import Foundation

struct Result: Decodable {
    
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}

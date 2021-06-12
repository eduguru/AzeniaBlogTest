//
//  Post.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 11/06/2021.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let userID, id: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

//// MARK: -
//class Post {
//
//    var userId: Int?
//    var id: Int?
//    var title: String?
//    var body: String?
//
//
//    init (jsonObject: JSON) {
//
//        self.userId = jsonObject["userId"].intValue;
//        self.id = jsonObject["id"].intValue;
//        self.title = jsonObject["title"].stringValue;
//        self.body = jsonObject["body"].stringValue;
//
//    }
//
//}

//
//  Comment.swift
//  AzeniaBlogTest
//
//  Created by edwin weru on 11/06/2021.
//

import Foundation

// MARK: - Comment
struct Comment: Codable {
    let postID, id: Int?
    let name, email, body: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

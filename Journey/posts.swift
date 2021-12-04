//
//  posts.swift
//  Journey
//
//  Created by Tejaswini on 3/12/21.
//  Copyright © 2021 Tejaswini. All rights reserved.
//

import Foundation
struct Posts {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? Int ?? 0
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.body = dictionary["body"] as? String ?? ""
    }
}

    struct Comments {
        var postId: Int
        var id: Int
        var name: String
        var email: String
        var body: String
        init(_ dictionary: [String: Any]) {
            self.postId = dictionary["postId"] as? Int ?? 0
            self.id = dictionary["id"] as? Int ?? 0
            self.name = dictionary["name"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.body = dictionary["body"] as? String ?? ""
        }

}

//
//  MyGithub.swift
//  LoginApp
//
//  Created by Quan Pham Van on 7/24/18.
//  Copyright © 2018 QuanPV. All rights reserved.
//

import Foundation

struct MyGithub: Codable {
    let name: String?
    let location: String?
    let followers: Int?
    let avatarUrl:URL?
    let repos: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case location
        case followers
        case repos = "public_repos"
        case avatarUrl = "avatar_url"
        
    }
    
}

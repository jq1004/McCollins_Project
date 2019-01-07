//
//  DataParsing.swift
//  Eureka_McCollins_Pages
//
//  Created by Junqing li on 1/6/19.
//  Copyright © 2019 Junqing li. All rights reserved.
//

import Foundation

class DataParsing {
   static func parseLoginUserInfo(json : [String: Any]) -> UserModel {
        let info = json["data"] as! [[String:Any]]
        let data = info[0]
        let user = UserModel(email: data["email"] as! String, fname: data["fname"] as! String, lname: data["lname"] as! String, dob: data["dob"] as! String, gender: data["gender"] as! String, mobile: data["mobile"] as! String, userID: (data["user_id"] as! String), image: (data["userimage"] as! String))
        return user
    }
}

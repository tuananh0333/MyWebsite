//
//  Authentication.swift
//  MyWebsite
//
//  Created by le tuan anh on 10/7/17.
//

import Foundation
import Vapor
import HTTP
final class LoginController: ResourceRepresentable {
    func index(req: Request) throws -> ResponseRepresentable {
        let user = User(userName: "coding", email: "codewar@gmail.com", password: "1234")
        return try JSON(node: [
            "name": user.userName,
            "email": user.email
            ])
    }
    
    //This is the function the figure out what method that should be called depending on the HTTP request type. We will here start with the get.
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: login
        )
    }
    func login(req: Request) throws -> ResponseRepresentable {
        let username = req.data["username"]?.string
        let password = req.data["password"]?.string
        let dictUser = try User.all()
        var jsonResponse: JSON!
        var isSuccess = false
        for user in dictUser{
            if username == user.userName{
                isSuccess = true
                break;
            }
        }
        jsonResponse = isSuccess ? try JSON(node: [
            "LoginSuccess": "With Username:\(username)"]) : try JSON(node: [
            "LoginFailed": "With Username:\(username)"
            ])
        return jsonResponse
    }
}



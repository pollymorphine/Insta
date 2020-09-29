//
//  SessionProvider.swift
//  Course2FinalTask
//
//  Created by Polina on 12.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class NetworkProvider {
    
    private let host = "http://localhost:8080"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let requestManager = RequestManager()
    
    var isOnlineMode = true
    
    static var shared = NetworkProvider()
    
    private init() { }
    
    ////Проверка токена.
    
    func checkToken(token: String, completionHandler: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/checkToken") else { print("url is empty"); return }
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                guard let networkError = error else { return }
                completionHandler(.failure(networkError as! NetworkError))
                print(networkError)
            }
            print(httpResponse.statusCode)
            completionHandler(.success(true))
        }
        dataTask.resume()
    }
    
    ////Авторизует пользователя и выдает токен.
    
    func signIn(login: String, password: String, completionHandler: @escaping (Result<Token, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/signin/") else { print("url is empty"); return }
        
        let account = Account(login: login, password: password)
        let accountData = try? encoder.encode(account)
        let defaultHeaders = [
            "Content-Type" : "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = accountData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let token = try self.decoder.decode(Token.self, from: data)
                completionHandler(.success(token))
            } catch {
                completionHandler(.failure(NetworkError.unauthorized(reason: "Unathorized")))
            }
        }
        dataTask.resume()
    }
    
    ////Деавторизует пользователя и инвалидирует токен.
    
    func signOut() {
        guard let url = URL(string: host + "/signout/") else { return }
        guard let  request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request)
        dataTask.resume()
    }
    
    ////Возвращает информацию о текущем пользователе
    
    func сurrentUser(completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/me") else { return }
        guard let request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let сurrentUser = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(сurrentUser))
                
            } catch {
                completionHandler(.failure(NetworkError.unauthorized(reason: "Unathorized")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает публикации пользователя с запрошенным ID.
    
    func findUserPosts(userID: String, completionHandler: @escaping (Result<[Post], NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/" + userID + "/posts") else { return }
        guard let  request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////Возвращает подписчиков пользователя с запрошенным ID.
    
    func getFollowers(userID: String, completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/" + userID + "/followers") else { return }
        guard let  request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////   Возвращает подписки пользователя с запрошенным ID.
    
    func getFollowingUsers(userID: String, completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/" + userID + "/following") else { return }
        guard let  request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Подписывает текущего пользователя на пользователя с запрошенным ID.
    
    func follow(userID: String, _ completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/follow") else { return }
        
        let jsonId = [ "userID" : userID]
        guard let request = requestManager.getRequest(url: url, paramBody: jsonId) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Отписывает текущего пользователя от пользователя с запрошенным ID.
    
    func unfollow(userID: String, _ completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/unfollow") else { return }
        
        let jsonId = [ "userID" : userID]
        guard let request = requestManager.getRequest(url: url, paramBody: jsonId) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        
        dataTask.resume()
    }
    
    /// Возвращает пользователя с переданным ID.
    
    func getUser(userID: String, completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/users/" + userID) else { return }
        guard let request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает публикации пользователей, на которых подписан текущий пользователь.
    
    func getUsersPosts(completionHandler: @escaping (Result<[Post], NetworkError>) -> Void) {
        guard let url = URL(string: host + "/posts/feed") else { return }
        guard let request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID
    
    func getUsersLikedPost(userID: String, completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let url = URL(string: host + "/posts/" + userID + "/likes") else { return }
        guard let request = requestManager.getRequest(url: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////  Ставит лайк от текущего пользователя на публикации с запрошенным ID.
    
    func likePost(postID: String, completionHandler: @escaping (Result<Post, NetworkError>) -> Void) {
        guard let url = URL(string: host +  "/posts/like") else { return }
        
        let jsonId = [ "postID" : postID]
        guard let request = requestManager.getRequest(url: url, paramBody: jsonId) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////  Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
    
    func unlikePost(postID: String, completionHandler: @escaping (Result<Post, NetworkError>) -> Void) {
        guard let url = URL(string: host +  "/posts/unlike") else { return }
        
        let jsonId = [ "postID" : postID]
        guard let request = requestManager.getRequest(url: url, paramBody: jsonId) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Создает новую публикацию.
    
    func addNewPost(with image: String,
                    description: String,
                    completionHandler: @escaping (Result<Post, NetworkError>) -> Void) {
        guard let url = URL(string: host + "/posts/create") else { return }
        
        let jsonId = [
            "image" : image,
            "description": description
        ]
        guard let request = requestManager.getRequest(url: url, paramBody: jsonId) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.failure(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                self.requestManager.getErrorResponce(httpResponse: httpResponse)
                completionHandler(.failure(error as! NetworkError))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.failure(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
}

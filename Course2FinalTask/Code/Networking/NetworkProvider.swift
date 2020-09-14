//
//  SessionProvider.swift
//  Course2FinalTask
//
//  Created by Polina on 12.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case fail(NetworkError)
}

class NetworkProvider {
    
    private let host = "http://localhost:8080"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    static var shared = NetworkProvider()
    
    private init() { }
    
    ////Авторизует пользователя и выдает токен.
    
    func signIn(login: String, password: String, completionHandler: @escaping (Result<Token>) -> Void) {
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
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let token = try self.decoder.decode(Token.self, from: data)
                completionHandler(.success(token))
            } catch {
                completionHandler(.fail(NetworkError.unauthorized(reason: "Unathorized")))
            }
        }
        dataTask.resume()
    }
    
    ////Деавторизует пользователя и инвалидирует токен.
    
    func signOut() {
        guard let url = URL(string: host + "/signout/") else { return }
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request)
        dataTask.resume()
    }
    
    ////Возвращает информацию о текущем пользователе
    
    func сurrentUser(completionHandler: @escaping (Result<User>) -> Void) {
        guard let url = URL(string: host + "/users/me") else { return }
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let сurrentUser = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(сurrentUser))
                
            } catch {
                completionHandler(.fail(NetworkError.unauthorized(reason: "Unathorized")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает публикации пользователя с запрошенным ID.
    
    func findUserPosts(userID: String, completionHandler: @escaping (Result<[Post]>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        
        
        guard let url = URL(string: host + "/users/" + userID + "/posts") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////Возвращает подписчиков пользователя с запрошенным ID.
    
    func getFollowers(userID: String, completionHandler: @escaping (Result<[User]>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/users/" + userID + "/followers") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////   Возвращает подписки пользователя с запрошенным ID.
    
    func getFollowingUsers(userID: String, completionHandler: @escaping (Result<[User]>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/users/" + userID + "/following") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Подписывает текущего пользователя на пользователя с запрошенным ID.
    
    func follow(userID: String, _ completionHandler: @escaping (Result<User>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/users/follow") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        let jsonId = [ "userID" : userID]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Отписывает текущего пользователя от пользователя с запрошенным ID.
    
    func unfollow(userID: String, _ completionHandler: @escaping (Result<User>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/users/unfollow") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        let jsonId = [ "userID" : userID]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        
        dataTask.resume()
    }
    
    /// Возвращает пользователя с переданным ID.
    
    func getUser(userID: String, completionHandler: @escaping (Result<User>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/users/" + userID) else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completionHandler(.success(user))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает публикации пользователей, на которых подписан текущий пользователь.
    
    func getUsersPosts(completionHandler: @escaping (Result<[Post]>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/posts/feed") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID
    
    func getUsersLikedPost(userID: String, completionHandler: @escaping (Result<[User]>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/posts/" + userID + "/likes") else { return }
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let followers = try self.decoder.decode([User].self, from: data)
                completionHandler(.success(followers))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////  Ставит лайк от текущего пользователя на публикации с запрошенным ID.
    
    func likePost(postID: String, completionHandler: @escaping (Result<Post>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host +  "/posts/like") else { return }
        
        let jsonId = [ "postID" : postID]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    ////  Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
    
    func unlikePost(postID: String, completionHandler: @escaping (Result<Post>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host +  "/posts/unlike") else { return }
        
        let jsonId = [ "postID" : postID]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
    
    //// Создает новую публикацию.
    
    func addNewPost(with image: String,
                    description: String,
                    completionHandler: @escaping (Result<Post>) -> Void) {
        guard let token = Keychain.shared.readToken() else { print("no token"); return  }
        guard let url = URL(string: host + "/posts/create") else { return }
        
        let jsonId = [
            "image" : image,
            "description": description
        ]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { completionHandler(.fail(NetworkError.transferError(reason: "Transfer error"))); return }
            
            if httpResponse.statusCode != 200 {
                let error: NetworkError
                
                switch httpResponse.statusCode {
                case 400: error = .badRequest(reason: "Bad Request")
                case 401: error = .unauthorized(reason: "Unathorized")
                case 404: error = .notFound(reason: "Not found")
                case 406: error = .notAcceptable(reason: "Not acceptable")
                case 422: error = .unprocessable(reason:  "Unprocessable")
                default: error = .transferError(reason:  "Transfer error")
                }
                completionHandler(.fail(error))
            }
            guard let data = data else { return }
            
            do {
                let posts = try self.decoder.decode(Post.self, from: data)
                completionHandler(.success(posts))
                
            } catch {
                completionHandler(.fail(NetworkError.transferError(reason: "Unknown error")))
            }
        }
        dataTask.resume()
    }
}

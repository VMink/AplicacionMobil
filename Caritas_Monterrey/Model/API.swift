//
//  API.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

struct Post:Codable {
    let message: String
}

class Api : ObservableObject {
    @Published var post = [Post]()
    
    func callApi() {
        guard let url = URL(string: "http://10.14.255.85:8084/login") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            let jsonDecoder = JSONDecoder()
            if (data != nil) {
                do {
                    let postItem = try jsonDecoder.decode(Post.self, from: data!)
                    print("Message: \(postItem.message)")
                } catch {
                    print(error)
                }
                if let datosAPI = String(data: data!, encoding: .utf8) {
                    print(datosAPI)
                }
            }
        }
        task.resume()
        return
    }
}

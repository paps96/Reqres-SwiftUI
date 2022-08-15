//
//  WebRequest.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 13/08/22.
//

import Foundation
import Combine
import SwiftUI


struct requestData: Decodable {
    var id: Int?
    var token: String?
    var error: String?
}

struct user: Hashable, Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

struct page: Decodable {
    let page: Int?
    let per_page: Int?
    let total: Int?
    let total_pages: Int?
    let data: [user]
}

struct singleUser: Decodable {
    let data: user?
}


/// Clase que maneja todo lo referente a las peticiones get y post
class webUtils: ObservableObject {
    
    @Published var users: [user] = []
    @Published var allUsers: [user] = []
    @Published var single: user?
    
    
    /// Función que consume la Api de reqres para el inicio de sesión y registro de usuarios, estas dos operaciones corresponde a una solicitud del tipo "POST"
    /// - Parameters:
    ///   - usernameOrEmail: Nombre de usuario o email
    ///   - userPassword: Contraseña de la cuenta asociada
    ///   - login: Si es verdadero corresponde a una solicitud para iniciar sesión, falso para el registro de un nuevo usuario
    ///   - completion: Función para sincronizar los datos recibidos con la respuesta en pantalla
    static func logSignIn(usernameOrEmail: String, userPassword: String, login: Bool, completion: @escaping (requestData) -> ()) {
        
        let parameters: [String: String] = ["email": usernameOrEmail, "password": userPassword]
        let url = login ? URL(string: "https://reqres.in/api/login")! : URL(string: "https://reqres.in/api/register")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
        request.httpBody = httpBody
        request.timeoutInterval = 5
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                
                guard let data = data else { return }
                    
                DispatchQueue.main.async {
                    do {
                        let dataResponse = try JSONDecoder().decode(requestData.self, from: data)
                        completion(dataResponse)
                        print(dataResponse)
                        
                    } catch {
                        let dataResponse = requestData()
                        completion(dataResponse)
                        print("Error decoding: \(error)")
                    }
                }
       
            }
            else {
                //_ = requestData()
                print("Status different 200: \(response)")
            }
        }.resume()
        
    }
    
    
    /// Función correspondiente a una solicitud "GET" funciona para obtener la lista de usuarios de la página 1
    func fetchData() {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
          
            guard let data = data, error == nil else { return }
            
            do {
                let information = try JSONDecoder().decode(page.self, from: data)
                DispatchQueue.main.async {
                    let users = information.data
                    self.users = users
                    self.allUsers = users
                    
                }
            }
            catch {
                print(error)
            }
        })
        
        task.resume()
        
    }
    
    
    /// Función para obtener la información de un usuario seleccionado, corresponde a una solicitud del tipo "GET"
    /// - Parameter userID: userID del usuario con el cual se hará la solicitud
    func fetchUser(_ userID: Int) {
        
        guard let url = URL(string: "https://reqres.in/api/users/\(userID)") else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
          
            guard let data = data, error == nil else { return }
            
            do {
                let information = try JSONDecoder().decode(singleUser.self, from: data)
                
                DispatchQueue.main.async {
                    self.single = information.data
                }
            }
            catch {
                print(error)
            }
        })
        
        task.resume()
        
    }
    
    
    
    
}









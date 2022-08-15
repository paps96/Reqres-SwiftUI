//
//  CoreDataManager.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import Foundation
import CoreData

/// Clase para gestionar la base de datos que corresponde a las busquedas de usuarios
class CoreDataManager: ObservableObject {
    
    let container: NSPersistentContainer
    private var searchedUsers: [SearchedUsers] = []
    @Published var searchedFinal: [user] = []
    static var shared: CoreDataManager = CoreDataManager()
    private var usersID: [Int] = []
    
    init() {
        container = NSPersistentContainer(name: "Busquedas")
        container.loadPersistentStores {(description, error) in
            if error != nil {
                print("Error loading container")
            }
        }
        fetchUsers()
    }
    
    /// Función Fetch para obtener todos los usuarios guardados en la base de datos, cada vez que se invoca se vacían y se vuelven a llenar los arreglos de la estructura "user", "SearchedUser" y "userID"
    private func fetchUsers() {
        let request = NSFetchRequest<SearchedUsers>(entityName: "SearchedUsers")
        do {
            
            searchedUsers.removeAll()
            usersID.removeAll()
            searchedFinal.removeAll()
            
            try searchedUsers = container.viewContext.fetch(request)
            usersID = searchedUsers.map { Int($0.id) }
            searchedFinal = searchedUsers.map { user.init(id: Int($0.id), email: $0.email!, first_name: $0.first_name!, last_name: $0.last_name!, avatar: $0.avatar!) }
        } catch let error {
            print(error)
        }
    }
    
    /// Función que guarda en la base de datos todas las entidades creadas antes de invocar esta función
    private func saveUsers() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch let error {
            print("Error in save Data \(error)")
        }
        return
    }
    
    
    /// Función que controla si un usuario ya ha sido registrado con aterioridad, en caso de que no crea una entidad que se guardará
    /// - Parameter user: Toda la información necesaria para guardar la nueva entidad
    func saveSearch(user: user) {
        
        guard !usersID.contains(user.id) else {
            return
        }
        
        let newSearch = SearchedUsers(context: container.viewContext)
        newSearch.id = Int64(user.id)
        newSearch.email = user.email
        newSearch.first_name = user.first_name
        newSearch.last_name = user.last_name
        newSearch.avatar = user.avatar
        saveUsers()
    }
}

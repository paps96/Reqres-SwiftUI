//
//  KeyChainManager.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 13/08/22.
//

import Foundation
import SwiftUI

struct Auth: Codable {
    let userID: Int
    let password: String
    let token: String
}

///Clase que gestiona la sesión del usuario, el token y la contraseña, se almacena en el "Apple Keychain"
final class KeyChainManager {
    
    enum keychainError: Error {
        case duplicateEntry
        case uknowError(OSStatus)
    }
    
    /// Función para guardar en el "Apple keychain" las credenciales correspondientes a un inicio de sesión exitoso
    /// - Parameters:
    ///   - service: Dirección de la página web de procedencia de la cuenta, en este caso el BundleID
    ///   - account: Nombre de usuario o Email
    ///   - password: Contraseña del usuario
    ///   - token: token recibido desde la api
    ///   - userID: userID recibido desde la api
    private static func save(
        service: String,
        account: String,
        password: String,
        token: String,
        userID: Int) throws {
            let auth = Auth(userID: userID, password: password, token: token)
            let data = try JSONEncoder().encode(auth)
            // service, account, password
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: data as AnyObject
                ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status != errSecDuplicateItem else {
                throw keychainError.duplicateEntry
            }
            
            guard status == errSecSuccess else {
                throw keychainError.uknowError(status)
            }
            
            loginInfo.fileObj.setDefaultUser(user: account)
            print("Saved key")
        }
    
    /// Función para obtener el token, id y contraseña de la cuenta asociada en el "Apple keychain"
    /// - Parameters:
    ///   - service: Dirección de la página web de procedencia de la cuenta, en este caso el BundleID
    ///   - account: Nombre de usuario o Email
    /// - Returns: Un archivo el cual puede transcribirse a la estructura "Auth" la cual contiene toda la información previamente descrita
    private static func get(
        service: String,
        account: String
    ) -> Data? {
        // service, account
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print("Read status \(status)")
        return result as? Data
    }
    
    /// Función para eliminar la cuenta del "Apple Keychain"
    /// - Parameters:
    ///   - service: Dirección de la página web de procedencia de la cuenta, en este caso el BundleID
    ///   - account: Nombre de usuario o Email
    static func del(
        service: String,
        account: String
    ) {
        guard let data = get(service: service, account: account) else { return }
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: data as AnyObject,
            ]
        
        loginInfo.fileObj.setDefaultUser(user: "")
        let status = SecItemDelete(query as CFDictionary)
        print("Delete Status \(status)")
    }
    
    /// Función abreviada para guardar la cuenta en el "Apple Keychain" y gestionar los errores
    /// - Parameters:
    ///   - account: Página de procedencia de la cuenta, en este caso el bundleID
    ///   - serv: Dirección de la página web de procedencia de la cuenta, en este caso el BundleID
    ///   - passw: Contraseña de la cuenta asociada
    ///   - token: Token provisto por la api para un inicio de sesión exitoso
    ///   - userID: UserID procedente de la api para un inicio de sesión exitoso
    static func saveRegistry(account: String, serv: String, passw: String, token: String, userID: Int) {
        do {
            try KeyChainManager.save(service: serv, account: account, password: passw, token: token, userID: userID)
        }
        catch {
            print(error)
        }
    }
    
    /// Función abreviada para obtener el token, la contraseña y el userID del "Apple keychain"
    /// - Parameters:
    ///   - account: Nombre de usuario o contraseña
    ///   - serv: Dirección de la página web de procedencia de la cuenta, en este caso el BundleID
    static func getPassword(account: String, serv: String) {
        
        guard let data = KeyChainManager.get(service: serv, account: account) else {
            print("failed to fetch password")
            return
        }
        print(String(decoding: data, as: UTF8.self))
        do {
            let item = try JSONDecoder().decode(Auth.self, from: data)
            print(item)
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
        }
        
    }
    
    
}


/// Semi-Singletón para la obtención del nombre de la cuenta y controlar el acceso
final class loginInfo {
    @AppStorage("emailAddress") var emailAddress: String = ""
    static let fileObj = loginInfo()
    func setDefaultUser(user: String) {
        emailAddress = user
    }
}



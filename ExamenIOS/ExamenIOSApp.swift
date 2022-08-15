//
//  ExamenIOSApp.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 13/08/22.
//

import SwiftUI

@main
struct ExamenIOSApp: App {
    
    @State var isLogin = false
    var body: some Scene {
        WindowGroup {
            if loginInfo.fileObj.emailAddress != ""{
                userList()
            } else {
                ContentView(logout: $isLogin)
            }
        }
    }
}

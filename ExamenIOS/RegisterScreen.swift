//
//  RegisterScreen.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 13/08/22.
//

import SwiftUI

struct RegisterScreen: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var showToast = false
    @Binding var isPresented: Bool
    @Binding var registeredUser: String
    
    var body: some View {
        
        
        ZStack {
            VStack {
                Text("Bienvenido al registro")
                    .font(.largeTitle)
                    .padding(.vertical)
                Text("Introduce tu nombre de usuario")
                    .padding(.vertical, 10)
                TextField("Nombre de usuario", text: $username)
                    .padding(10)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                Text("Introduce tu contraseña")
                    .padding(.vertical, 10)
                SecureField("Contraseña", text: $password)
                    .padding(10)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(20)
                    .padding(.horizontal)
                Text("Repite tu contraseña")
                    .padding(.vertical, 10)
                SecureField("Contraseña", text: $repeatedPassword)
                    .padding(10)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                Button(action: {
                    
                    webUtils.logSignIn(usernameOrEmail: username, userPassword: password, login: false, completion: { response in
                        
                        guard response.token != nil && response.id != nil else {
                            showToast.toggle()
                            return }
    //                    KeyChainManager.saveRegistry(account: username, serv: "com.peter.testWeb.ExamenIOS", passw: password, token: response.token!, userID: response.id!)
                        registeredUser = username
                        withAnimation {
                            isPresented = false
                        }
                        
                        
                    })
                    
                }, label: {
                    HStack{
                        Text("Registrar")
                            .padding()
                            .foregroundColor(.white)
                    }
                    .background(username.isEmpty || password.isEmpty || repeatedPassword.isEmpty || password != repeatedPassword ? Color.gray : Color.blue)
                    .cornerRadius(20)
                    .padding()
                    .shadow(radius: (username.isEmpty || password.isEmpty || repeatedPassword.isEmpty) || password != repeatedPassword ? 0 : 5)
                })
                
                .disabled(username.isEmpty || password.isEmpty || repeatedPassword.isEmpty || password != repeatedPassword ? true : false)
                
            }
        }
        .toast(isShowing: $showToast, duration: TimeInterval(1.5) , textToDisplay: "Hubo un error en el registro", imageSystemName: "person.crop.circle.badge.xmark", color: Color.red)
    }
    

   
}

struct RegisterScreen_Previews: PreviewProvider {
    @State static var isShowing = true
    @State static var userName = ""
    static var previews: some View {
        RegisterScreen(isPresented: $isShowing, registeredUser: $userName)
    }
}

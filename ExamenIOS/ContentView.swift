//
//  ContentView.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 13/08/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isShowRegister: Bool = false
    @State var goToUserList: Bool = false
    @Binding var logout: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image(systemName: "house")
                    .foregroundColor(.black)
                    .font(.system(size: 80))
                Text("Iniciar Sesión")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Usuario", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(20)
                    .padding()
                    .disableAutocorrection(true)
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(20)
                    .padding()
                
                ZStack {
                    NavigationLink("", isActive: $goToUserList, destination: {
                        userList()
                    })
                    Button(action: {
                        
                        webUtils.logSignIn(usernameOrEmail: username, userPassword: password, login: true, completion: { response in
                            guard response.token != nil else { return }
                            KeyChainManager.saveRegistry(account: username, serv: "com.peter.testWeb.ExamenIOS", passw: password, token:response.token!, userID: 0)
                            
                            guard !logout else { logout = false
                                return }
                            
                            goToUserList.toggle()
                            //KeyChainManager.getPassword(account: username, serv: "com.peter.testWeb.ExamenIOS")
                        })
                        
                    }, label: {
                        HStack{
                            Text("Iniciar Sesión")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(username.isEmpty || password.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    })
                    .disabled(username.isEmpty || password.isEmpty ? true : false)
                }
                
                Button(action: {
                    isShowRegister.toggle()
                }, label: {
                    HStack{
                        Text("Registrar")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                })
                
            }
            .sheet(isPresented: $isShowRegister, content: {
                RegisterScreen(isPresented: $isShowRegister, registeredUser: $username)
            } )
            .navigationBarHidden(true)
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var control: Bool = false
    static var previews: some View {
        ContentView(logout: $control)
            .previewDevice("iPhone 11")

    }
}

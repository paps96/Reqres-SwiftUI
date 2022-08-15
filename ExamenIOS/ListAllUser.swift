//
//  ListAllUser.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct ListAllUser: View {
    
    @StateObject var usuarios = webUtils()
    @StateObject var coreDataSearch = CoreDataManager.shared
    @State var Buscar = ""
    @State var filteredUsers = [user]()
    @State var searchedUser: user? = nil
    @State var searchLink = false
    @Binding var showDescription: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("", destination: userInfo(userID: searchedUser?.id ?? 0, avatar: searchedUser?.avatar ?? ""), isActive: $searchLink)
                List {
                    ForEach(usuarios.users, id: \.self) { username in
                        NavigationLink(destination: (userInfo(userID: username.id, avatar: username.avatar)), label: {
                            HStack {
                                AvatarImage(urlString: username.avatar)
                                VStack(alignment: .leading) {
                                    Text(String(username.id))
                                    Text(username.email)
                                        .minimumScaleFactor(0.1)
                                    Text(username.first_name)
                                    Text(username.last_name)
                                }
                            }
                        })
                    }
                }
                .searchable(text: $Buscar, prompt: "Buscar") {
                    if Buscar.isEmpty {
                        Text("Recientes")
                        ForEach(coreDataSearch.searchedFinal, id: \.self) { user in
                            Button(action: {
                                searchedUser = user
                                Buscar = ""
                                coreDataSearch.saveSearch(user: user)
                                searchLink.toggle()
                            }, label: {
                                HStack {
                                    AvatarImage(urlString: user.avatar)
                                    VStack(alignment: .leading) {
                                        Text("user ID: \(user.id)")
                                        Text("Nombre: \(user.first_name)")
                                        Text("Apellido: \(user.last_name)")
                                        Text("Email: \(user.email)")
                                    }

                                }
                            })
                        }
                        } else {
                        
                            ForEach(filteredUsers, id: \.self) { user in
                                Button(action: {
                                    searchedUser = user
                                    Buscar = ""
                                    coreDataSearch.saveSearch(user: user)
                                    searchLink.toggle()
                                }, label: {
                                    HStack {
                                        AvatarImage(urlString: user.avatar)
                                        VStack(alignment: .leading) {
                                            Text("user ID: \(user.id)")
                                            Text("Nombre: \(user.first_name)")
                                            Text("Apellido: \(user.last_name)")
                                            Text("Email: \(user.email)")
                                        }
                                    }
                                    
                                })
                                
                                
                            }
                        }
                    
                }
            }
            
            .onAppear(perform: {
                usuarios.fetchData()
            })
            .onChange(of: Buscar) { _ in
                if !Buscar.isEmpty {
                    let filter = usuarios.users.filter { person in
                        return ( person.last_name.contains(Buscar) || person.first_name.contains(Buscar) || person.email.contains(Buscar))
                    }
                    filteredUsers = filter.isEmpty ? usuarios.allUsers : filter
                    
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showDescription.toggle()
                        }
                         }, label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(Color.black)
                    })
                    .disabled(showDescription ? true : false)
                    .opacity(showDescription ? 0.0 : 1.0)
                }
                
            })
            .navigationTitle("Usuarios")
        }
    }
        
        
}

struct ListAllUser_Previews: PreviewProvider {
    @State static var show = false
    static var previews: some View {
        ListAllUser(showDescription: $show)
    }
}

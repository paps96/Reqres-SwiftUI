//
//  userInfo.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct userInfo: View {

    let userID: Int
    let avatar: String
    @StateObject var viewModel = webUtils()
    
    var body: some View {
        VStack {
            AvatarInfoImage(urlString: viewModel.single?.avatar ?? avatar)
            VStack {
                Text("user ID: \(String(viewModel.single?.id ?? 100))")
                    .font(.largeTitle)
                Text("email: \(viewModel.single?.email ?? "error email")")
                    .font(.title2)
                Text("Nombre: \(viewModel.single?.first_name ?? "error nombre")")
                Text("Apellido: \(viewModel.single?.last_name ?? "error apellidos")")
            }
            .padding()
        }
        .onAppear(perform: {
            viewModel.fetchUser(userID)
        })
    }
}

struct userInfo_Previews: PreviewProvider {
    static var previews: some View {
        userInfo(userID: 2, avatar: "")
    }
}

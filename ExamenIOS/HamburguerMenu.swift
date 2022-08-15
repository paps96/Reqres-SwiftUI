//
//  HamburguerMenu.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct HamburguerMenu: View {
    
    @Binding var showHamburguer: Bool
    @Binding var controlSession: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
                .padding(.top, 80)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
                .padding(.top, 30)
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Settings")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
                .padding(.top, 30)
            Spacer()
            
            Button(action: {
                withAnimation {
                    showHamburguer.toggle()
                }
                KeyChainManager.del(service: "com.peter.testWeb.ExamenIOS", account: loginInfo.fileObj.emailAddress)
                controlSession = true
                
            }, label: {
                HStack {
                    Text("Cerrar sesión")
                        .minimumScaleFactor(0.1)
                        .padding()
                        .foregroundColor(Color.white)
                }
                .background(Color.red)
                .cornerRadius(20)
                .shadow(radius: 5)
            })
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray3))
    }
}

struct HamburguerMenu_Previews: PreviewProvider {
    @State static var show = false
    @State static var controlSession: Bool = false
    static var previews: some View {
        HamburguerMenu(showHamburguer: $show, controlSession: $controlSession)
    }
}

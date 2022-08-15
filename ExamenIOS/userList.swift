//
//  userList.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct userList: View {
    
    @State var showDescription = false
    @State var controlSession: Bool = false
    
    var body: some View {
        
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width > -100 {
                            withAnimation {
                                self.showDescription = false
                            }
                        }
                    }
            
            GeometryReader { bounds in
                
                ZStack(alignment: .trailing) {
                    
                    ListAllUser(showDescription: $showDescription)
                        .frame(width: bounds.size.width, height: bounds.size.height)
                        .offset(x: self.showDescription ? -bounds.size.width / 2 : 0)
                        .disabled(self.showDescription ? true : false)
                    
                    if showDescription {
                        HamburguerMenu(showHamburguer: $showDescription, controlSession: $controlSession)
                            .frame(width: bounds.size.width/2)
                    }
                    
                }
                .fullScreenCover(isPresented: $controlSession, content: {
                    ContentView(logout: $controlSession)})
                .navigationBarHidden(true)
                .gesture(drag)
            }
                
            
            
        }
        
        
    }



struct userList_Previews: PreviewProvider {
    static var previews: some View {
        userList()
    }
}

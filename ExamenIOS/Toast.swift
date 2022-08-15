//
//  Toast.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct Toast: ViewModifier {
    @Binding var isShowing: Bool
    let duration: TimeInterval
    let textToDisplay: String
    let systemImageName: String
    let background: Color
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing{
                    toast
                    .padding()
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    })
                
                
            }
            
        }
        .onTapGesture(count: 2, perform: {
            withAnimation {
                isShowing = false
            }}
        )
        
    }
    
    private var toast: some View {
        
        VStack {
            Spacer()
            HStack {
                Image(systemName: systemImageName)
                Text(textToDisplay)
                    .fontWeight(.regular)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(background)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, duration: TimeInterval, textToDisplay: String, imageSystemName: String, color: Color) -> some View {
        modifier(Toast(isShowing: isShowing, duration: duration, textToDisplay: textToDisplay, systemImageName: imageSystemName, background: color))
    }
}


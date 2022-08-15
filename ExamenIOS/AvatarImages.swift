//
//  AvatarImages.swift
//  ExamenIOS
//
//  Created by Pedro Alberto Parra Solis on 14/08/22.
//

import SwiftUI

struct AvatarImage: View {
    
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .background(Color.gray)
            
        } else {
            Image(systemName: "person")
                .resizable()
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .onAppear(perform: {
                    fetchImage()
                })
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, _ in
            self.data = data
        })
        task.resume()
    }
    
}

struct AvatarImages_Previews: PreviewProvider {
    @State static var data = Data()
    static var previews: some View {
        AvatarImage(urlString: "Sample")
    }
}

struct AvatarInfoImage: View {
    
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 200, height: 200)
            
        } else {
            Image(systemName: "person")
                .resizable()
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .onAppear(perform: {
                    fetchImage()
                })
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, _ in
            self.data = data
        })
        task.resume()
    }

}

//
//  MediaView.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import SwiftUI

struct MediaView: View {
    let image: UIImage
    @Binding var isEditing: Bool
    var body: some View {
        ZStack(alignment: .topTrailing){
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100,height: 100,alignment: .topLeading)
                .clipped()
        }
        .frame(width:100,height: 100,alignment: .topTrailing)
        

    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(image: UIImage(named: "KoelnerDom")!, isEditing: .constant(true))
        PlaceHolderMediaView()
    }
}

struct PlaceHolderMediaView: View {
    var body: some View {
        Image(systemName: "plus")
            .frame(width: 100,height: 100)
            .background(Color("LightGray"))
    }
}

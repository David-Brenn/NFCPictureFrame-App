//
//  CollectionView.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import SwiftUI

struct CollectionView: View {
    let collection: Collection
    var body: some View {
        ZStack{
            Color(.white)
                .frame(width: 170,height: 170)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 10,x: 7,y:7)
                .overlay{
                    Text(collection.name)
                }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: Collection(name: "Köln", nfcID: "2939223"))
    }
}

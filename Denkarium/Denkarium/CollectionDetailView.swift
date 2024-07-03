//
//  CollectionDetailView.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import SwiftUI
import PhotosUI

struct CollectionDetailView: View {
    let collection: Collection
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var isEditing: Bool = false
    var body: some View {
        ScrollView(.vertical,showsIndicators: true){
        VStack{
            HStack{
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                    .frame(width: 150,height: 150)
                    .background(Color("LightGray"))
                Spacer()
                VStack{
                    HStack{
                        Text("NFC Id:")
                        Spacer()
                        Text(collection.nfcID)
                    }
                    Spacer()
                }
                .frame(height: 150)
            }
            Spacer(minLength: 20)
            HStack{
                Text("Media")
                    .font(.title2)
                Spacer()
                Button(action: {
                    isEditing.toggle()
                }){
                    if(isEditing){
                        Image(systemName:"xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:15,height:15)
                            .foregroundColor(.black)

                    }else {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:15,height:15)
                            .foregroundColor(.black)
                    }
                    
                }
                PhotosPicker(selection: $selectedItems,selectionBehavior: .ordered){
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:15,height:15)
                        .foregroundColor(.black)
                }
            }
            LazyVGrid(columns: layout,spacing:2){
                    ForEach(0..<images.count, id: \.self){i in
                        MediaView(image: images[i],isEditing: $isEditing)
                            .overlay(alignment: .topTrailing) {
                                if isEditing {
                                    Button {
                                        images.remove(at: i)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                                    .font(Font.title3)
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(.white, .blue)
                                }
                            }
                        }
                    }
                    if(images.isEmpty){
                        PhotosPicker(selection: $selectedItems,selectionBehavior: .ordered){
                            PlaceHolderMediaView()
                                .foregroundColor(.black)
                        }
                    }
                }
        }
            .padding()
            .navigationTitle(collection.name)
            .onChange(of: selectedItems){_ in
                Task{
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self){
                            if let image = UIImage(data: data){
                                images.append(image)
                            }
                        }
                    }
                    selectedItems.removeAll()
                }
            }
        }
    }
}

struct CollectionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionDetailView(collection: Collection(name: "images", nfcID: "20498382"))
    }
}

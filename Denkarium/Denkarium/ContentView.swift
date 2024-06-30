//
//  ContentView.swift
//  Denkarium
//
//  Created by David Brenn on 23.06.24.
//

import SwiftUI

struct MainView: View {
    
    init(collections: [Collection]) {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black],for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white],for: .normal)
        self.collections = collections
    }
    
    let collections: [Collection]
    var body: some View {
        TabView(){
            NavigationStack(){
                ScrollView(.vertical){
                        CollectionsView()
                }
                .navigationTitle("Collections")
                .navigationDestination(for: Collection.self){collection in
                CollectionDetailView(collection: collection)
                }
            }
                .tabItem{
                    Image(systemName: "folder")
                    Text("Collection")
                }
                .foregroundColor(Color.black)
            Controll()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Controll")
                }
        }
        .accentColor(Color.black)
    }
}

struct ToggleButton: View {
    let option: String
    @Binding var selectedOption: String?
    
    var body: some View {
        Button(action: {
            selectedOption = option
        }) {
            Spacer()
                .cornerRadius(8)
            Text(option)
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 6,trailing: 0))
                .cornerRadius(8)
            Spacer()
                .cornerRadius(8)
        }
        .background(selectedOption == option ? Color.white : Color.black)
        .cornerRadius(8)
        .padding(2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(collections: Collection.sampleData)
    }
}

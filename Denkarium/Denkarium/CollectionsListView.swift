//
//  CollectionsListView.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import SwiftUI

class CollectionsListViewModel: ObservableObject {
    @Published var collectionsData = [Collection]()
    
    @MainActor
    func fetchData() async {
            guard let downloadedCollections: [Collection] = await WebService().downloadData(fromURL: "http://192.168.178.82:5000/nfc") else {return}
            collectionsData = downloadedCollections
    }
}

struct CollectionsListView: View {
    @StateObject var collectionsViewModel = CollectionsListViewModel()
    
    let layout = [
        GridItem(spacing:-15),
        GridItem()
    ]
    var body: some View {
        LazyVGrid(columns: layout,spacing: 15) {
            if !collectionsViewModel.collectionsData.isEmpty {
                ForEach(collectionsViewModel.collectionsData, id:\.nfcID){collection in
                    NavigationLink(value: collection){
                        CollectionView(collection:collection)
                    }
                }
            } else {
                Text("No connection to the Picture Frame Server")
                    .padding()
            }
        }.onAppear {
            if collectionsViewModel.collectionsData.isEmpty {
                Task{
                    await collectionsViewModel.fetchData()
                }
            }
        }
        .onAppear{
            let fm = FileManager.default
            let urls = fm.urls(for: .sharedPublicDirectory, in: .allDomainsMask)
            print("Found URLs")
            print(urls)
        }
    }
}

struct CollectionsListView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsListView()
    }
}

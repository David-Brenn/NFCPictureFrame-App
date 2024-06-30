//
//  CollectionsView.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import SwiftUI

class CollectionsViewModel: ObservableObject {
    @Published var collectionsData = [Collection]()
    
    @MainActor
    func fetchData() async {
            guard let downloadedCollections: [Collection] = await WebService().downloadData(fromURL: "http://192.168.178.82:5000/nfc") else {return}
            collectionsData = downloadedCollections
    }
}

struct CollectionsView: View {
    @StateObject var collectionsViewModel = CollectionsViewModel()
    
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
    }
    /*
    func getCollections() async throws -> [Collection]{
        let endpoint = "http://192.168.178.82:5000/nfc"
        
        guard let url = URL(string:endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        print("Data: ")
        let jsonString = String(data: data, encoding:  String.Encoding.ascii)
        print(jsonString)
        
        do {
            let decoder = JSONDecoder()
            let collections = try decoder.decode([Collection].self, from: data)
            print("Collections:")
            print(collections)
            return collections
        } catch {
            throw NetworkError.invalidData
        }
        
    }
    */
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}

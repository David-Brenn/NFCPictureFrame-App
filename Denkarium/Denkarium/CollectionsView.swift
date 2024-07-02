//
//  CollectionsView.swift
//  Denkarium
//
//  Created by David Brenn on 30.06.24.
//

import SwiftUI

struct CollectionsView: View {
    var body: some View {
        NavigationStack(){
            ScrollView(.vertical){
                FileMangerView()
                CollectionsListView()
            }
            .navigationTitle("Collections")
            .navigationDestination(for: Collection.self){collection in
            CollectionDetailView(collection: collection)
            }
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}

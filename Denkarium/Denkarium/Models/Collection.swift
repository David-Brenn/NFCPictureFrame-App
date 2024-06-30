//
//  Collection.swift
//  Denkarium
//
//  Created by David Brenn on 24.06.24.
//

import Foundation

struct Collection: Hashable, Codable {
    var nfcID: String
    var name: String
    
    init(name: String, nfcID: String) {
        self.nfcID = nfcID
        self.name = name
    }
}


extension Collection {
    static let sampleData: [Collection]  = [
        Collection(name: "Köln", nfcID: "20430392"),
        Collection(name: "Bilbao", nfcID: "20430395"),
    ]
}

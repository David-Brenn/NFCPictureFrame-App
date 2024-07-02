//
//  Status.swift
//  Denkarium
//
//  Created by David Brenn on 29.06.24.
//

import Foundation

struct PictureFrameStatus: Codable {
    var status:String
}

struct ImageTimer: Codable {
    var imageTimer:Int
}

enum Status: String, CaseIterable, Identifiable {
    case offline,stopped,running
    var id: Self { self }
}


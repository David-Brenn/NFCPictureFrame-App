//
//  FileMangerView.swift
//  Denkarium
//
//  Created by David Brenn on 30.06.24.
//

import SwiftUI
import UIKit

struct FileMangerView: View {
    @State private var isDocumnetPickerActive = false
    @State private var uiimage:UIImage?
    
    let smbClient = SMBClient()
    
    var body: some View {
        VStack{
            Text("Shared Folders")
            if uiimage != nil {
                Image(uiImage: uiimage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100,height: 100)
                    .clipped()
            }
        }
        .onAppear{
            smbClient.listDirectory(path: "/images")
            Task {
                
                let downloadedData = await smbClient.downloadData(path: "/images/P1012097.jpeg")
                if downloadedData != nil {
                    uiimage = downloadedData
                }
            }
            let testupload = UIImage(resource: .koelnerDom)
            let jpedData = testupload.jpegData(compressionQuality: 1.0)
            if (jpedData != nil){
                //smbClient.uploadData(path: "/images/testupload_koelnerdom.jpeg", data: jpedData!)
            }
        }
    }
}

struct FileMangerView_Previews: PreviewProvider {
    static var previews: some View {
        FileMangerView()
    }
}

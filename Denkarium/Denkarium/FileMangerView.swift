//
//  FileMangerView.swift
//  Denkarium
//
//  Created by David Brenn on 30.06.24.
//

import SwiftUI
import UIKit
import QuickLookThumbnailing

struct FileMangerView: View {
    @State private var isDocumnetPickerActive = false
    @State private var uiimage:UIImage?
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isDocumnetPickerActive = true
                }){
                    Text("FileManager")
                        .foregroundColor(.blue)
                }
                .fileImporter(isPresented: $isDocumnetPickerActive, allowedContentTypes: [.folder], allowsMultipleSelection: false){ result in
                    switch result {
                    case .success(let urls):
                        if let url = urls.first {
                            print("URL")
                            print(url)
                            saveBookmark(url: url)
                        }
                    case .failure(let error):
                        print("Error selecting folder: \(error.localizedDescription)")
                    }
                }
                Spacer()
            }
            if uiimage != nil {
                Image(uiImage: uiimage!)
            } else {
                Image(systemName: "photo")
            }
        }
        .onAppear{
            loadBookmark()
        }
        .padding()
    }
    func getContent(url: URL){
        let fileManager = FileManager.default
        do {
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for file in contents {
                print("File: \(file.lastPathComponent)")
                let size =  CGSize(width: 200, height: 200)
                let scale = CGFloat(integerLiteral: 1)
                
                uiimage = UIImage(contentsOfFile: file.path())
                /*
                let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale,
                representationTypes: .thumbnail)
                
                let generator = QLThumbnailGenerator.shared
                generator.generateRepresentations(for: request) { thumbnail, _, error in
                  // 3
                  if let thumbnail = thumbnail {
                    print("thumbnail generated")
                    uiimage = thumbnail.uiImage
                  } else if let error = error {
                    print(" - \(error)")
                  }
                }
                */
            }
            
        } catch {
            print("Error reading contents of directory: \(error.localizedDescription)")
        }
    }
    
    
    func loadBookmark(){
        do {
            var isStale = false
            if let storedBookmark = UserDefaults.standard.data(forKey: "SharedFolderBookmark"){
                let folderURL = try URL(resolvingBookmarkData: storedBookmark, options: [.withoutImplicitStartAccessing], bookmarkDataIsStale: &isStale)
                print("Stored URL Data")
                print(folderURL)
                getContent(url: folderURL)
            } else {
                print("No enty for SharedFolderBookmark")
            }
        } catch {
            print ("Loading Bookmark Failed")
        }
    }
    
    func saveBookmark(url: URL) {
        do {
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: "SharedFolderBookmark")
        } catch {
            print("Access error")
        }
    }
}

struct FileMangerView_Previews: PreviewProvider {
    static var previews: some View {
        FileMangerView()
    }
}

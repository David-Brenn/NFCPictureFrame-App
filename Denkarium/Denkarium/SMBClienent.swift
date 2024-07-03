
import AMSMB2
import Foundation
import UIKit

class SMBClient: @unchecked Sendable {
    /// connect to: `smb://guest@XXX.XXX.XX.XX/share`
    
    let serverURL = URL(string: "smb://192.168.178.82")!
    let credential = URLCredential(user: "pi", password: "raspberry", persistence: URLCredential.Persistence.forSession)
    let share = "digitalFrameShare"
    
    lazy private var client = SMB2Manager(url: self.serverURL, credential: self.credential)!
    
    private func connect() async throws -> SMB2Manager {
        // AMSMB2 can handle queueing connection requests
        try await client.connectShare(name: share)
        return self.client
    }
    
    func listDirectory(path: String) {
        Task {
            do {
                let client = try await connect()
                let files = try await client.contentsOfDirectory(atPath: path)
                for entry in files {
                    print(
                        "name:", entry[.nameKey] as! String,
                        ", path:", entry[.pathKey] as! String,
                        ", type:", entry[.fileResourceTypeKey] as! URLFileResourceType,
                        ", size:", entry[.fileSizeKey] as! Int64,
                        ", modified:", entry[.contentModificationDateKey] as! Date,
                        ", created:", entry[.creationDateKey] as! Date)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func moveItem(path: String, to toPath: String) {
        Task {
            do {
                let client = try await self.connect()
                try await client.moveItem(atPath: path, toPath: toPath)
                print("\(path) moved successfully.")
                
                // Disconnecting is optional, it will be called eventually
                // when `AMSMB2` object is freed.
                // You may call it explicitly to detect errors.
                try await client.disconnectShare()
            } catch {
                print(error)
            }
        }
    }
    
    func downloadData(path: String) async -> UIImage?{
        do {
            let client = try await self.connect()
            let progress:SMB2Manager.ReadProgressHandler = SMB2Manager.ReadProgressHandler(nilLiteral: ())
            let result = try await client.contents(atPath: path,progress:progress)
            return UIImage(data: result)
        } catch {
            return nil
        }
    }
    
    func uploadData(path: String ,data: Data) {
        Task {
            do {
                let client = try await self.connect()
                let progressHandler = SMB2Manager.WriteProgressHandler(nilLiteral: ())
                try await client.write(data: data, toPath: path, progress: progressHandler)
            }
        }
    }
}

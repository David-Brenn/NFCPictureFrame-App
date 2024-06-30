//
//  Controll.swift
//  Denkarium
//
//  Created by David Brenn on 26.06.24.
//

import SwiftUI

class PictureFrameStatusViewModel: ObservableObject {
    @Published var statusData = PictureFrameStatus(status: "")
    @Published var imageTimer = ImageTimer(imageTimer: 0)
    
    @MainActor
    func fetchData() async {
        await fetchStatus()
        await fetchTimer()
    }
    
    @MainActor
    func fetchStatus() async {
        guard let downloadedStatus:PictureFrameStatus = await WebService().downloadData(fromURL: "http://192.168.178.82:5000/") else {return}
            print(downloadedStatus)
            statusData = downloadedStatus
    }
    
    @MainActor
    func fetchTimer() async {
        guard let downloadedTimer: ImageTimer = await WebService().downloadData(fromURL: "http://192.168.178.82:5000/image-timer") else {return}
            print(downloadedTimer)
            imageTimer = downloadedTimer
    }
    
    @MainActor
    func imageTimerSecChanged(newSec: Int) async{
        print(newSec)
    }
    
    @MainActor
    func statusChanged(newStatus:Status) async{
        if(newStatus.rawValue != statusData.status) {
            print("Status from app and server is differnet")
            var stringURL = "http://192.168.178.82:5000/"
            switch(newStatus){
            case Status.running:
                stringURL += "start"
            case Status.stopped:
                stringURL += "stop"
            case Status.offline:
                stringURL += "shutdown"
            }
            guard let changedStatus:PictureFrameStatus = await WebService().downloadData(fromURL: stringURL) else {return}
            print(changedStatus)
            statusData = changedStatus
        } else {
            print("Status form app and server is identical")
        }
    }
}

struct Controll: View {
    @State private var selectedStatus: Status = .offline
    @State private var selectedImageTimerSec:Int = 0
    @State private var selectedImageTimerMin:Int = 0
    
    @StateObject var statusVM = PictureFrameStatusViewModel()

    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black],for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white],for: .normal)
    }

    var body: some View {
        VStack{
            List(){
                Section("Settings"){
                    HStack{
                        Text("Image Timer")
                        Spacer()
                        Text("Min:")
                        TextField("Sec", value: $selectedImageTimerMin,format: .number)
                            .textContentType(.dateTime)
                            .keyboardType(.numberPad)
                            .frame(width: 30)
                        Text("Sec:")
                        TextField("Sec", value: $selectedImageTimerSec,format: .number)
                            .textContentType(.dateTime)
                            .keyboardType(.numberPad)
                            .frame(width: 30)
                    }
                    Text("Root Folder")
                }
                Section("Status"){
                    if(selectedStatus == Status.offline){
                        Text("Offline")
                    }
                    Picker("Status", selection: $selectedStatus) {
                        Text("Offline").tag(Status.offline)
                        Text("Stopped").tag(Status.stopped)
                        Text("Running").tag(Status.running)
                    }
                    .pickerStyle(.segmented)
                    .background(.black)
                    .cornerRadius(8)
                    .padding()
                    .disabled(selectedStatus == Status.offline)
                }
                Text(statusVM.statusData.status)
            }
            Spacer()
        }
        .onChange(of: selectedStatus){ newValue in
            Task{
                await statusVM.statusChanged(newStatus: newValue)
            }
        }
        .onChange(of: selectedImageTimerSec){newValue in
            Task{
                await statusVM.imageTimerSecChanged(newSec: newValue)
            }
        }
        .onAppear {
            Task{
                await statusVM.fetchData()
                switch(statusVM.statusData.status){
                case "offline":
                    selectedStatus = Status.offline
                case "stopped":
                    selectedStatus = Status.stopped
                case "running":
                    selectedStatus = Status.running
                default:
                    selectedStatus = Status.offline
                }
                selectedImageTimerMin = statusVM.imageTimer.imageTimer / 60
                selectedImageTimerSec = statusVM.imageTimer.imageTimer % 60
            }
        }
    }
}

struct Controll_Previews: PreviewProvider {
    static var previews: some View {
        Controll()
    }
}

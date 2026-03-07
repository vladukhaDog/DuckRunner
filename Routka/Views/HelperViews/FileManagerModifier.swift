//
//  FileManagerModifier.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension View {
    
    func fileManager(managedBy fileManager: any TrackFileServiceProtocol) -> some View {
        self.modifier(FileServiceViewWrapper(service: fileManager))
           
    }
}


private struct FileServiceViewWrapper: ViewModifier {
    @State var service: any TrackFileServiceProtocol
    
    init(service: any TrackFileServiceProtocol) {
        self._service = .init(wrappedValue: service)
    }
    
    func body(content: Content) -> some View {
        content
            .fileImporter(
                isPresented: $service.isImporterPresented,
                allowedContentTypes: [UTType(filenameExtension: "routka")!],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    Task {
                        await service.importFromFile(url: url)
                    }
                case .failure(let error):
//                    importError = error
                    print(error)
                    break
                }
            }
            .fileMover(isPresented: $service.isExporterPresented,
                       file: service.fileToExport) { result in
                switch result {
                case .success(let newURL):
                    print("SUCCESS MOVE")
                    break
//                    mainLogger.log("SUCCESS transfering video file to new URL", .info)
//                    self.downloadManager.successfullTranfserURL = newURL
//                    self.downloadManager.downloadFileDestination = nil
                case .failure(let failure):
                    print("FAILED MOVE")
                    break
//                    mainLogger.log("FAILURE transfering video file to new URL", message: failure.localizedDescription, .error)
//                    AlertController.showAlert("generic_error".localized())
                }
            }
//            .fileExporter(isPresented: $service.isExporterPresented,
//                          document: [.], contentType: .plainText) { result in
//                switch result {
//                case .success(let url):
//                    print("Saved to \(url)")
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//            .alert("Import Error", isPresented: Binding<Bool>(
//                get: { importError != nil },
//                set: { if !$0 { importError = nil } }
//            ), actions: {
//                Button("OK", role: .cancel) { }
//            }, message: {
//                Text(importError?.localizedDescription ?? "Unknown error")
//            })
    }
}

//
//  FileManagerModifier.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import vladukhaAlerts

let fileTransferUILogger = MainLogger("FileTransferUI")

protocol FileServiceWrapperRouting: AnyObject {
    func openTrack(_ track: Track)
}

extension View {
    
    func fileManager(trackFileService: any TrackFileServiceProtocol,
                     routing: any FileServiceWrapperRouting) -> some View {
        self.modifier(FileServiceViewWrapper(trackFileService: trackFileService,
                                             routing: routing))
           
    }
}

private struct FileServiceViewWrapper: ViewModifier {
    @State var service: any TrackFileServiceProtocol
    private let routing: any FileServiceWrapperRouting
    
    init(trackFileService: any TrackFileServiceProtocol,
         routing: any FileServiceWrapperRouting) {
        self._service = .init(wrappedValue: trackFileService)
        self.routing = routing
        
    }
    
    func importFromURL(url: URL) {
        
    }
    
    func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                guard url.isFileURL, url.pathExtension.lowercased() == "routka" else {
                    fileTransferUILogger.log("Ignored opened URL",
                                             message: "url: \(url.absoluteString)",
                                             .warning)
                    return
                }
                fileTransferUILogger.log("Handling opened track file",
                                         message: "file: \(url.lastPathComponent)",
                                         .info)
                Task { @MainActor in
                    guard let track = try? await service.importFromFile(url: url) else {
                        fileTransferUILogger.log("Failed handling opened track file",
                                                 message: "file: \(url.lastPathComponent)",
                                                 .error)
                        return
                    }
                    routing.openTrack(track)
                }
            }
            .fileImporter(
                isPresented: $service.isImporterPresented,
                allowedContentTypes: [UTType(filenameExtension: "routka")!],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    fileTransferUILogger.log("Importer selected file",
                                             message: "file: \(url.lastPathComponent)",
                                             .info)
                    Task {
                        do {
                            let importedTrack = try await service.importFromFile(url: url)
                            routing.openTrack(importedTrack)
                        } catch {
                            fileTransferUILogger.log("Importer failed",
                                                     message: "file: \(url.lastPathComponent), error: \(error.localizedDescription)",
                                                     .error)
                            await AlertController.shared.showAlert(String(localized: "importing track error alert",
                                                                          table: "ExportImportAlerts"),
                                                                   icon: .angryFail,
                                                                   timeout: 5,
                                                                   closable: true,
                                                                   feedback: .error)
                        }
                    }
                case .failure(let error):
                    fileTransferUILogger.log("Importer UI failed",
                                             message: error.localizedDescription,
                                             .error)
                    Task {
                        await AlertController.shared.showAlert(String(localized: "importing track error alert",
                                                                      table: "ExportImportAlerts"),
                                                               icon: .angryFail,
                                                               timeout: 5,
                                                               closable: true,
                                                               feedback: .error)
                    }
                }
            }
            .fileMover(isPresented: $service.isExporterPresented,
                       file: service.fileToExport) { result in
                switch result {
                case .success(let newURL):
                    fileTransferUILogger.log("Exporter moved file",
                                             message: "destination: \(newURL.lastPathComponent)",
                                             .info)
                    Task {
                        await AlertController.shared.showAlert(String(localized: "export track success",
                                                                      table: "ExportImportAlerts"),
                                                               icon: .done,
                                                               timeout: 5,
                                                               closable: true,
                                                               feedback: .success)
                    }
                case .failure(let failure):
                    fileTransferUILogger.log("Exporter failed",
                                             message: failure.localizedDescription,
                                             .error)
                    Task {
                        await AlertController.shared.showAlert(String(localized: "exporting track error alert",
                                                                      table: "ExportImportAlerts"),
                                                               icon: .angryFail,
                                                               timeout: 5,
                                                               closable: true,
                                                               feedback: .error)
                    }
                }
            }
                       
    }
}

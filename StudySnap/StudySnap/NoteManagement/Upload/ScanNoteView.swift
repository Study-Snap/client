//
//  ScanNoteView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-10-08.
//

import SwiftUI
import Vision
import VisionKit
import PDFKit

struct ScanNoteView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presenrationMode

    
    @Binding var pickedFile: Data
    
    func makeCoordinator() -> Coordinator {
        Coordinator(pickedFile: $pickedFile, parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var pickedFile: Binding<Data>
        var parent: ScanNoteView
        
        init(pickedFile: Binding<Data>, parent: ScanNoteView) {
            self.pickedFile = pickedFile
            self.parent = parent
        }
    }
}

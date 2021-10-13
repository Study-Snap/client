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
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var pagesText: [String]
    @Binding var didCompleteScan: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(pagesText: $pagesText, didCompleteScan: $didCompleteScan, parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var pagesText: Binding<[String]>
        var didCompleteScan: Binding<Bool>
        var parent: ScanNoteView
        
        init(pagesText: Binding<[String]>, didCompleteScan: Binding<Bool>, parent: ScanNoteView) {
            self.pagesText = pagesText
            self.didCompleteScan = didCompleteScan
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = extractImages(from: scan)
            recognizeText(from: extractedImages)
            
            didCompleteScan.wrappedValue = true
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at: index)
                guard let cgImage = extractedImage.cgImage else { continue }
                extractedImages.append(cgImage)
            }
            return extractedImages
        }
        
        fileprivate func recognizeText(from images: [CGImage]) {
            var pageTexts: [String] = []
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else { return }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                var currentPageText = ""
                
                let maximumRecognitionCandidates = 1
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                    
                    if (candidate.string.last! == "." || candidate.string.last! == "!" || candidate.string.last! == "?") {
                        currentPageText += "\(candidate.string)\n\n"
                    } else {
                        currentPageText += "\(candidate.string)"
                    }
                }
                pageTexts.append(currentPageText)
            }
            recognizeTextRequest.recognitionLevel = .accurate
            
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
                        
            pagesText.wrappedValue = pageTexts
        }
        
    }
}

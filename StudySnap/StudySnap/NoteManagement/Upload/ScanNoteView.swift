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
    @Binding var pickedFileName: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(pickedFile: $pickedFile, pickedFileName: $pickedFileName, parent: self)
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
        var pickedFileName: Binding<String>
        var parent: ScanNoteView
        
        init(pickedFile: Binding<Data>, pickedFileName: Binding<String>, parent: ScanNoteView) {
            self.pickedFile = pickedFile
            self.pickedFileName = pickedFileName
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = extractImages(from: scan)
            recognizeText(from: extractedImages)
            
            parent.presenrationMode.wrappedValue.dismiss()
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
            
            let pdfDocument = createPDF(from: pageTexts)
            // TODO: Bind PDFDocument (and pickedFileName) to upload view (problem: PDFDocument is not compatible with Data)
            pickedFile.wrappedValue = pdfDocument.dataRepresentation()!
            pickedFileName.wrappedValue = "ScannedNote.pdf"
        }
        
        fileprivate func createPDF(from extractedText: [String]) -> PDFDocument {
            let format = UIGraphicsPDFRendererFormat()
            
            let metaData = [kCGPDFContextTitle: "PDFNote"]
            
            format.documentInfo = metaData as [String: Any]
            
            let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
            
            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
            
            let data = renderer.pdfData { (context) in
                for pageText in extractedText {
                    context.beginPage()
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                                    
                    paragraphStyle.alignment = .natural
                    
                    let attributes = [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
                        NSAttributedString.Key.paragraphStyle: paragraphStyle
                    ]
                    
                    let text = pageText
                    
                    let textRect = CGRect(x: 50, y: 75, width: 495, height: 842)
                    
                    text.draw(in: textRect, withAttributes: attributes)
                }
            }
            
            let pdfDocument = PDFDocument(data: data)!
                     
            return pdfDocument
        }
        
    }
}

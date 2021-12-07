//
//  NoteEditorView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-10-09.
//

import PDFKit
import SwiftUI

struct NoteEditorView: View {
    
    @Binding var pagesText: [String]
    @Binding var pickedFile : Data
    @Binding var pickedFileName: String
    @Binding var didCompleteScan: Bool
    
    var color: Color = Color("Primary")
    
    @State private var index = 0
    
    var body: some View {
        Text("Note Editor").font(.system(size: 26, weight: .heavy, design: .default))
        Text("page \(String(index + 1) + " of " + String(pagesText.count))").font(.caption2).foregroundColor(Color("AccentReversed"))
        VStack {
            ZStack {
                TextEditor(text: $pagesText[index])
            }.padding()
                        
            Spacer()
            
            HStack {
                PrimaryButtonView(title: "Next Page", action: {
                    index += 1
                })
                    .padding()
                    .disabled(index + 1 >= $pagesText.count)
                
                PrimaryButtonView(title: "Save to PDF", action: {
                    $pickedFile.wrappedValue = createPDF(from: pagesText).dataRepresentation()!
                    $pickedFileName.wrappedValue = "ScannedNote.pdf"
                    $didCompleteScan.wrappedValue = false
                })
            }
            .padding()
        }
    }
}

private func createPDF(from extractedText: [String]) -> PDFDocument {
    let format = UIGraphicsPDFRendererFormat()
    
    let metaData = [
        kCGPDFContextTitle: "My Note",
        kCGPDFContextAuthor: "Liam Stickney"
    ]
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

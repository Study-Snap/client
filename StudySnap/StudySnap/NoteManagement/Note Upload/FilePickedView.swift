//
//  FilePickedView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-16.
//

import SwiftUI

struct FilePickedView: View {
    @Binding var pickedFile: Data
    @Binding var pickedFileName: String
    
    var body: some View {
        HStack {
            Text(pickedFileName.lowercased())
                .font(.caption)
                .foregroundColor(Color("Secondary"))
            Button(action: {
                self.pickedFile = Data()
                self.pickedFileName = ""
            }) {
                if (pickedFileName != ""){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:10,height:10)
                        .foregroundColor(Color("Secondary"))
 
                }
       
        
            }
        }.padding(.vertical, 20)
    }
}


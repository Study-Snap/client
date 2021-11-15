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
            Text(pickedFileName)
                .font(.body)
                .foregroundColor(Color("Secondary"))
            Button(action: {
                self.pickedFile = Data()
                self.pickedFileName = ""
            }) {
                if (pickedFileName != ""){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:15,height:15)
                        .foregroundColor(Color("Secondary"))
 
                }
       
        
            }
        }.padding(.bottom)
    }
}


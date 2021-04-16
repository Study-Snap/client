//
//  FilePickedView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-16.
//

import SwiftUI

struct FilePickedView: View {
    @State var picked_file: String
    var body: some View {
        HStack {
            Text(picked_file)
                .font(.body)
                .foregroundColor(Color("Secondary"))
            Button(action: {
                self.picked_file = ""
            }) {
                if (picked_file != ""){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:15,height:15)
                        .foregroundColor(Color("Secondary"))
 
                }
       
        
            }
        }.padding(.bottom)
    }
}

struct FilePickedView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickedView(picked_file: "Science note").previewLayout(.sizeThatFits)
            .padding()
    }
}

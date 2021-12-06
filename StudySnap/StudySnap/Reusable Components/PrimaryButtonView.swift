//
//  PrimaryButtonView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

struct PrimaryButtonView: View {
    let title: String
    var action: () -> Void
    var fontSize: CGFloat = 20
    var color: Color = Color("Primary")
    
    public var body: some View {
        ZStack {
            Button(action: self.action, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Primary"))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: 60, alignment: .center)
                    
                    Text(self.title).font(.custom("Inter Semi Bold", size: self.fontSize)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                }
                
            })
        }
        
    }
}

struct PrimaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonView(title: "Test Function", action: {
        
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

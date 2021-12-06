//
//  KeywordListItemView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-12-05.
//

import SwiftUI

struct KeywordListItemView: View {
    @Binding var allKeywords: [Keyword]
    var keyword: String
    
    var body: some View {
        Button(action: {
            self.allKeywords.remove(at: self.allKeywords.firstIndex(where: { $0.value == keyword })!)
        }, label: {
            Text("\(keyword)")
                .font(.caption)
                .foregroundColor(Color("Secondary"))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color("White"))
                .cornerRadius(7)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color("AccentDark")))
                .lineLimit(1)
        })
    }
}

struct KeywordListItemView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordListItemView(allKeywords: .constant([Keyword(value: "Food")]),keyword: "Food")
    }
}

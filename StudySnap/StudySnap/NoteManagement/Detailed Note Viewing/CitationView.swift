//
//  CitationView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-11-16.
//

import SwiftUI


struct CitationView: View {
    @Binding var citationAuthor: String
    @Binding var citationTitle: String
    @Binding var citationYear: String
    var body: some View {
        let fullNameArray = citationAuthor.components(separatedBy: " ")
        NavigationView {
            if (self.citationYear.count == 0 || self.citationTitle.count == 0 || self.citationAuthor.count == 0) {
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("AccentDark"))
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding()
                    Text("The author did not provide a citation")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("AccentDark"))
                    Spacer()
                    Spacer()
                }
                .cornerRadius(12)
            } else {
                VStack(alignment:.leading) {
                    Text("APA")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                        .padding(.top, 20)
                    var apaCitation = "\(fullNameArray[1]), \(fullNameArray[0]). (\(citationYear)). \(citationTitle)."
                    VStack(alignment: .leading) {
                        Text(apaCitation).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = apaCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.multilineTextAlignment(.leading)
                            .padding(20)
                    }
                    .frame(width: 300)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                        .strokeStyle()
                        
                    Text("IEEE")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                        .padding(.top, 20)
                    var ieeeCitation = "\(fullNameArray[1]), \(fullNameArray[0]), '\(citationTitle),' \(citationYear)."
                    VStack(alignment: .leading) {
                        Text(ieeeCitation).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = ieeeCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.multilineTextAlignment(.leading)
                            .padding(20)
                    }
                    .frame(width: 300).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                        .strokeStyle()
                    Text("MLA")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                        .padding(.top, 20)
                    var mlaCitation = "\(fullNameArray[1]). '\(citationTitle),' \(citationYear)."
                    VStack(alignment: .leading) {
                        Text(mlaCitation).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = mlaCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.multilineTextAlignment(.leading)
                            .padding(20)
                    }
                    .frame(width: 300).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                        .strokeStyle()
                    Spacer()
                }.navigationBarTitle("Citations", displayMode: .inline)
            }
        }
        
    }
}


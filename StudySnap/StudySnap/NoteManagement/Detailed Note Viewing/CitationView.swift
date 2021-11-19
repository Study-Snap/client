//
//  CitationView.swift
//  StudySnap
//
//  Created by Liam Stickney on 2021-11-16.
//

import SwiftUI


struct CitationView: View {
    var citation: Citation
    var body: some View {
        NavigationView {
            if self.citation.authorFirstName.count == 0 || self.citation.authorLastName.count == 0 || self.citation.publishTitle.count == 0 || (self.citation.publishYear / 1000) < 1 {
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
                    let apaCitation = "\(self.citation.authorLastName), \(self.citation.authorFirstName). (\(self.citation.publishYear)). \(self.citation.publishTitle)."
                    VStack(alignment: .leading) {
                        Text(apaCitation).multilineTextAlignment(.leading).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = apaCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.padding(20)
                    }
                    .frame(width: 300)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                        .strokeStyle()
                        
                    Text("IEEE")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                        .padding(.top, 20)
                    let ieeeCitation = "\(self.citation.authorLastName), \(self.citation.authorFirstName), '\(self.citation.publishTitle),' \(self.citation.publishYear)."
                    VStack(alignment: .leading) {
                        Text(ieeeCitation).multilineTextAlignment(.leading).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = ieeeCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.padding(20)
                    }
                    .frame(width: 300).background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x:0, y: 5)
                        .strokeStyle()
                    Text("MLA")
                        .font(.headline)
                        .foregroundColor(Color("Primary"))
                        .padding(.top, 20)
                    let mlaCitation = "\(self.citation.authorLastName). '\(self.citation.publishTitle),' \(self.citation.publishYear)."
                    VStack(alignment: .leading) {
                        Text(mlaCitation).multilineTextAlignment(.leading).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = mlaCitation
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.clipboard")
                            }
                        }.padding(20)
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


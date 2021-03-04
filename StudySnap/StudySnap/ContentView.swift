//
//  ContentView.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-03-04.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                AppLogo()
            }.frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center).background(
                Image("LandingPageBkg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
            )
        }
    }
}

struct AppLogo: View {
    var body: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    Image("Logo").padding().offset(y: -200)
                }
            }
        }
    }
}

struct BtnGetStarted: View {
    var body: some View {
        NavigationView {
            self.navigationTitle("")
                .navigationBarHidden(true)
            NavigationLink(destination: SignUpView().navigationBarHidden(true).navigationTitle("")) {
                EmptyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

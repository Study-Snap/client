//
//  StorageView.swift
//  StudySnap
//
//  Created by Malik Sheharyaar Talhat on 2021-03-19.
//

import SwiftUI

struct StorageView: View {
    @AppStorage("isAnimated") var isAnimated: Bool = true
    var body: some View {
        Text("Storage View")
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}

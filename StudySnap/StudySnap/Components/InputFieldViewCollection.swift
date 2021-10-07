//
//  InputFieldViewCollection.swift
//  StudySnap
//
//  Created by Ben Sykes on 2021-04-04.
//

import SwiftUI

// Used for safe values (non-sensitive)
struct InputField: View {
    // Styles
    var cornerRadius: CGFloat = 7.0
    var fieldHeight: CGFloat = 10.0
    var backgroundColor: Color = Color("Accent")
    var textColor: Color = Color("TextFieldPrimary")
    var borderColor: Color = Color("TextFieldPrimary")
    var textStyle: UITextContentType = .name
    var autoCap: Bool = true
    
    // Variables
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
            TextField(placeholder, text: $value)
                .padding(.vertical, fieldHeight)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: self.cornerRadius).foregroundColor(self.backgroundColor))
                .font(.body)
                .foregroundColor(self.textColor)
                .overlay(RoundedRectangle(cornerRadius: self.cornerRadius).stroke(self.borderColor))
                .textContentType(textStyle)
                .autocapitalization(autoCap ? .words : .none)
    }
}

// Used for password inputs
struct SecureInputField: View {
    // Styles
    var cornerRadius: CGFloat = 7.0
    var fieldHeight: CGFloat = 10.0
    var backgroundColor: Color = Color("Accent")
    var textColor: Color = Color("TextFieldPrimary")
    var borderColor: Color = Color("TextFieldPrimary")
    
    // Variables
    var placeholder: String
    @Binding var value: String
    
    var body: some View {
            SecureField(placeholder, text: $value)
                .padding(.vertical, fieldHeight)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: self.cornerRadius).foregroundColor(self.backgroundColor))
                .font(.body)
            .foregroundColor(self.textColor)
            .overlay(RoundedRectangle(cornerRadius: self.cornerRadius).stroke(self.borderColor))
    }
}



//
//  tessss.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 19/11/22.
//

import SwiftUI

struct SelectionTitle: View {
    
    @Binding var title: String
    @Binding var descrpition: String
    @Binding var price: Double?
    let viewSize: (CGSize) ->Void
    
    var body: some View{
        VStack{
            Group{
                TextField(text: $title, label: {
                    Text("Title")
                })
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50)
               
                TextField(value: $price, format: .number, label: {
                    Text("Price")
                })
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50)
            
                TextEditor(text: $descrpition)
                    .multilineTextAlignment(.leading)
                    .frame(height: 150)
                    .foregroundColor(.primary)
                    .padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(.primary).opacity(0.1))
            
        }
        .padding(.horizontal)
        .overlay(
            GeometryReader{ geo in
                Color.clear.onAppear{
                    withAnimation{
                        viewSize(geo.frame(in: .local).size)
                    }
                }
            }
        )
    }
}

struct SelectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SelectionTitle(title: .constant(""), descrpition: .constant(""), price: .constant(nil), viewSize: {viewSize in })
    }
}

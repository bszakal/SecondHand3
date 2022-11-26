//
//  SelectionCondition.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 19/11/22.
//

import SwiftUI

struct SelectionCondition: View {
    
    @Binding var condition: String
    let viewSize: (CGSize) ->Void

    var body: some View{
        
        VStack{
            Group{
                Text("Very Good")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .onTapGesture {
                        condition = "Very Good"
                    }
                    .modifier(selectionModifier(isSelected: condition == "Very Good"))
                Text("Good")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .onTapGesture {
                        condition = "Good"
                    }
                    .modifier(selectionModifier(isSelected: condition == "Good"))
                    
            }
           
            .contentShape(Rectangle())
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
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

struct SelectionCondition_Previews: PreviewProvider {
    static var previews: some View {
        SelectionCondition(condition: .constant(""), viewSize: {viewsize in })
    }
}

//
//  Category.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 19/11/22.
//

import SwiftUI

struct selectionCategory: View {
    @ObservedObject var createAnnounceVM: CreateAnnounceVM
    @Binding var selectedCategory: String
   var body: some View {
        
        VStack{
            ForEach(createAnnounceVM.categories){ cat in
                Text(cat.Name)
                
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(selectionModifier(isSelected: selectedCategory == cat.Name))
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCategory = cat.Name
                    }
            }
        }
    }
}

struct selectionCategory_Previews: PreviewProvider {
    static var previews: some View {
        selectionCategory(createAnnounceVM: CreateAnnounceVM(), selectedCategory: .constant(""))
    }
}

//
//  Address.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 19/11/22.
//

import SwiftUI

struct SelectionAddress: View {
    
    @Binding var addressLine: String
    @Binding var postCode: String
    @Binding var city: String
    @Binding var deliveryType: String
    let viewSize: (CGSize) ->Void
    
    var body: some View{
        VStack{
            Group{
                HStack{
                    Text("Delivery Type:")
                        .foregroundColor(.secondary)
                    Spacer()
                    Picker("Deivery Type", selection: $deliveryType) {
                        Text("Collection").tag("Collection")
                        Text("DPD").tag("DPD")
                    }
                    .tint(.primary)
                }
                   
                TextField(text: $addressLine, label: {
                    Text("Address")
                })
      
                TextField(text: $postCode, label: {
                    Text("Postcode")
                })
      
                TextField(text: $city, label: {
                    Text("City")
                })
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50)
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

struct SelectionAddress_Previews: PreviewProvider {
    static var previews: some View {
        SelectionAddress(addressLine: .constant(""), postCode: .constant(""), city: .constant(""), deliveryType: .constant(""), viewSize:{ viewSize in })
    }
}

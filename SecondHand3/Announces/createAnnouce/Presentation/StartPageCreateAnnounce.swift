//
//  StartPageCreateAnnounce.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 20/11/22.
//

import SwiftUI

struct StartPageCreateAnnounce: View {
        
    @State private var offset: CGFloat = 0
    @State private var opacity = 0.0
    let text = Array("Create your Announce")

    var body: some View {
        
        NavigationStack{
            ZStack{
                VStack{
                    titleView
                    
                    NavigationLink {
                        CreateAnnounceStartView().navigationBarBackButtonHidden()
                    } label: {
                        navlinkLabel
                    }
                }
            }
        }
        .onAppear{
            Task{
                offset = -40
                withAnimation(Animation.linear(duration: 1.8)){ opacity = 1 }
                try await Task.sleep(nanoseconds: 100_000_000)
                offset = 0
            }
        }
        .onDisappear{ opacity = 0 }
    }
    
    var navlinkLabel: some View {
        HStack{
            Spacer()
            Text("Start!")
                .modifier(buttonModifierCreateAnnouce())
                .fontWeight(.bold)
                .font(.title)
                .opacity(opacity)
            
        }
    }
    
    var titleView: some View {
        HStack(spacing:0){
            ForEach(0..<text.count){ num in
                Text(String(text[num]))
                    .offset(y:offset).animation(.linear(duration:0.2).delay(Double(num)/30), value: offset)
            }
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(.horizontal)
    }
}

struct StartPageCreateAnnounce_Previews: PreviewProvider {
    static var previews: some View {
        StartPageCreateAnnounce()
            .environmentObject(LoginState())
    }
}

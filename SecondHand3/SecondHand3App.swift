//
//  SecondHand3App.swift
//  SecondHand3
//
//  Created by Benjamin Szakal on 29/10/22.
//
import UIKit
import FacebookCore
import Firebase
import GoogleSignIn
import SwiftUI

@main
struct SecondHand3App: App {
    @UIApplicationDelegateAdaptor(Appdelegate.self) var delegate
    @StateObject var loginState = LoginState()
    var body: some Scene {
        WindowGroup {
            TestView()
                .environmentObject(loginState)
        }
    }
    
    class Appdelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
            FirebaseApp.configure()
            return true
        }
        
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            GIDSignIn.sharedInstance.handle(url)
            let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
            return handled
        }
    }
}


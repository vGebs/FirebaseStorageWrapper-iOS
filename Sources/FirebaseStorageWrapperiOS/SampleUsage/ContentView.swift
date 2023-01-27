//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-26.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                profileVM.pushImage()
            }) {
                Text("Push image")
            }.padding()
            
            Button(action: {
                profileVM.fetchImage()
            }) {
                Text("fetch image")
            }.padding()
            
            Button(action: {
                profileVM.deleteImage()
            }) {
                Text("delete img")
            }.padding()
            
            Button(action: {
                profileVM.updateMeta()
            }) {
                Text("update meta")
            }.padding()
            
            Button(action: {
                profileVM.fetchMeta()
            }) {
                Text("fetch meta")
            }.padding()
        }
    }
}

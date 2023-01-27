//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-26.
//

import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    private let imageService = ProfileImageService()
    
    init() {}
    
    func pushImage() {
        if let img = UIImage(named: "avengers"){
            imageService.pushImage(fileName: "0/img1", img: img) { err in
                if let e = err {
                    print("Error: \(e)")
                } else {
                    print("done pushing image")
                }
            }
        } else {
            print("image not there")
        }
    }
    
    func fetchImage() {
        imageService.fetchImage(fileName: "0/img1") { img, err in
            if let e = err {
                print("error fetching: \(e)")
            }
            
            if let _ = img {
                print("Fetched image")
            }
        }
    }
    
    func deleteImage() {
        imageService.deleteImage(fileName: "0/img1") { err in
            if let e = err {
                print("Failed to delete: \(e)")
            } else {
                print("image deleted")
            }
        }
    }
    
    func fetchMeta() {
        imageService.getMetaData(fileName: "0/img1") { meta, err in
            if let e = err {
                print("Failed to get meta: \(e)")
            }
            
            if let meta = meta {
                print(meta)
            }
        }
    }
    
    func updateMeta() {
        let meta = ["name": "Avengers"]
        
        imageService.updateMeta(fileName: "0/img1", metadata: meta) { err in
            if let e = err {
                print("error updating meta: \(e)")
            } else {
                print("updated meta")
            }
        }
    }
}


//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-26.
//

import Foundation
import SwiftUI

class ProfileImageService {
    
    private let storage: FirebaseStorageWrapper
    //private let folderPath: String
    private let baseURL: String
    
    init() { //maxFileSize: Int64, folderPath: String
        //self.folderPath = folderPath
        self.baseURL = "ProfileImages/"
        self.storage = FirebaseStorageWrapper(maxFileSize: 30 * 1024 * 1024)
    }
    
    func pushImage(fileName: String, img: UIImage, metaData: [String: String]? = nil, completion: @escaping (Error?) -> Void) {
        let finalPath = self.baseURL + fileName
        
        guard let imageData = img.jpegData(compressionQuality: 0.2) else {
            completion(FirebaseStorageError.unknownError)
            return
        }
        
        self.storage.uploadData(fileName: finalPath, fileData: imageData, metaData: metaData) { error in
            if let e = error {
                completion(e)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchImage(fileName: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let finalPath = self.baseURL + fileName
        storage.downloadData(fileName: finalPath) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, FirebaseStorageError.unknownError)
            }
        }
    }
    
    func deleteImage(fileName: String, completion: @escaping (Error?) -> Void) {
        let finalPath = self.baseURL + fileName
        storage.deleteFile(fileName: finalPath, completion: completion)
    }
    
    func getMetaData(fileName: String, completion: @escaping ([String: String]?, Error?) -> Void) {
        let finalPath = self.baseURL + fileName
        storage.getMetaData(fileName: finalPath) { meta, err in
            if let e = err {
                completion(nil, e)
            }
            
            if let meta = meta {
                completion(meta.customMetadata, nil)
            }
        }
    }
    
    func updateMeta(fileName: String, metadata: [String: String], completion: @escaping (Error?) -> Void) {
        let finalPath = self.baseURL + fileName
        storage.updateMetaData(fileName: finalPath, metadata: metadata, completion: completion)
    }
}

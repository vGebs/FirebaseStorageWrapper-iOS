# FirebaseStorageWrapperiOS

`FirebaseStorageWrapperiOS` is a simple and easy-to-use wrapper class for Firebase Storage. It provides an easy way to upload, download and delete files, as well as manage metadata.


## Features

- push data to storage
- fetch from storage
- delete from storage
- update meta data
- fetch meta data

## Installation

### Swift Package Manager

You can install `FirebaseStorageWrapperiOS` using the [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, open your project and navigate to File > Swift Packages > Add Package Dependency.
2. Enter the repository URL `https://github.com/vGebs/FirebaseStorageWrapper-iOS.git` and click Next.
3. Select the version you want to install, or leave the default version and click Next.
4. In the "Add to Target" section, select the target(s) you want to use `FirebaseStorageWrapperiOS` in and click Finish.

To use `FirebaseStorageWrapperiOS` in your project, you need to have:
- Firebase Storage and 
- Combine framework

You can add them to your project by following the instructions in the Firebase documentation and Apple documentation

## Usage 

Here is an example service class that demonstrates how to use the interface.

For more info, please look at the SampleUsage

```swift
import Foundation
import SwiftUI
import FirebaseStorageWrapperiOS

class ProfileImageService {
    
    private let storage: FirebaseStorageWrapper
    private let baseURL: String
    
    init() {
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

```

## Note

It's important to note that this is just an example, depending on your implementation and the architecture of your app, the `FirebaseStorageWrapperiOS` class could have more or less functionality and it is up to you to implement it in a way that fits your app.

## License 

This project is licensed under the MIT License - see the LICENSE file for details

## Contribution

If you want to contribute to this project, please follow these guidelines:

- Fork the repository and make the changes on your fork
- Test your changes to make sure they don't break existing functionality
- Create a pull request to the development branch of this repository

Please note that by contributing to this project, you agree to the terms and conditions of the MIT License.

Also, please make sure to follow the code of conduct when contributing.

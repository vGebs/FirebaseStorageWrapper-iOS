import Foundation
import FirebaseStorage

enum FirebaseStorageError: Error {
    case permissionError
    case unknownError
    case networkError
}

class FirebaseStorageWrapper {
    private let storage = Storage.storage()
    private let maxFileSize: Int64

    init(maxFileSize: Int64) {
        self.maxFileSize = maxFileSize
    }

    func uploadData(fileName: String, fileData: Data, metaData: [String: String]? = nil, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fileName)
        var uploadTask: StorageUploadTask!
        
        let meta = StorageMetadata()
        meta.customMetadata = metaData
        uploadTask = fileRef.putData(fileData, metadata: meta)
        
        uploadTask.observe(.success) { snapshot in
            completion(nil)
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                if (error as NSError).domain == "FIRStorageErrorDomain" {
                    switch (error as NSError).code {
                    case -13010:
                        completion(FirebaseStorageError.permissionError)
                    default:
                        completion(FirebaseStorageError.unknownError)
                    }
                } else {
                    completion(FirebaseStorageError.networkError)
                }
            }
        }
    }
    
    func downloadData(fileName: String, completion: @escaping (Data?, Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fileName)
        fileRef.getData(maxSize: maxFileSize) { data, error in
            if let error = error {
                if (error as NSError).domain == "FIRStorageErrorDomain" {
                    switch (error as NSError).code {
                    case -13010:
                        completion(nil, FirebaseStorageError.permissionError)
                    default:
                        completion(nil, FirebaseStorageError.unknownError)
                    }
                } else {
                    completion(nil, FirebaseStorageError.networkError)
                }
            } else {
                completion(data, nil)
            }
        }
    }

    func getMetaData(fileName: String, completion: @escaping (StorageMetadata?, Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fileName)
        fileRef.getMetadata { metadata, error in
            if let error = error {
                if (error as NSError).domain == "FIRStorageErrorDomain" {
                    switch (error as NSError).code {
                    case -13010:
                        completion(nil, FirebaseStorageError.permissionError)
                    default:
                        completion(nil, FirebaseStorageError.unknownError)
                    }
                } else {
                    completion(nil, FirebaseStorageError.networkError)
                }
            } else {
                completion(metadata, nil)
            }
        }
    }
    
    func updateMetaData(fileName: String, metadata: [String: String], completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fileName)
        let meta = StorageMetadata()
        meta.customMetadata = metadata
        fileRef.updateMetadata(meta) { metadata, error in
            if let error = error {
                if (error as NSError).domain == "FIRStorageErrorDomain" {
                    switch (error as NSError).code {
                    case -13010:
                        completion(FirebaseStorageError.permissionError)
                    default:
                        completion(FirebaseStorageError.unknownError)
                    }
                } else {
                    completion(FirebaseStorageError.networkError)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteFile(fileName: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fileName)
        fileRef.delete { error in
            if let error = error {
                if (error as NSError).domain == "FIRStorageErrorDomain" {
                    switch (error as NSError).code {
                    case -13010:
                        completion(FirebaseStorageError.permissionError)
                    default:
                        completion(FirebaseStorageError.unknownError)
                    }
                } else {
                    completion(FirebaseStorageError.networkError)
                }
            } else {
                completion(nil)
            }
        }
    }
}

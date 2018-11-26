//
//  StorageHelper.swift
//  helpr
//
//  Created by Hilmi Abou-Saleh on 2018-11-25.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import Firebase
import FirebaseStorage

class StorageHelper{
    let storage: Storage
    let storageRef:StorageReference
    init() {
        storage = Storage.storage()
        storageRef = storage.reference()

    }
    
    private func getProfilePictureReference() -> StorageReference {
        //User must be logged in to upload photo.
        return storageRef.child("profilePictures").child(Auth.auth().currentUser!.uid)
    }
    private func getJobReference(job: Job) -> StorageReference {
        return storageRef.child("jobPictures").child(job.id)
    }
    
    func postPhotos(pictures: [UIImage], completion: @escaping ([String]) -> () ){
        //TODO: Implement this.
    }
    
    func updateProfile(picture: UIImage, completion: @escaping (String) -> ()){
        var data = Data()
        data = picture.pngData()!
        let reference = getProfilePictureReference()
        let metadata  = StorageMetadata()
        metadata.contentType = "image/png"
        reference.child("profilePicture.png").putData(data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store path
                completion((metaData?.path)!)
            }
            
        }
        

    }
    func loadProfilePicture(completion: @escaping (UIImage) -> ()){
        let reference = getProfilePictureReference().child("profilePicture.png")
        let image: UIImage? = FileHelpers.load(path: reference.fullPath)
        if  image == nil {
            reference.getData(maxSize: 15 * 2048 * 2048) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                } else {
                    //let path = FileHelpers.save(image: UIImage(data: data!)!, path: reference.fullPath)
                    completion(UIImage(data: data!)!)
                }
            }
        }else{
            completion(image!)
        }
        
    }

    
}

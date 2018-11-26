//
//  Database.swift
//  helpr
//
//  Created by Hilmi Abou-Saleh on 2018-11-22.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import Firebase
import CodableFirebase

class DatabaseHelper {
    var ref: DatabaseReference!
    var jobs: [Job]
    init() {
        ref = Database.database().reference()
        jobs = [Job]()
    }
    
    func createUser(email: String, password: String, completion: @escaping (Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("Creating user: " + (user?.user.email)!)
                completion(nil)
            }else{
                print("Cannot create account" + error.debugDescription)
                completion(error)
            }
        }
    }
    
    func addUserInformation(name: String!, photoURL: String?, completion: @escaping (Error?) -> ()) {
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            
            changeRequest.displayName = name
            if photoURL != nil {
                changeRequest.photoURL =
                    NSURL(string: photoURL!)! as URL
            }
            
            changeRequest.commitChanges { error in
                if error == nil {
                    completion(nil)
                }else{
                    print("Cannot add to account" + error.debugDescription)
                    completion(error)
                }
            }
        }
    }
    
    func writeJob(job:Job) {
        
        let keyRef = self.ref!
            .child("jobs")
            .childByAutoId()
        job.setID(id: keyRef.key!)
        let data = try! FirebaseEncoder().encode(job)
        self.ref.child("jobs").child(job.id).setValue(data)

    }
    
    func readJobs(completion: @escaping ([Job]) -> ()){
        var jobs = [Job]()
        ref.child("jobs").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if snap.exists() {
                    if let dict = snap.value as? [String: Any] {
                        let job = try! FirebaseDecoder().decode(Job.self, from: dict)
                        jobs.append(job)
                    }
                }
            }
            completion(jobs)
        })
        { (error) in
            print(error.localizedDescription)
        }
    }

//    func getLatestJobFromFirebase(completion: @escaping (_ job:[Dictionary<String, Any>]) -> Swift.Void)
//    {
//        ref.child("jobs").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//                if snap.exists() {
//                    if let dict = snap.value as? [String: Any] {
//                        completion(dict)
//                    }
//                }
//            }
//        })
//        { (error) in
//            print(error.localizedDescription)
//        }
//
//    }
//
}

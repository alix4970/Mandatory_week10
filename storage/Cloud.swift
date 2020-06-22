//
//  Cloud.swift
//  Mandatory10
//
//  Created by Ali Al sharefi on 10/06/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class Cloud {
    
    private static var list = [Note]()
    private static let db = Firestore.firestore()
    private static let storage = Storage.storage()
    private static let collectionName = "notes"
    
    // Download an image
    static func downloadImage(name:String, iv:UIImageView) {
        let imgRef = storage.reference(withPath: name)
        imgRef.getData(maxSize: 40000000) { (data, error) in
            if (error) == nil {
                print("success downloading image!")
                let img = UIImage(data: data!)
                DispatchQueue.main.async {      // Prevent background thread from
                    // interrupting the main thread, which handles user input
                    iv.image = img    // Put the image inside the imageView
                }
            } else {
                print("Some error downloading \(error.debugDescription)")
            }
        }
    }
    
    // Upload an image
    static func uploadImage(name:String, image:UIImage) {
        // Create a root reference
        let storageRef = storage.reference()
        // Create a reference for image
        let imageRef = storageRef.child(name + ".jpg")
        
        let img = image.jpegData(compressionQuality: 1.0)!
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        _ = imageRef.putData(img, metadata: meta) { (metadata, error) in
            guard let metadata = metadata else {
                // Something went wrong
                print("Meta data went wrong")
                return
            }
            // Metadata contains file metadata such as size, content-type
            _ = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Something went wrong
                    print("URL went wrong")
                    return
                }
            }
        }
        
    }
    
    // CRUD
    
    // Create
    static func createNote(head:String, body:String, imageID:String) {
        
        let docRef = db.collection(collectionName).document()
        let newNote = Note(id: docRef.documentID, head: head, body: body, imageID: "Cliff.jpg")
        list.append(newNote)
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        map["imageID"] = imageID
        docRef.setData(map)
        
    }
    
    // Get notes from firebase at startup
    static func getNotes() {
        db.collection(collectionName).getDocuments(completion: { (snapshot, error) in
            if error == nil {
                self.list.removeAll()
                for note in (snapshot!.documents) {
                    // Get a map of data from the note
                    let map = note.data()
                    let head = map["head"] as! String
                    let body = map["body"] as! String
                    let imageID = map["imageID"] as? String
                    // Creating the new node object
                    let newNote = Note(id: note.documentID, head: head, body: body, imageID: imageID ?? "")
                    // Add it to the list
                    self.list.append(newNote)
                }
            }
        })
    }
    
    // Read
    static func startListener() {
        // Continually listen for changes in the database.
        print("Starting listener")
        db.collection(collectionName).addSnapshotListener { (snapshot, error) in
            if error == nil {
                // Clears the list to be able to show all the new notes and only these
                self.list.removeAll()
                for note in (snapshot!.documents) {
                    // Get a map of data from the note
                    let map = note.data()
                    let head = map["head"] as! String
                    let body = map["body"] as! String
                    let imageID = map["imageID"] as! String?
                    // Creating the new node object
                    let newNote = Note(id: note.documentID, head: head, body: body, imageID: imageID ?? "")
                    // Add it to the list
                    self.list.append(newNote)
                }
            }
            print("yes")
        }
        
    }
    
    // Update
    static func updateNote(index:Int, head:String, body:String, imageID:String) {
        let note = list[index]
        //let newNote = Note(id: note.id, head: head, body: body)
        let docRef = db.collection(collectionName).document(note.id)
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        map["imageID"] = imageID
        docRef.setData(map)
    }
    
    // Delete
    static func deleteNote(index: Int, id:String){
        // Document Reference
        let docRef = db.collection(collectionName).document(id)
        list.remove(at: index)
        docRef.delete()
    }
    
    // Count
    static func count() -> Int {
        return list.count
    }
    
    // Get note from List
    static func getNote(index: Int) -> Note {
        print("Index: \(index)")
        return list[index]
    }
    
}


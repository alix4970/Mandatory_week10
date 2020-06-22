//
//  ViewController.swift
//  Mandatory10
//
//  Created by Ali Al sharefi on 10/06/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import UIKit

var rowThatIsBeingEdited: Int = -1;

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // UITableViewDelegate is used when you need to do something to a table
    @IBOutlet weak var tableView: UITableView!
    

    @IBAction func userPressedAddHeadline(_ sender: UIButton) {
        print("Button pressed")
        Cloud.createNote(head: "New Note", body: "New Body", imageID: "default.jpg")
        tableView.reloadData()
    }
    
    
    
    // Initializing variable to hold the user input in-memory
    var userInput: String = "";
    
    // Initialize variable to hold a string that has to be displayed on the screen
    var stringDisplayed = "Welcome to MyNoteBook!";
    
    // Initializing boolean to tell if we are in editing mode
    var editingRow: Bool = false;
    
    // Variables to hold the file
    let file = "MyNoteBook.txt";
    
    // String to contain the item that we press, when shifting to new page
    var currentNote: Note = Note(id: "",head: "",body: "", imageID: "");
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Cloud.startListener()
        // Set these two to self, so the tableview references the app itself
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // Function that returns the number of Strings in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Cloud.count()
    }
    
    // Function that displays the cells in the Table View
    // If there is two Strings in the array, the following function will be called twice.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // De-queue one of the cells from the our ReusableCells, so we can reuse cells
        // in our memory. This provides us with the ability to scroll through alot of
        // cells, without filling out the system memory unnecessary.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        // Assign string from textArray to the cell
        let note = Cloud.getNote(index: indexPath.row)
        cell?.textLabel?.text = note.head
        // return the cell, and unwrap it with the !, since it is an Optional
        return cell!
    }
    
    // This enables the transition from tableview to the view controller
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        currentNote = Cloud.getNote(index: indexPath.row)
        rowThatIsBeingEdited = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SecondViewController {
            viewController.text = currentNote.head
        }
    }
    
    // EDIT
    // Function to handle cell pressed, so we can edit it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Transfer the text from the row to the user input field
        rowThatIsBeingEdited = indexPath.row;
        let secondViewController: SecondViewController = SecondViewController()
        print("Now we are in ViewController")
        print("IndexPath.row is: \(rowThatIsBeingEdited)")
        print()
        let note = Cloud.getNote(index: rowThatIsBeingEdited)
        secondViewController.text = note.head
        performSegue(withIdentifier: "showDetail", sender: nil)
        // Set editing to true
        editingRow = true;
    }
    
    // DELETE
    // Function to handle the deletion of a row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
      if editingStyle == .delete
      {
        let note = Cloud.getNote(index: indexPath.row)
        
        Cloud.deleteNote(index: indexPath.row, id: note.id)
        // Delete the given row from the table view
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    //@IBAction func downloadButtonPressed(_ sender: UIButton) {
    //    CloudStorage.downloadImage(name: "Sidney.jpg")
    //}
    
    // Function used to get the correct location on the operating system
    func getDocumentDir() -> URL
    {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }
}




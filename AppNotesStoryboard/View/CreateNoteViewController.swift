//
//  CreateNoteViewController.swift
//  AppNotesStoryboard
//
//  Created by Pierre Juarez U. on 15/06/23.
//

import UIKit

class CreateNoteViewController: UIViewController {
    
    
    @IBOutlet weak var titleNote: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var createdAt: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveNote(_ sender: Any) {
        Model.shared.saveData(title: titleNote.text ?? "", content: content.text, createdAt: createdAt.date)
        self.navigationController?.popViewController(animated: true)
    }
    

}

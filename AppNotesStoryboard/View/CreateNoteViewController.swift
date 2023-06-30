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
    
    var nota: Notas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (nota != nil) ? "Editar nota" : "Crear nota"
        titleNote.text = nota?.title
        content.text = nota?.content
        createdAt.date = nota?.createdAt ?? Date()
        btnSave.setTitle((nota != nil) ? "Editar" : "Guardar", for: .normal)
        if nota != nil {
            titleNote.addTarget(self, action: #selector(validateTextfield), for: .editingChanged)
        }else{
            validateText()
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveNote(_ sender: Any) {
        if nota != nil {
            Model.shared.editData(title: titleNote.text ?? "", content: content.text, createdAt: createdAt.date, notas: nota!)
            self.navigationController?.popViewController(animated: true)
        }else{
            Model.shared.saveData(title: titleNote.text ?? "", content: content.text, createdAt: createdAt.date)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func validateText(){
        btnSave.isEnabled = false
        btnSave.backgroundColor = .systemGray
        titleNote.addTarget(self, action: #selector(validateTextfield), for: .editingChanged)
    }
    
    @objc func validateTextfield(sender: UITextField){
        guard let titleText = titleNote.text, !titleText.isEmpty else{
            btnSave.isEnabled = false
            btnSave.backgroundColor = .systemGray
            return
        }
        btnSave.isEnabled = true
        btnSave.backgroundColor = .systemPink
    }

    

}

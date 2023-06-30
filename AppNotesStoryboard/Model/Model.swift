//
//  Model.swift
//  AppNotesStoryboard
//
//  Created by Pierre Juarez U. on 15/06/23.
//

import Foundation
import CoreData
import UIKit

class Model{
    
    public static let shared = Model()
    
    func context() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func saveData(title: String, content: String, createdAt: Date){
        let context = context()
        let entityNotas = NSEntityDescription.insertNewObject(forEntityName: "Notas", into: context) as! Notas
        entityNotas.title = title
        entityNotas.content = content
        entityNotas.createdAt = createdAt
        
        do {
            try context.save()
            print("Se guardó la nota!")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
        
    }
    
    func editData(title: String, content: String, createdAt: Date, notas: Notas){
        
        let context = context()
        notas.setValue(title, forKey: "title")
        notas.setValue(content, forKey: "content")
        notas.setValue(createdAt, forKey: "createdAt")
        
        do {
            try context.save()
            print("Se editó la nota!")
        } catch let error as NSError {
            print("Error al editar: \(error.localizedDescription)")
        }
        
    }

    
}

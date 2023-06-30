//
//  HomeViewController.swift
//  AppNotesStoryboard
//
//  Created by Pierre Juarez U. on 15/06/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tblNotes: UITableView!
    
    var notas = [Notas]()
    var fetchResultController : NSFetchedResultsController<Notas>!
    var indexSelected: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotes.delegate = self
        tblNotes.dataSource = self
        showNotes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailNoteCell", for: indexPath)
        let nota = notas[indexPath.row]
        cell.textLabel?.text = nota.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: nota.createdAt ?? Date())
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") { _, _, _ in
            print("Delete item...")
            let contexto = Model.shared.context()
            let deleteItem = self.fetchResultController.object(at: indexPath)
            contexto.delete(deleteItem)
            do {
                try contexto.save()
            } catch let error as NSError {
                print("No se pudo eliminar, error: ",error.localizedDescription)
            }
        }
        delete.image = UIImage(systemName: "trash")
        let edit = UIContextualAction(style: .normal, title: "Editar") { _, _, _ in
            print("Edit item...")
            self.indexSelected = indexPath
            self.performSegue(withIdentifier: "sendDataViewController", sender: self)
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sendDataViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDataViewController" {
            self.indexSelected = tblNotes.indexPathForSelectedRow ?? self.indexSelected
            if let id = self.indexSelected {
                let fila = notas[id.row]
                if let destino = segue.destination as? CreateNoteViewController {
                    destino.nota = fila
                }
            }
        }
    }
    
    
    func showNotes(){
        let context = Model.shared.context()
        let fetchRequest: NSFetchRequest<Notas> = Notas.fetchRequest()
        let order = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [order]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            notas = fetchResultController.fetchedObjects!
        } catch let error as NSError {
            print("Error al leer las notas: \(error.localizedDescription)")
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblNotes.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblNotes.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tblNotes.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tblNotes.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tblNotes.reloadRows(at: [indexPath!], with: .fade)
        default:
            tblNotes.reloadData()
        }
        self.notas = controller.fetchedObjects as! [Notas]
    }
    
    
}

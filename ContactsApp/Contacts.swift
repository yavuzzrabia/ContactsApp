import UIKit
import CoreData
//kaydırarak silme işlemi
class Contacts: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var peopleList = [Person]()
    var personID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData(word: "")
        tableView.reloadData()
    }
    
    func fetchData(word: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        if word != "" {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@ or surname CONTAINS %@", word, word)
        }
        let sort = NSSortDescriptor(key: #keyPath(Person.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            peopleList = try context.fetch(fetchRequest)
        } catch {
            print("Fetching failed.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPersonData" {
            let destinationViewController = segue.destination as! PersonData
            destinationViewController.personID = personID
        }
    }

    @IBAction func addPersonAction(_ sender: Any) {
        performSegue(withIdentifier: "toNewPerson", sender: nil)
    }
    
}

extension Contacts: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        if let name = peopleList[indexPath.row].name {
            if let surname = peopleList[indexPath.row].surname {
                cell.nameLabel.text = "\(name) \(surname)"
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        personID = peopleList[indexPath.row].id
        performSegue(withIdentifier: "toPersonData", sender: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            if let stringUUID = self.peopleList[indexPath.row].id?.uuidString {
                fetchRequest.predicate = NSPredicate(format: "id = %@", stringUUID)
            }
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(fetchRequest)
                for person in result as! [NSManagedObject] {
                    context.delete(person)
                    self.peopleList.remove(at: indexPath.row)
                    tableView.reloadData()
                    appDelegate.saveContext()
                    break
                }
            } catch {
                print("Fetching failed.")
            }
            
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension Contacts: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            fetchData(word: searchText)
            tableView.reloadData()
    }
}

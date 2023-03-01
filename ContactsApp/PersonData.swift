import UIKit
import CoreData
// Message Call Mail process
class PersonData: UIViewController {
    var personID: UUID?
    @IBOutlet var personImage: UIImageView!
    @IBOutlet var personNameSurname: UILabel!
    @IBOutlet var personCompany: UILabel!
    @IBOutlet var personPhone: UILabel!
    @IBOutlet var personEmail: UILabel!
    @IBOutlet var personBirthday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let id = personID?.uuidString {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let people = try context.fetch(fetchRequest) as! [NSManagedObject]
                for person in people {
                    if let image = person.value(forKey: "image") as? Data {
                        personImage.image = UIImage(data: image)
                    }
                    if let name = person.value(forKey: "name") as? String {
                        if let surname = person.value(forKey: "surname") as? String {
                            personNameSurname.text = "\(name) \(surname)"
                        }
                    }
                    if let company = person.value(forKey: "company") as? String{
                        personCompany.text = company
                    }
                    if let phone = person.value(forKey: "phone") as? Int64 {
                        personPhone.text = String(phone)
                    }
                    if let email = person.value(forKey: "email") as? String {
                        personEmail.text = email
                    }
                    if let birthday = person.value(forKey: "birthday") as? Date {
                        personBirthday.text = "\(birthday)"
                    }
                    break
                }
            } catch {
                print("Fetching failed.")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdatePerson" {
            let destinationViewController = segue.destination as! UpdatePerson
            destinationViewController.personID = personID
        }
    }
    @IBAction func editAction(_ sender: Any) {
        performSegue(withIdentifier: "toUpdatePerson", sender: nil)
    }
    @IBAction func messageAction(_ sender: Any) {
    }
    @IBAction func callAction(_ sender: Any) {
    }
    @IBAction func mailAction(_ sender: Any) {
    }
}

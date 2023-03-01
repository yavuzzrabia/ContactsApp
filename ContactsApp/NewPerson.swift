import UIKit
import CoreData
// name ve surname dolmadan done butonu aktifleştirme
//birthday'i doğru kaydet
//birthday için date picker ayarla
class NewPerson: UIViewController {

    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var personImage: UIImageView!
    @IBOutlet var personName: UITextField!
    @IBOutlet var personSurname: UITextField!
    @IBOutlet var personCompany: UITextField!
    @IBOutlet var personPhone: UITextField!
    @IBOutlet var personEmail: UITextField!
    @IBOutlet var personBirthday: UITextField!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func doneAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        if let image = personImage.image {
            let imageData = image.jpegData(compressionQuality: 0.5)
            person.setValue(imageData, forKey: "image")
        }
        if let name = personName.text {
            person.setValue(name, forKey: "name")
        }
        if let surname = personSurname.text {
            person.setValue(surname, forKey: "surname")
        }
        if let company = personCompany.text {
            person.setValue(company, forKey: "company")
        }
        if let phone = Int64(personPhone.text!) {
            person.setValue(phone, forKey: "phone")
        }
        if let email = personEmail.text {
            person.setValue(email, forKey: "email")
        }
        if let birthday = personBirthday.text {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            if let date = dateFormatter.date(from: birthday) {
                person.setValue(date, forKey: "birthday")
            }
        }
        person.setValue(UUID(), forKey: "id")
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addPhotoAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default){ (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let camera = UIAlertAction(title: "Camera", style: .default){ (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}

extension NewPerson: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        personImage.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}


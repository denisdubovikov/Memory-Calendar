//
//  AddMemoryController.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 19.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import UIKit
import CoreData

class AddMemoryController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    struct MemoryItem {
        var date: Date?
        var description: String?
        var title: String?
        var imageURL: URL?
        var imageData: Data?
    }
    
    var dateFormatter = DateFormatter()
    let coreDataManager = CoreDataManagerImpl()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var editDateButton: UIButton!
    @IBOutlet var memoryImageView: UIImageView!
    @IBOutlet var editImageButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet weak var viewWithImage: UIView!
    @IBOutlet weak var clockImageView: UIImageView!
    
    let datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    
    var titleText: String = ""
    var descriptionText: String = ""
    var dateText: Date!
    var imageURL: URL! = URL(fileURLWithPath: "")
    
    override func viewDidLoad() {
        
        doAllSetups()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editDateButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if titleTextField.text == "" {
            setupAlert()
        } else {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                self.saveToCoreData()
            }
        }
        
//        navigationController?.popToRootViewController(animated: true)
//        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editImageButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    func doAllSetups() {
        setupDateItems()
        setupTitleTextField()
        setupViewWithImage()
        setupImageView()
        setupImageButton()
    }
    
}

//MARK: Title Text Field
extension AddMemoryController {
    func setupTitleTextField() {
//        titleTextField.delegate = self
        
        titleTextField.font = UIFont(name: "Helvetica Neue", size: 22)
        titleTextField.clipsToBounds = true
        titleTextField.layer.cornerRadius = 6
        titleTextField.borderStyle = .roundedRect
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        
        
        if titleText != "" {
            self.titleTextField.placeholder = ""
            titleTextField.text = titleText
        } else {
            titleTextField.placeholder = "Enter the title"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Date Text Field & Date Picker
extension AddMemoryController {
    func setupDateItems() {
        let currentDate = Date()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        dateTextField.font = UIFont(name: "Helvetica Neue", size: 20)
        dateTextField.text = dateFormatter.string(from: currentDate)
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
//        dateTextField.inputAccessoryView = toolbar
        
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.view.addGestureRecognizer(tapGesture)
        
        clockImageView.image = UIImage(named: "Clock")
        clockImageView.contentMode = .scaleAspectFill
    }
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
    @objc func tapGestureDone() {
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
}

//MARK: Edit Date Button
extension AddMemoryController {
    func setupDateButton() {
        
    }
}

//MARK: View With Date Picker
extension AddMemoryController {
    func setupUIViewWithDatePicker() {
    
    }
}

//MARK: View With Image
extension AddMemoryController {
    func setupViewWithImage() {
        viewWithImage.clipsToBounds = true
        viewWithImage.layer.cornerRadius = 15
    }
}

//MARK: Image Button
extension AddMemoryController {
    func setupImageButton() {
        imagePicker.delegate = self
        
        editImageButton.clipsToBounds = true
//        editImageButton.layer.cornerRadius = 15
        editImageButton.setImage(UIImage(named: "Camera"), for: .normal)
        editImageButton.imageView?.contentMode = .scaleAspectFit
        
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurView = UIVisualEffectView(effect: blurEffect)

//        blurView.frame = (editImageButton.bounds.insetBy(dx: 0, dy: 0).offsetBy(dx: 0, dy: 0))
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        editImageButton.addSubview(blurView)
//        editImageButton.sendSubviewToBack(blurView)
        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.addSubview(blurView)
//        self.navigationController?.navigationBar.sendSubviewToBack(blurView)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.memoryImageView.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
        
    func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openPhotoLibrary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: Memory ImageView
extension AddMemoryController {
    func setupImageView() {
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: self.imageURL) {
//                if let image = UIImage(data: data) {
//                    self.memoryImageView.image = image
//
////                    flagImageReceived = true
////
////                    let gradient = CAGradientLayer()
////                    gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cell.cellImageView.frame.size.width, height: cell.cellImageView.frame.size.height))
////                    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
////                    gradient.locations = [0.5, 1]
////
////                    cell.cellImageView.layer.sublayers?.removeAll()
////                    cell.cellImageView.layer.addSublayer(gradient)
////
////                    cell.cellActivityIndicatorView.stopAnimating()
////                    cell.cellActivityIndicatorView.isHidden = true
//                }
//            } else {
//                //invalid url
//            }
//
////            cell.cellActivityIndicatorView.stopAnimating()
////            cell.cellActivityIndicatorView.isHidden = true
//        }
        
        memoryImageView.image = UIImage(named: "NoImage")
        memoryImageView.contentMode = .scaleAspectFill
        memoryImageView.clipsToBounds = true
        memoryImageView.layer.cornerRadius = 15
    }
}

//MARK: Description TextField
extension AddMemoryController {
    
}

//MARK:CoreData
extension AddMemoryController {
    func saveToCoreData() {
       guard let masterContext = self.coreDataManager.masterContext else {return}
        
        if let memoryEntity = NSEntityDescription.entity(forEntityName: "Memory", in: masterContext), let _ = NSEntityDescription.entity(forEntityName: "ListMemories", in: masterContext) {
            let memory = Memory(entity: memoryEntity, insertInto: masterContext)
            
            memory.date = dateFormatter.string(from: datePicker.date)
            memory.title = titleTextField.text ?? "No title"
            memory.imageURL = imageURL ?? URL(fileURLWithPath: "nil")
            memory.desc = descriptionTextView.text ?? "No description"
            
            print(dateFormatter.string(from: datePicker.date))
            
            
            memory.imageData = convertImageToData(image: memoryImageView.image!)

            self.coreDataManager.performSave(context: masterContext)
        }
    }
    
//    func saveArticles(articles : [ArticleDetail]){
//        guard let masterContext = self.coreDataManager.masterContext else {return}
//        if let articleEntity = NSEntityDescription.entity(forEntityName: "Articles", in: masterContext),
//            let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: masterContext){
//            var categoryUnwraped : Categories
//
//            if let categoryForContext = getCategory(categoryName: self.currentCategory){
//                 categoryUnwraped = categoryForContext
//            }
//            else {
//                categoryUnwraped = Categories(entity: categoryEntity, insertInto: self.coreDataManager.masterContext)
//                categoryUnwraped.name = self.currentCategory
//            }
//
//            for article in articles{
//                let articleForContext = Articles(entity: articleEntity, insertInto: masterContext)
//                articleForContext.author = article.author
//                articleForContext.content = article.content
//                articleForContext.title = article.title
//                articleForContext.date = article.publishedAt
//                articleForContext.image = article.image
//                articleForContext.descr = article.description
//                articleForContext.category = categoryUnwraped
//                categoryUnwraped.addToArticle(articleForContext)
//            }
//        }
//        self.coreDataManager.performSave(context:masterContext)
//    }
    
    func convertImageToData(image: UIImage!) -> Data! {
        let imageData = image.pngData()
        return imageData
    }
    
    func createFetchRequest() -> NSFetchedResultsController<NSFetchRequestResult>?{
            let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memory")
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    //        let predicate = NSPredicate(format: "category.name == %@", category)
            newsFetchRequest.sortDescriptors = [sortDescriptor]
    //        newsFetchRequest.predicate = predicate
            newsFetchRequest.propertiesToFetch = ["date", "desc", "imageData", "title", "imageURL"]
            
            guard let context = self.coreDataManager.masterContext else {return nil}
            let frc = NSFetchedResultsController(fetchRequest: newsFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            return frc
        }
    
//    func deleteDuplicates() {
//       guard let context = self.coreDataManager.masterContext else { return }
//            guard let memoriesFetchRequest = createFetchRequest() else { return }
//
//        var entitiesArray: [Memory] = []
//
//        do {
//            entitiesArray = try (memoriesFetchRequest.fetchedObjects as! [Memory])
//        } catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//
//        if entitiesArray.count > 0 {
//            for i in 0 ..< entitiesArray.count {
//                for j in i + 1 ..< entitiesArray.count {
//                    if entitiesArray[i].date == entitiesArray[j].date && entitiesArray[i].description == entitiesArray[j].description &&
//                        entitiesArray[i].title == entitiesArray[j].title && entitiesArray[i].imageURL == entitiesArray[j].imageURL &&
//                        entitiesArray[i].imageData == entitiesArray[j].imageData {
//                        context.delete(memory)
//
//                        self.coreDataManager.performSave(context: context)
//
//                        return
//                    }
//                }
//            }
//        }
//
//    }
    
}

//MARK: Alert
extension AddMemoryController {
    func setupAlert() {
        let alert = UIAlertController(title: "Attention!", message: "Enter the title", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Keyboard
extension AddMemoryController {
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            descriptionTextView.contentInset = .zero
        } else {
            descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset

        let selectedRange = descriptionTextView.selectedRange
        descriptionTextView.scrollRangeToVisible(selectedRange)
    }
}


//MARK: Helpful functions
extension AddMemoryController {
    override func viewDidAppear(_ animated: Bool) {
        print("Func: viewDidAppear. Notifies the view controller that its view was added to a view hierarchy.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Func: viewWillAppear. otifies the view controller that its view is about to be added to a view hierarchy.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Func: viewDidDisappear. Notifies the view controller that its view was removed from a view hierarchy.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Func: viewWillDissappear. Notifies the view controller that its view is about to be removed from a view hierarchy.")
    }
    
    override func viewDidLayoutSubviews() {
        print("Func: viewDidLayoutSubviews. Called to notify the view controller that its view has just laid out its subviews.")
    }
    
    override func viewWillLayoutSubviews() {
        print("Func: viewWillLayoutSubviews. Called to notify the view controller that its view is about to layout its subviews.")
    }
}


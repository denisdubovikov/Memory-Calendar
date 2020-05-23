//
//  HistoryController.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 13.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import UIKit
import CoreData

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dateFormatter = DateFormatter()
    let coreDataManager = CoreDataManagerImpl()
    
//    var feedTableView = UITableView()
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet var feedTableView: UITableView!
    
    struct MemoryItem {
        var date: Date?
        var description: String?
        var title: String?
        var imageURL: URL?
        var imageData: Data?
    }
    
    var memoryItems = [MemoryItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doAllSetups()
    }
    
    @IBAction func PlusButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addMemoryController = storyboard.instantiateViewController(withIdentifier: "addMemoryVC")
//        addMemoryController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(addMemoryController, animated: true)
        
//        self.present(addMemoryController, animated: true)
    }
    
    func doAllSetups() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
//        configureUI()
        setupPlusButton()
        setupTableView()
        getData()
    }
    
}

//MARK: UI
extension HistoryController {
    func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.barStyle = .black
    }
}

//MARK: Plus Button
extension HistoryController {
    func setupPlusButton() {
//        cell.viewCell.backgroundColor = .systemBackground
//        cell.viewCell.clipsToBounds = true
//        cell.viewCell.layer.cornerRadius = 20
//        cell.viewCell.layer.shadowPath = UIBezierPath(roundedRect: cell.viewCell.bounds, cornerRadius: cell.viewCell.layer.cornerRadius).cgPath
//        cell.viewCell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.viewCell.layer.shadowOpacity = 0.5
//        cell.viewCell.layer.shadowOffset = CGSize(width: 5, height: 5)
//        cell.viewCell.layer.shadowRadius = 1
//        cell.viewCell.layer.masksToBounds = false
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 33
        plusButton.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: -2, y: -5, width: plusButton.layer.frame.size.width + 4, height: plusButton.layer.frame.size.height + 10), cornerRadius: 33).cgPath
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOpacity = 0.6
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        plusButton.layer.shadowRadius = 5
        plusButton.layer.masksToBounds = false
    }
}

//MARK: CoreData
extension HistoryController {
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
    
    func getData() {
        
        guard let memoriesFetchRequest = createFetchRequest() else { return }
        
        do {
            _ = try memoriesFetchRequest.performFetch()
            let result = memoriesFetchRequest.fetchedObjects

            memoryItems.removeAll()
            
            result?.forEach {(record) in
                guard let memory = record as? Memory else {
                    return
                }

                let date = dateFormatter.date(from: memory.date!)!
                let description = memory.desc
                let title = memory.title
                let imageURL = memory.imageURL
                let imageData = memory.imageData
                
                var item = MemoryItem()
                
                
                item.date = date
                print(item.date!)
                item.description = description
                item.title = title
                item.imageURL = imageURL
                item.imageData = imageData

                self.memoryItems.append(item)
            }
        } catch {
            print("CoreData error\(error.localizedDescription)")
        }
        
        feedTableView.reloadData()
    }
    
    func removeFromData(itemToRemove: MemoryItem, index: Int) {
        
        guard let context = self.coreDataManager.masterContext else { return }
        guard let memoriesFetchRequest = createFetchRequest() else { return }
               
        do {
           _ = try memoriesFetchRequest.performFetch()
           let result = memoriesFetchRequest.fetchedObjects
           
           result?.forEach {(record) in
               guard let memory = record as? Memory else {
                   return
               }
                
                let date = dateFormatter.date(from: memory.date!)!
                let description = memory.desc
                let title = memory.title
                let imageURL = memory.imageURL
                let imageData = memory.imageData
                
                var item = MemoryItem()
                
                item.date = date
                print(item.date!)
                item.description = description
                item.title = title
                item.imageURL = imageURL
                item.imageData = imageData
            
            if item.date == itemToRemove.date && item.description == itemToRemove.description &&
                item.title == itemToRemove.title && item.imageURL == itemToRemove.imageURL &&
                item.imageData == itemToRemove.imageData {
                context.delete(memory)
                
                self.coreDataManager.performSave(context: context)
                
                return
            }
            
           }
        } catch {
           print("CoreData error\(error.localizedDescription)")
        }
    }
}


//MARK: TableView
extension HistoryController {
    
    func setupTableView() {
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
//        feedTableView = UITableView(frame: frame)
        
        feedTableView.layer.zPosition = -5
        feedTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
//        feedTableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        feedTableView.backgroundColor = .clear
        feedTableView.rowHeight = view.frame.width / 2.5
        feedTableView.isUserInteractionEnabled = true
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
//        view.addSubview(feedTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memoryItems.count)
        return memoryItems.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        cell.selectionStyle = .none
        cell.frame.size.width = view.frame.width
        cell.frame.size.height = view.frame.width / 1.5
        
        
        //ViewCell
//        cell.viewCell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.viewCell.layer.borderWidth = 1
        cell.viewCell.backgroundColor = .systemBackground
        cell.viewCell.clipsToBounds = true
        cell.viewCell.layer.cornerRadius = 20
        cell.viewCell.layer.shadowPath = UIBezierPath(roundedRect: cell.viewCell.bounds, cornerRadius: cell.viewCell.layer.cornerRadius).cgPath
        cell.viewCell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.viewCell.layer.shadowOpacity = 0.5
        cell.viewCell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.viewCell.layer.shadowRadius = 1
        cell.viewCell.layer.masksToBounds = false
        
        //Date Label
        cell.dateLabel.backgroundColor = .systemBackground
        cell.dateLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width / 2, height: cell.frame.height)
        cell.dateLabel.numberOfLines = 1
        cell.dateLabel.textColor = .gray
        cell.dateLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        cell.dateLabel.text = dateFormatter.string(from: memoryItems[indexPath.row].date!)
        
        //Title Label
        cell.titleLabel.backgroundColor = .systemBackground
        cell.titleLabel.frame = CGRect(x: cell.frame.width / 2, y: 0, width: cell.frame.width / 2, height: cell.frame.height)
        cell.titleLabel.numberOfLines = 3
        cell.titleLabel.textColor = .black
        cell.titleLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        cell.titleLabel.text = memoryItems[indexPath.row].title ?? ""
        
        //Image
        cell.memoryImage.clipsToBounds = true
        cell.memoryImage.layer.cornerRadius = 20
        cell.memoryImage.contentMode = .scaleAspectFill
        cell.memoryImage.image = UIImage(data: memoryItems[indexPath.row].imageData!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailedMemoryController = DetailedMemoryController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedMemoryController = storyboard.instantiateViewController(withIdentifier: "detailedMemoryVC") as! DetailedMemoryController
        
        detailedMemoryController.dateLabelText = memoryItems[indexPath.row].date!
//        print(memoryItems[indexPath.row].date)
        detailedMemoryController.titleLabelText = memoryItems[indexPath.row].title!
        detailedMemoryController.descriptionText = memoryItems[indexPath.row].description!
        detailedMemoryController.imageURL = memoryItems[indexPath.row].imageURL!
        detailedMemoryController.imageData = memoryItems[indexPath.row].imageData
        
//        detailedMemoryController.modalPresentationStyle = .fullScreen
        
//        self.present(detailedMemoryController, animated: true)
        self.navigationController?.pushViewController(detailedMemoryController, animated: true)
        
//        self.navigationController?.pushViewController(detailedMemoryController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let itemToRemove = self.memoryItems[indexPath.row]
            self.memoryItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.removeFromData(itemToRemove: itemToRemove, index: indexPath.row)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            let itemToRemove = self.memoryItems[indexPath.row]
            self.memoryItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.removeFromData(itemToRemove: itemToRemove, index: indexPath.row)
        }
        
        // here set your image and background color
//        deleteAction.image = UIImage(named: "PlusButton")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}


//MARK: Navigation Bar
extension HistoryController {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.frame = (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: 0).offsetBy(dx: 0, dy: 0))!
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.addSubview(blurView)
        self.navigationController?.navigationBar.sendSubviewToBack(blurView)
    }
}

//MARK: Helpful functions
extension HistoryController {
    override func viewDidAppear(_ animated: Bool) {
        print("Func: viewDidAppear. Notifies the view controller that its view was added to a view hierarchy.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Func: viewWillAppear. otifies the view controller that its view is about to be added to a view hierarchy.")
        
        getData()
        feedTableView.reloadData()
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


extension UIImage {
    var convertImageToGreyScale: UIImage? {
        return CIImage(image: self)
            .map { $0.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0]) }
            .map { UIImage(ciImage: $0, scale: 1, orientation: imageOrientation) }
    }
}


//
//  DetailedMemoryController.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 19.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import UIKit
import CoreData

class DetailedMemoryController: UIViewController {
    
    let dateFormatter = DateFormatter()
    
    var managedObjectContext: NSManagedObjectContext?
    
    let detailedMemoryController = UIViewController()
    
//    var dateLabel = UILabel()
//    var titleLabel = UILabel()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var memoryImageView: UIImageView!
//    @IBOutlet var bottomScrollView: UIScrollView!
//    @IBOutlet var labelScrollView: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var dateLabelText: Date!
    var titleLabelText: String = ""
    var descriptionText: String = ""
    var imageURL: URL!
    var imageData: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doAllSetups()

        // Do any additional setup after loading the view.
    }
    
    func doAllSetups() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        setupDateLabel()
        setupTitleLabel()
        setupMemoryImageView()
        setupDescriptionTextView()
//        setupScrollView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: Date Label
extension DetailedMemoryController {
    func setupDateLabel() {
        dateLabel.text = dateFormatter.string(from: dateLabelText)
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        
    }
}

//MARK: Title Label
extension DetailedMemoryController {
    func setupTitleLabel() {
        titleLabel.text = titleLabelText
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 30)
    }
}

//MARK: Memory ImageView
extension DetailedMemoryController {
    func setupMemoryImageView() {
        if imageData != nil {
            memoryImageView.image = UIImage(data: imageData)
        } else {
            memoryImageView.image = UIImage(named: "Default image")
        }
        
        self.memoryImageView.contentMode = .scaleAspectFill
        self.memoryImageView.clipsToBounds = true
        self.memoryImageView.layer.cornerRadius = 20
    }
}

//MARK: Description Text View
extension DetailedMemoryController {
    func setupDescriptionTextView() {
        descriptionTextView.text = descriptionText
        descriptionTextView.isUserInteractionEnabled = false
        descriptionTextView.allowsEditingTextAttributes = false
    }
}

//MARK: Scroll View + Label
//extension DetailedMemoryController {
//    func setupScrollView() {
//        bottomScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: labelScrollView.bottomAnchor).isActive = true
//        setupLabelScrollView()
//    }
//
//    func setupLabelScrollView() {
//        labelScrollView.text = descriptionLabelText
//    }
//}

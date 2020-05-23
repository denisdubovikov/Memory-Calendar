//
//  CustomCell.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 21.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

//    lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        label.frame = self.frame
//        return label
//    }()
//    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.frame = self.frame
//        return label
//    }()
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//    
//    override func layoutSubviews() {
//        addSubview(dateLabel)
//        addSubview(titleLabel)
//    }
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    
}

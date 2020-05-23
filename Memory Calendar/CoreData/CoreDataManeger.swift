//
//  CoreDataManeger.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 21.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func performSave(context: NSManagedObjectContext)
}

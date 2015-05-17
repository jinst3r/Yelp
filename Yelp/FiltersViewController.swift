//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Jon Choi on 5/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

enum FiltersRowIdentifier : String {
    case OfferingADeal = "Offering a Deal"
    case Distance = "Distance"
    case SortBy = "Sort By"
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    let tableStructure: [[FiltersRowIdentifier]] = [[.OfferingADeal], [.Distance], [.SortBy]]
    var filterValues: [FiltersRowIdentifier : Bool] = [:]

    var currentFilters: SearchSettings! {
        didSet {
            filterValues[.OfferingADeal] = currentFilters.OfferingADeal
            filterValues[.Distance] = currentFilters.Distance
            filterValues[.SortBy] = currentFilters.SortBy
            tableView?.reloadData()
        }
    }
    
    func filtersFromTableData() -> SearchSettings {
        let ret = SearchSettings()
        ret.OfferingADeal = filterValues[.OfferingADeal] ?? ret.OfferingADeal
        ret.Distance = filterValues[.Distance] ?? ret.Distance
        ret.SortBy = filterValues[.SortBy] ?? ret.SortBy
        return ret
    }
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentFilters = currentFilters ?? SearchSettings()
//        categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
//        return 4
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
        return tableStructure[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

        let filterIdentifier = tableStructure[indexPath.section][indexPath.row]
        cell.filterRowIdentifier = filterIdentifier
        cell.onSwitch.on = filterValues[filterIdentifier]!
        
//        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
//        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!

        switchStates[indexPath.row] = value
        // how does "value" have a value
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
        ["name" : "Chinese", "code" : "chinese"]
        ]
    }

}

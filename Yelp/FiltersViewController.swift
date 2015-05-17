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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DropDownCellDelegate {

    var arrayForBool : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    let tableStructure: [[FiltersRowIdentifier]] = [[.OfferingADeal], [.Distance], [.SortBy]]
    var filterValues: [FiltersRowIdentifier : AnyObject] = [:]

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
        ret.OfferingADeal = filterValues[.OfferingADeal] as? Bool
        ret.Distance = filterValues[.Distance] as? Int
        ret.SortBy = filterValues[.SortBy] as? Int
        return ret
    }
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayForBool = ["0","0"]
        
        currentFilters = currentFilters ?? SearchSettings()
//        categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // trying to get rid of the white inset in the cell separator
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

    
    
    // sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
    }
    
    // headers
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["Offering a Deal", "Distance", "Sort By"]
        return titles[section]
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
        return tableStructure[section].count
    }

    // switch stuff
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            let filterIdentifier = tableStructure[indexPath.section][indexPath.row]
            cell.filterRowIdentifier = filterIdentifier
//            cell.onSwitch.on = filterValues[filterIdentifier]!
//            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
//            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            return cell
        
        } else if indexPath.section == 1 || indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            let filterIdentifier = tableStructure[indexPath.section][indexPath.row]
            cell.filterRowIdentifier = filterIdentifier
            //        cell.onSwitch.on = filterValues[filterIdentifier]!
            //        cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            //        cell.onSwitch.on = switchStates[indexPath.row] ?? false
            return cell
        }
        
        return cell
        
    }
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!

        switchStates[indexPath.row] = value
        // how does "value" have a value
    }
    
    // dropdown stuff

    
    
    
    
    // inspired by https://github.com/fawazbabu/Accordion_Menu
//    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
//        println("tapping! holler")
//        println(recognizer.view?.tag)
//        
//        var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
//        if (indexPath.row == 0) {
//            var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
//            collapsed = !collapsed;
//            
//            arrayForBool.replaceObjectAtIndex(indexPath.section, withObject: collapsed)
//
//            //reload specific section animated
//            var range = NSMakeRange(indexPath.section, 1)
//            var sectionToReload = NSIndexSet(indexesInRange: range)
//            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
//            
//        }
//    }
    
    // should get rid of this?
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
        ["name" : "Chinese", "code" : "chinese"]
        ]
    }

}

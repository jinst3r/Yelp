//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Jon Choi on 5/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject], didUpdateDeal deal: Bool)
}

enum FiltersRowIdentifier : String {
    case OfferingADeal = "Offering a Deal"
    case Distance = "Distance"
    case SortBy = "Sort By"
    case Categories = "Categories"
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DropDownCellDelegate, OfferCellDelegate {

    var searchSettings = SearchSettings()
    var businesses: [Business]!
    
    // for drop down
    // excuse the janky code... 45 min before due
    let expandArrayOne = [1,5]
    var expandKeyOne = 0
    var clickCountOne = 0
    var selectedOne = Int()
    
    let expandArrayTwo = [1,3]
    var expandKeyTwo = 0
    var clickCountTwo = 0
    var selectedTwo = Int()
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    var offerState = [Int:Bool]()
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    let tableStructure: [[FiltersRowIdentifier]] = [[.OfferingADeal], [.Distance], [.SortBy], [.Categories]]
    var filterValues: [FiltersRowIdentifier : AnyObject] = [:]

    var currentFilters: SearchSettings! {
        didSet {
            filterValues[.OfferingADeal] = currentFilters.OfferingADeal
            filterValues[.Distance] = currentFilters.Distance
            filterValues[.SortBy] = currentFilters.SortBy
            filterValues[.Categories] = currentFilters.Categories
            tableView?.reloadData()
        }
    }
    
    func filtersFromTableData() -> SearchSettings {
        let ret = SearchSettings()
        ret.OfferingADeal = filterValues[.OfferingADeal] as? Bool
        ret.Distance = filterValues[.Distance] as? Int
        ret.SortBy = filterValues[.SortBy] as? Int
        ret.Categories = filterValues[.Categories] as? [String]
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        arrayForBool = ["0","0"]
        
        currentFilters = currentFilters ?? SearchSettings()
        categories = yelpCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        offerState = [0: false]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // should send back deal, distance and rating info as well here
        
        //this is being sent to...
        var filters = [String : AnyObject]()
        var deal: Bool = offerState[0]!

        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                // array of dictionaries
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        println(selectedCategories)
        delegate?.filtersViewController?(self, didUpdateFilters: filters, didUpdateDeal: deal)
    }

    
    // sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
    }
    
    // headers
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // this should be dynamic ideally
        let titles = ["Deals", "Distance", "Sort By", "Search by Cuisine"]
        return titles[section]
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    // rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath was called")
        if (indexPath.section == 1) {
            clickCountOne += 1
            expandKeyOne = clickCountOne % 2
            println(expandArrayOne[expandKeyOne])
            println(indexPath.row)
            println(indexPath.section)
            selectedOne = indexPath.row
            self.tableView.reloadData()
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else if (indexPath.section == 2) {
            clickCountTwo += 1
            expandKeyTwo = clickCountTwo % 2
            println(expandArrayTwo[expandKeyTwo])
            println(indexPath.row)
            println(indexPath.section)
            selectedTwo = indexPath.row
            self.tableView.reloadData()
        }
        //        var cell = tableView.cellForRowAtIndexPath(indexPath) as! DropDownCell
        //        switch selectedIndexPath {
        //        case nil:
        //            selectedIndexPath = indexPath
        //        default:
        //            if selectedIndexPath! == indexPath {
        //                selectedIndexPath = nil
        //            } else {
        //                selectedIndexPath = indexPath
        //            }
        //        }
//            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//            tableView.reloadRowsAtIndexPaths(1.1, withRowAnimation: UITableViewRowAnimation.Automatic)
            //
        //        if indexPath.section == 2 {
        //
        
        //            var tableView.numberOfRowsInSection(2) = 4
        //            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        //        }
//            func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//                //        return categories.count
//                //        return tableStructure[section].count
//                expandKey = 1
//                
//                if section == 3 {
//                    println(yelpCategories().count)
//                    return yelpCategories().count
//                } else if section == 1 {
//                    return expandArray[expandKey]
//                } else if section == 2 {
//                    return expandArray[expandKey]
//                } else {
//                    return 1
//                }
//                
//            }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
//        return tableStructure[section].count
        
        if section == 3 {
            println(yelpCategories().count)
            return yelpCategories().count
        } else if section == 1 {
            return expandArrayOne[expandKeyOne]
        } else if section == 2 {
            return expandArrayTwo[expandKeyTwo]
        } else {
            return 1
        }
        
    }

//    func oneWasTapped(recognizer: UITapGestureRecognizer) {
//        println("one was tapped")
//        println(recognizer.view?.tag)
//        
//    }
//
//    func twoWasTapped(recognizer: UITapGestureRecognizer) {
//        println("two was tapped")
//        println(recognizer.view?.tag)
//    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("OfferCell", forIndexPath: indexPath) as! OfferCell
            let filterIdentifier = tableStructure[indexPath.section][indexPath.row]
            cell.filterRowIdentifier = filterIdentifier
//            cell.onSwitch.on = filterValues[filterIdentifier]!
//            cell.offerLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.offerButton.on = offerState[indexPath.row] ?? false
            println(offerState)
            println("offerState ?? false")
            return cell
        
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            let distanceLabels = ["Auto","0.3 miles", "1 mile", "5 miles", "20 miles"]
            cell.dropDownLabel.text = distanceLabels[indexPath.row]
            if indexPath.row == 0 {
                cell.dropDownButton.setImage(UIImage(named: "circle-tick-7"), forState: UIControlState.Normal)
            } else {
                cell.dropDownButton.setImage(UIImage(named: "dot-more-7"), forState: UIControlState.Normal)
            }
            return cell

        } else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("DropDownCell", forIndexPath: indexPath) as! DropDownCell
            let sortByLabels = ["Best Match", "Distance", "Rating"]
            cell.dropDownLabel.text = sortByLabels[indexPath.row]
            if indexPath.row == 0 {
                cell.dropDownButton.setImage(UIImage(named: "circle-tick-7"), forState: UIControlState.Normal)
            } else {
                cell.dropDownButton.setImage(UIImage(named: "dot-more-7"), forState: UIControlState.Normal)
            }
            return cell
            
        } else if indexPath.section == 3 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            //        cell.onSwitch.on = filterValues[filterIdentifier]!
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            return cell
        }
        
        return cell
        
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!

        switchStates[indexPath.row] = value
        println("func switchcell")
    }

    func offerCell(offerCell: OfferCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(offerCell)!
        
        offerState[indexPath.row] = value
        println("func offercell")
        println(offerState)
    }
    
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
    
    func yelpCategories() -> [[String:String]] {
        let categories: [[String:String]] = [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
        
        return categories
    }

    
    
}

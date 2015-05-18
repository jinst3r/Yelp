//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    var searchBar: UISearchBar!
    var searchSettings = SearchSettings()
    
    @IBOutlet weak var filtersBarButton: UIBarButtonItem!
    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add UIRefresh?
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"

//        dark red search bar can be implemented with below
//        searchBar.searchBarStyle = UISearchBarStyle.Minimal
//        searchBar.tintColor = UIColor.whiteColor()

        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem?.image = UIImage(named: "list-fat-7")
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!], forState: UIControlState.Normal)

        doSearchBasic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell

        cell.business = businesses[indexPath.row]

        // gets rid of white margin on the left hand side
        if (cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
            cell.preservesSuperviewLayoutMargins = false
        }
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))){
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        return cell
    }
    
    // I don't understand this really well...
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject], didUpdateDeal deal: Bool) {

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // ...here
        var categories = filters["categories"] as? [String]
        var offeringDeal = deal
        
        // pass in the other search settings here. sort and deals
        Business.searchWithTerm("Restaurants", sort: searchSettings.sortArray[searchSettings.SortBy!], categories: categories, deals: offeringDeal) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        
        scrollToTop()
    }
    
    func doSearchBasic() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm("Korean", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })

        // error mode?
    }
    
    func doSearchAdvanced() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Business.searchWithTerm(searchSettings.searchString!, sort: searchSettings.sortArray[searchSettings.SortBy!], categories: searchSettings.categories, deals: searchSettings.OfferingADeal) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            // why doesn't it go to the top of the search results?
            

            println(self.searchSettings.searchString)
            println(self.searchSettings.SortBy)
            println(self.searchSettings.Categories)
            println(self.searchSettings.OfferingADeal)
            
//            for business in businesses {
//                println(business.name!)
//                println(business.address!)
//            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
    }
    
    func scrollToTop() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearchAdvanced()
        scrollToTop()
    }
}



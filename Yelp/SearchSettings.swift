//
//  SearchSettings.swift
//  Yelp
//
//  Created by Jon Choi on 5/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

class SearchSettings {
    var searchString: String?
    var sortArray: [YelpSortMode?] = [.BestMatched, .Distance, .HighestRated]
    var OfferingADeal: Bool?
//    var Distance: String?
//    var SortBy: YelpSortMode?
    var Distance: Int?
    var SortBy: Int? = 2
    var categories: [String]?

    
    init() {
        
    }
}
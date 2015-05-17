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
    var minStars = 0
    var deals: Bool?
    var sortArray: [YelpSortMode?] = [.BestMatched, .Distance, .HighestRated]

    var OfferingADeal = true
//    var Distance: String?
//    var SortBy: YelpSortMode?
    var Distance = true
    var SortBy = true

    
    init() {
        
    }
}
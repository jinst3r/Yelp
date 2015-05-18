//
//  OfferCell.swift
//  Yelp
//
//  Created by Jon Choi on 5/17/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol OfferCellDelegate {
    optional func offerCell(offerCell: OfferCell, didChangeValue value: Bool)
}


class OfferCell: UITableViewCell {

    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var offerButton: UISwitch!
    
    weak var delegate: OfferCellDelegate?
    
    var filterRowIdentifier: FiltersRowIdentifier! {
        didSet {
            offerLabel?.text = filterRowIdentifier?.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        offerButton.addTarget(self, action: "offerValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func offerValueChanged() {
        delegate?.offerCell?(self, didChangeValue: offerButton.on)
    }
}

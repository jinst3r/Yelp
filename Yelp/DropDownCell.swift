//
//  DropDownCell.swift
//  Yelp
//
//  Created by Jon Choi on 5/17/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DropDownCellDelegate {
    optional func dropDownCell(dropDownCell: DropDownCell, didChangeValue value: Bool)
}

class DropDownCell: UITableViewCell {

    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    
    weak var delegate: DropDownCellDelegate?
    
    var filterRowIdentifier: FiltersRowIdentifier! {
        didSet {
            dropDownLabel?.text = filterRowIdentifier?.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dropDownButton.addTarget(self, action: "dropDownTouched", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dropDownValueChanged() {
        // add code here
    }

}

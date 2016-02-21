//
//  PokemonDetailVC.swift
//  my-pokedex
//
//  Created by Mengying Feng on 13/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bioContainerView: UIView!
    @IBOutlet weak var movesContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioContainerView.hidden = false
        movesContainerView.hidden = true
        
        let font: UIFont = UIFont(name: "Lato-Regular", size: 12.0)!
        let attr = [
            NSFontAttributeName: font
        ]
        
        segmentedControl.setTitleTextAttributes(attr, forState: .Normal)
        
        nameLbl.text = pokemon.name.capitalizedString

    }
    
    // MARK: UISegmentedController
    // all the views load at the same time
    @IBAction func segmentSelected(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            self.bioContainerView.hidden = false
            self.movesContainerView.hidden = true
            
            
        } else if sender.selectedSegmentIndex == 1 {
            self.bioContainerView.hidden = true
            self.movesContainerView.hidden = false

        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowBio" {
            let destinationVC = segue.destinationViewController as! BioContainerViewController
            destinationVC.passedData = pokemon
        } else if segue.identifier == "ShowMoves" {
            let destinationVC = segue.destinationViewController as! MovesContainerViewController
            destinationVC.passedData = pokemon
        }
    }
    
    
}

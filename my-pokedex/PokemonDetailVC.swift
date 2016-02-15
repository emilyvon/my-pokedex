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
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLab: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
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
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            // this will be called after download is done
            // would not run right away
            // prevent views from crashing before they are downloaded
            self.updateUI()
            
            
            
        }
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
    
    func updateUI() {
        // no need to use if let because we guarantee they will have a value in Pokemon.swift
        descriptionLab.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        
        // previously we guarantee nextEvolutionId will have a value or ""
        // if it's "", we need to hide the image
        // stackview can automatically center image for us
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            evoLbl.text = str
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

//
//  BioContainerViewController.swift
//  my-pokedex
//
//  Created by Mengying Feng on 15/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import UIKit

class BioContainerViewController: UIViewController {

    var passedData: Pokemon!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "\(passedData.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        passedData.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }

    func updateUI() {
        // no need to use if let because we guarantee they will have a value in Pokemon.swift
        descriptionLab.text = passedData.description
        typeLbl.text = passedData.type
        defenseLbl.text = passedData.defense
        heightLbl.text = passedData.height
        pokedexLbl.text = "\(passedData.pokedexId)"
        weightLbl.text = passedData.weight
        attackLbl.text = passedData.attack
        
        // previously we guarantee nextEvolutionId will have a value or ""
        // if it's "", we need to hide the image
        // stackview can automatically center image for us
        if passedData.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: passedData.nextEvolutionId)
            var str = "Next Evolution: \(passedData.nextEvolutionTxt)"
            
            if passedData.nextEvolutionLvl != "" {
                str += " - LVL \(passedData.nextEvolutionLvl)"
                evoLbl.text = str
            }
        }
    }
    

}

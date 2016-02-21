//
//  Pokemon.swift
//  my-pokedex
//
//  Created by Mengying Feng on 13/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    
    private var _pokemonUrl: String!
    
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutiionId: String!
    private var _nextEvolutionLvl: String!
    
    var moveLearnTypes = [String]()
    var moveNames = [String]()
    
    // name is guaranteed to have a value because we have initialized it
    var name: String {
        return _name
    }
    
    // pokedexId is guaranteed to have a value because we have initialized it
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        // we guarantee _nextEvolutionLvl has a value
        // but the request result might not have a value
        // if it doesn't have a value, make sure to assign it an empty string to pass it through to PokemonDetailVC to avoid the crashing
        
        // nil
        if _description == nil {
            _description = ""
        }
        
        // not nil
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionId: String {
        if _nextEvolutiionId == nil {
            _nextEvolutiionId = ""
        }
        return _nextEvolutiionId
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    // pass the closure from Constants.swift
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!

        // async: need to wait for this to download
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight}
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    // print(types.debugDescription)
                    
                    // if there is only one type
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    // if more than one type
                    if types.count > 1 {
                        // start from 1 because element 0 has been accounted for above
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                // add to type
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    // if there is no types
                    self._type = ""
                }
                
                // DESCRIPTIONS
                // get the first description from descriptions
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) -> Void in
                            
                            // get the description data
                            if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                            // when the description request is done (weather successfully or not, it might not have a description)
                            // execute the closure in PokemonDetailVC.swift
                            completed()
                            
                        })
                    }
                } else {
                    self._description = ""
                }
                
                // EVOLUTIONS
                // 1. check there is at least one evolution
                // parse evolutions
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        
                        // 2. evolution is not a mega pokemon
                        // api still has mega data
                        // ignore any mega pokemon evolutions because we don't have the graphics
                        // ignore evolutions with mega in the name
                        if to.rangeOfString("mega") == nil {
                            //3. description url already has the next evolution pokemon id
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutiionId = num
                                self._nextEvolutionTxt = to
                                
                                // some evolution pokemon does not have a level in the api
                                if evolutions[0]["level"] != nil {
                                    if let lvl = evolutions[0]["level"] as? Int {
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                        }
                    }
                }
                
                // get moves learn_type and name
                if let movesArr = dict["moves"] as? [Dictionary<String, AnyObject>] where movesArr.count > 0 {
                    for var x = 0; x < movesArr.count; x++ {
                        if let moveType = movesArr[x]["learn_type"] {
                            self.moveLearnTypes.append(moveType as! String)
                        }
                        if let moveName = movesArr[x]["name"] {
                            self.moveNames.append(moveName as! String)
                        }
                    }
                }
            } // end pokemon result
        } // end pokemon request
    }
}

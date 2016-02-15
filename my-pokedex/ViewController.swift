//
//  ViewController.swift
//  my-pokedex
//
//  Created by Mengying Feng on 13/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    // store filter pokomons
    var filteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        initAudio()
        
        // initialize pokemons
        parsePokemonCSV()
    }
    
    func initAudio() {
        // get the music path
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            // infinite loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.2
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: Parse pokemon.csv
    
    func parsePokemonCSV() {
        // get the path of pokemon.csv
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //            print(rows)
            for row in rows {
                // id
                let pokeId = Int(row["id"]!)!
                // name
                let name = row["identifier"]!
                // initialize pokemons
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCollectionViewCell {
            //            print(indexPath.row)
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // when user taps on an item, we grab it and pass it to the PokemonDetailVC
    // item can be selected in the regular pokemon array or the filteredPokemon array
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    // if playing, pause; if not playing, play
    @IBAction func musicBtnPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.4
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // MARK: - Segue
    // MARK: Segue to PokemonDetailVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    // filter list whenever user type in letters
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // no text in search bar
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            // when search bar is empty, dismiss keyboard
            dismissKeyboard()
        } else {
            // start filtering
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            // grabbing element from an array whose name contains the text in search bar
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
        }
        collection.reloadData()
    }
    
    // dismiss keyboard when user taps Done button on keyboard
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
    }

    // dismiss keyboard when user starts scrolling the collection view
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

}


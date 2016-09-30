//
//  ViewController.swift
//  Pokedex
//
//  Created by Kel Robertson on 28/09/2016.
//  Copyright © 2016 Kel Robertson. All rights reserved.
//

import UIKit
//working woth audio must inmport AVFoundation
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicButton: UIButton!
    
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
       
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "pokemonTheme", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // deques the cells and sets them up, recycling old cells making application load quicker.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? pokeCell {
            
            let poke: Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    //tap on a cell execute when tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "pokemonDetailVC", sender: poke)
    }
    
    // number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
           return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    //number of sections in view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //defines size of cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //When a keystroke in search bar is made any thing below func will be called.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            //the filter pokemon list is going to be equal to the orginal pokemon list filtered, by taking $0 (placeholder for all objects) name value and filtering based on the lowercased text.
            //$$0 placeholder for each item in array[] specified
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    //sends data to new segue (anyobject)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if segue ident is = pokemonDetailVC
        if segue.identifier == "pokemonDetailVC" {
            //create a variable for deatilVS and destinaion is pokemonDetailVC
            if let detailVC = segue.destination as? pokemonDetailVC {
                //creating poke and sending as class pokemon
                if let poke = sender as? Pokemon {
                    //grab var pokemon from detailVC and set it to poke
                    detailVC.pokemon = poke
                    detailVC.player = musicPlayer
                }
            }
        }
    }
}


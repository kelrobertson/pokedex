//
//  pokeCell.swift
//  Pokedex
//
//  Created by Kel Robertson on 29/09/2016.
//  Copyright © 2016 Kel Robertson. All rights reserved.
//

import UIKit

class pokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon:Pokemon){
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}

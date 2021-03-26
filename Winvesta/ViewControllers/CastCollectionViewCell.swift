//
//  CastCollectionViewCell.swift
//  Winvesta
//
//  Created by Sagar kumar on 26/03/21.
//

import Foundation
import UIKit
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var castLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        image.image = nil
    }
    
    func callForUse(_ imageUrl: String, _ name: String, _ charName: String) {
        
        image.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "CastImage"))
        castLbl.text = "\(name) \n Charater Name: \(charName)"
    }
    
    func emptyImage(_ name: String, _ charName: String){
        image.image = UIImage(named: "CastImage")
        castLbl.text = "\(name) \n Charater Name: \(charName)"
        
    }
    
}

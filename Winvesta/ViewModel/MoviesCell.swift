//
//  MoviesCell.swift
//  Winvesta
//
//  Created by Sagar kumar on 23/03/21.
//

import Foundation
import UIKit
import FlexibleGauge


class MoviesCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var percentageLoader: FlexibleGauge!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        image.image = nil
        movieName.text = nil
    }
    
    func callForUse(_ imageUrl: String, _ name: String ) {
        
        image.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
        movieName.text = name
    }
    
    func loadPercentageLoader(_ data: Double){
        let value = Int(data * 10)
        if value > 70{
            percentageLoader.emptyColor = UIColor.green.withAlphaComponent(0.3)
            percentageLoader.filledColor = UIColor.green.withAlphaComponent(1)
            percentageLoader.innerTextColor = UIColor.green.withAlphaComponent(1)
            percentageLoader.innerText = String(value).appending("%")
        } else{
            percentageLoader.emptyColor = UIColor.red.withAlphaComponent(0.3)
            percentageLoader.filledColor = UIColor.red.withAlphaComponent(1)
            percentageLoader.innerTextColor = UIColor.red.withAlphaComponent(1)
            percentageLoader.innerText = String(value).appending("%")
            
        }
        percentageLoader.value = CGFloat(value)
    }
}

//extension MoviesCell: NibLoadableView {
//}

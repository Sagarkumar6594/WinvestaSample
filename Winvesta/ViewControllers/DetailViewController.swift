//
//  DetailViewController.swift
//  Winvesta
//
//  Created by Sagar kumar on 25/03/21.
//

import Foundation
import UIKit
import FlexibleGauge
import TMDBSwift
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var votesView: FlexibleGauge!
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var creatorLbl: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var overviewLbl: UILabel!
    
    @IBOutlet weak var crewLbl: UILabel!
    //Values
    var name: String?
    var id: Int?
    var discription: String?
    var votes: Double?
    var image: String?
    var genre: NSObject?
    var crewData: [CrewMDB]?
    var castData = [MovieCastMDB]()
    
    var crewFilter: String{
        get{
            var strCreator = ""
            if let crew = crewData {
                for individual in crew{
                    if individual.job == "Director" || individual.job == "Producer", let nameIndividual = individual.name, let jobIndividual = individual.job{
                        strCreator.append("\(bullet) \(String(describing: jobIndividual)): \(String(describing: nameIndividual)) \n")
                    } else if let nameIndividual = individual.name, let jobIndividual = individual.job{
                        strCreator.append("\(bullet) \(String(describing: jobIndividual)): \(String(describing: nameIndividual)) \n")
                    }
                }
                return strCreator
            }
            
            return strCreator
        }
    }
    
    var filterGenres: String{
        get{
            var str = ""
            if let genresData = genre as? [Int]{
                for indiGenre in genresData{
                    if indiGenre == genresData.last{
                        if let dataStr = MovieGenres.init(rawValue: String(indiGenre)){
                            str.append("\(String(describing: dataStr))")
                        }
                    } else{
                        if let dataStr = MovieGenres.init(rawValue: String(indiGenre)){
                            str.append("\(String(describing: dataStr)), ")
                        }
                    }
                    
                }
            }
            return str
        }
    }
    
    var creatorMethod: String{
        get{
            var strCreator = ""
            if let crew = crewData {
                for individual in crew{
                    if individual.job == "Director" || individual.job == "Producer", let nameIndividual = individual.name, let jobIndividual = individual.job{
                        strCreator.append("\(bullet) \(String(describing: jobIndividual)): \(String(describing: nameIndividual)) \n")
                    }
                }
                return strCreator
            }
            return strCreator
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let idMovie = id{
            apiCrew(idMovie)
        }
        self.castCollectionView.delegate = self
        self.castCollectionView.dataSource = self
        self.title = name
        setUp()
    }
    
    func apiCrew(_ idMovie: Int){
        MovieMDB.credits(movieID: idMovie) { (dataReturn, creditMBD) in
            if let crewRecieved = creditMBD{
                if let cast = crewRecieved.cast as? [MovieCastMDB], let crew = crewRecieved.crew as? [CrewMDB]{
                    self.crewData = crew
                    self.castData = cast
                    self.crewLbl.text = self.crewFilter
                    self.castCollectionView.reloadData()
                }
                self.creatorLbl.text = self.creatorMethod
                
            }
        }
    }
    
    
    func setUp() {
        self.genresLabel.text = filterGenres
        guard let imageData = image, let nameData = name, let discriptionData = discription, let votesData = votes else {
            return
        }
        let imageStr = imageUrl.appending(imageData)
        movieImg.sd_setImage(with: URL(string: imageStr), placeholderImage: nil)
        nameLbl.text = nameData
        overviewLbl.text = "Overview: \n \n\(discriptionData)"
        loadPercentageLoader(votesData)
    }
    
    func loadPercentageLoader(_ data: Double){
        let value = Int(data * 10)
        if value > 70{
            votesView.emptyColor = UIColor.green.withAlphaComponent(0.6)
            votesView.filledColor = UIColor.green.withAlphaComponent(1)
            votesView.innerTextColor = UIColor.green.withAlphaComponent(1)
            votesView.innerText = String(value).appending("%")
        } else{
            votesView.emptyColor = UIColor.red.withAlphaComponent(0.6)
            votesView.filledColor = UIColor.red.withAlphaComponent(1)
            votesView.innerTextColor = UIColor.red.withAlphaComponent(1)
            votesView.innerText = String(value).appending("%")
            
        }
        votesView.value = CGFloat(value)
    }
    
}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCast", for: indexPath) as! CastCollectionViewCell
        let data = castData[indexPath.row]
        if let image = data.profile_path, let name = data.name, let charName = data.character{
            let imageStr = imageUrl.appending(image)
            cell.callForUse(imageStr, name, charName)
            
        } else if let name = data.name, let charName = data.character{
            cell.emptyImage(name, charName)
        }
        
        return cell
    }
}

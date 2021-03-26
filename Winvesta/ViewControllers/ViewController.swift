//
//  ViewController.swift
//  Winvesta
//
//  Created by Sagar kumar on 22/03/21.
//

import UIKit
import TMDBSwift
import CoreData
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    let context = appdelegateAll.persistentContainer.viewContext
    
    var apiCalled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieCollectionView.register(UINib(nibName: "MoviesCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
//        movieCollectionView.collectionViewLayout = self
        
        if checkIfConnectedToNetwork(self.view){
            deleteData()
            getData(pages.count + 1)
        } else{
            callForReload(movieCollectionView)
        }
    }
    
    //API CALL
    var pages = [Int]()
    
    func getData(_ page: Int){
        callForReload(movieCollectionView)
        if !pages.contains(page){
            pages.append(page)
            apiCalled = true
            MovieMDB.query(queryType: MovieQueryType.popular, page: page) { (dataReturn, dataMov) in
                if dataReturn.error != nil{
                    print(dataReturn.error.debugDescription)
                } else{
                    if let data = dataMov{
                       
                        self.addData(data)
                        self.apiCalled = false
                        self.callForReload(self.movieCollectionView)
                        self.loadForPage(self.pages.count + 1)
                    }
                }
            }
        }
    }
    
    func loadForPage(_ page: Int) {
        if !pages.contains(page){
            pages.append(page)
            apiCalled = true
            MovieMDB.query(queryType: MovieQueryType.popular, page: page) { (dataReturn, dataMov) in
            
                if dataReturn.error != nil{
                print(dataReturn.error.debugDescription)
                } else{
                    if let data = dataMov{
                        self.addData(data)
                        self.apiCalled = false
                    
                    }

                }
            }
        }

    }
    
    func callForReload(_ viewCollection: UICollectionView) {
        viewCollection.isUserInteractionEnabled = false
        viewCollection.reloadData()
        viewCollection.isUserInteractionEnabled = true
    }
    
    func addData(_ dataArray: [MovieMDB]){
        for data in dataArray{
            let model = MoviesModel(context: context)
            if let imagePath =  data.poster_path, let id = data.id, let title = data.original_title, let vote = data.vote_average, let overView = data.overview, let genre = data.genre_ids{
                model.image = imagePath
                model.movieId = String(id)
                model.name = title
                model.votes = vote
                model.overView = overView
                model.genres = genre as NSObject
            }
        }
        appdelegateAll.saveContext()
        
        
    }
    
    func deleteData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesModel")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            print(error)
        }
    }
    
    
    func fetchData() -> [MoviesModel] {
        
        let request = NSFetchRequest<MoviesModel>(entityName: "MoviesModel")
            do{
                let data = try context.fetch(request)
                return data
            } catch{
                print(error)
                return []
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailedPage"{
            if let data = sender as? MoviesModel, let id = data.movieId, let image = data.image, let discription = data.overView, let name = data.name, let votes = data.votes as? Double, let genre = data.genres{
                if let vc = segue.destination as? DetailViewController{
                    
                    vc.id = Int(id)
                    vc.discription = discription
                    vc.name = name
                    vc.image = image
                    vc.votes = votes
                    vc.genre = genre
                    
                }
            }
            
        }
    }

    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = fetchData()
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MoviesCell

        let data = fetchData()
        let dataView = data[indexPath.row]
        
        if let image = dataView.image, let name = dataView.name{
            let imageStr = imageUrl.appending(image)
            cell.callForUse(imageStr, name)
        }
        cell.loadPercentageLoader(dataView.votes)
        
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if device == .phone{
            let totalCellWidth =  150 * 2
            let totalSpacingWidth = 40

            let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset

            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets.zero
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataView = fetchData()[indexPath.row]
        self.performSegue(withIdentifier: "movieDetailedPage", sender: dataView)
        
        
    }
    
    
}

extension ViewController: UIScrollViewDelegate{

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
            let scrollHeight = scrollView.frame.size.height
        
        if device == .phone{
            if offsetY > (contentHeight - ( scrollHeight  + 200)) {
                if !apiCalled && checkIfConnectedToNetwork(self.view){
                    self.getData(pages.count + 1)
                }
            }
        } else{
            if offsetY > (contentHeight - ( scrollHeight * 1.5 )) {
                if !apiCalled && checkIfConnectedToNetwork(self.view){
                    self.getData(pages.count + 1)
                }
            }
        }
        
    }
    

}


//protocol ReusableView: class {
//    static var defaultReuseIdentifier: String { get }
//}
//
//extension ReusableView where Self: UIView {
//    static var defaultReuseIdentifier: String {
//        return NSStringFromClass(self)
//    }
//}
//
//extension UICollectionViewCell: ReusableView {
//}
//protocol NibLoadableView: class {
//    static var nibName: String { get }
//}
//
//extension NibLoadableView where Self: UIView {
//    static var nibName: String {
//        return NSStringFromClass(self).components(separatedBy: ".").last!
////        return NSStringFromClass(self).componentsSeparatedByString(".").last!
//    }
//}
//extension UICollectionView {
//
//    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
//        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
//    }
//
//    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
//        let bundle = Bundle(for: T.self)
//        let nib = UINib(nibName: T.nibName, bundle: bundle)
//
//        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
//    }
//
//    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> T where T: ReusableView {
//        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
//        }
//
//        return cell
//    }
//}




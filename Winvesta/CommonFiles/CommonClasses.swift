//
//  CommonClasses.swift
//  Winvesta
//
//  Created by Sagar kumar on 22/03/21.
//

import Foundation
import SystemConfiguration
import UIKit
import CoreData
//import PopupDialog

//let context = appdelegateAll.persistentContainer.viewContext

//CHECK INTERNET CONNECTION

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)

}

//Device

let device = UIDevice.current.userInterfaceIdiom

func checkIfConnectedToNetwork(_ viewDisplay: UIView) -> Bool{
    if isConnectedToNetwork(){
        return true
    } else{
        toastDisplay(viewDisplay, ERROR_NOINTERNET, .center)
        return false
    }
}


//CoreData


// delete
func delete(){
//    context.delete()
//    saveContext()
//    fetch()
}

//func fetch(){
//    let request = NSFetchRequest<MoviesModel>(entityName: "MoviesModel")
//    
//    do{
//        try context.fetch(request)
//    } catch{
//        print(error)
//    }
//}

//OTHERS
let imageUrl = "https://www.themoviedb.org/t/p/w1280"
let time_toast = 3.0

let API_KEY = "8cd00354779c2d14b3a6cd2ce3da8738"

//TOAST DISPLAY

func toastDisplay(_ viewDisplay: UIView, _ msg: String, _ position: ToastPosition){
    viewDisplay.makeToast(msg, duration: time_toast, position: position)
    
}

let bullet = "\u{2022}"

//ERRORS

let ERROR_NOINTERNET  = "You appear offline. Please check your internet connection."

//Alert
//func alertCustom(_ msg: String, _ owner: UIViewController) {
//    let alertVC = AlertViewController(nibName: "AlertViewController", bundle: nil)
//    let popup = PopupDialog(viewController: alertVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: true)
//    let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 8
//        paragraphStyle.alignment = .center
//        let attrString = NSMutableAttributedString(string: msg)
//        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//    alertVC.msgLbl.attributedText = attrString
//    let buttonTwo = DefaultButton(title: "OK") {
//        
//    }
//    buttonTwo.backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1)
//    buttonTwo.titleColor = UIColor.white
//    buttonTwo.titleFont = UIFont.init(name: "ProximaNova-Semibold", size: 16)!
//    popup.addButtons([buttonTwo])
//    owner.present(popup, animated: true, completion: nil)
//}


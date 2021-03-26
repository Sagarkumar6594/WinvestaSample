//
//  CommonClasses.swift
//  Winvesta
//
//  Created by Sagar kumar on 22/03/21.
//

import Foundation
import SystemConfiguration
import UIKit

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



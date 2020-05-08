//
//  HomeViewController.swift
//  MediaForensics
//
//  Created by Waad Alkatheeri on 15/04/2020.
//  Copyright © 2020 Waad Alkatheeri. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import CoreLocation
import CryptoKit
import Foundation
import FileBrowser
import SwiftChain

var chain = Blockchain()
class HomeViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
      var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
      var locationManager:CLLocationManager!
      var timeZone: String = ""
      var labelLat: String = ""
      var labelLongi: String = ""
      var time: String = ""

    @IBOutlet weak var scanVideo: UIButton!
    @IBOutlet weak var captureVideo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        // getting time and saving
        
        time = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
                
               
                timeZone = localTimeZoneIdentifier
                
                locationManager = CLLocationManager()
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest
                   locationManager.requestAlwaysAuthorization()

                   if CLLocationManager.locationServicesEnabled(){
                       locationManager.startUpdatingLocation()
                   }
           
        
        
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
      }
      
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       dismiss(animated: true, completion: nil)
       
       guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
         mediaType == (kUTTypeMovie as String),
         let url = info[UIImagePickerControllerMediaURL] as? URL,
         UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
         else { return }
       let data = FileManager.default.contents(atPath: url.path)!
       print("path: ",url.path)
       if #available(iOS 13.0, *) {
         let digest = SHA256.hash(data: data)
         let this = chain.addBlock(with: digest.description)
         print(this)
         print(digest.description)
         print("Hashed the video!!")
       } else {
         print("could not Hash the Video!!")
       }
       
       
       // Handle a movie capture
       //saving video to album/Gallery , need to save url of video to block chain
       UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
     }
    
    @IBAction func record(_ sender: AnyObject) {
          
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
        }

    
    @IBAction func checkValidity(_ sender: Any) {
        let fileBrowser = FileBrowser(initialPath: FileManager.default.temporaryDirectory)
        self.present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
          let data = FileManager.default.contents(atPath: file.filePath.path)!
          print("path: ",file.filePath.path)
          if #available(iOS 13.0, *) {
            let digest = SHA256.hash(data: data)
            print(chain.checkValidity(with: digest.description))
            let title = "Video Authentication"
            let message = String(chain.checkValidity(with: digest.description))
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
          } else {
            print("........error!!!")
          }
          
        }
    }
               }







      
      
    

    



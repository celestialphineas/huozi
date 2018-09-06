//
//  SettingsView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/4.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Foundation
import Hero
import Instabug
import Photos

class SettingsViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true) {}
    }
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var reviewCell: UITableViewCell!
    @IBOutlet weak var feedbackCell: SettingsTableCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == tableView.indexPath(for: reviewCell) {
            openAppStore()
        } else if indexPath == tableView.indexPath(for: feedbackCell) {
            openInstabug()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func openAppStore() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        let requestURL = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleIdentifier!)")
        var request = URLRequest(url: requestURL!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil && data != nil else { self.showNetConnectionAlert(); return }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                guard json["resultCount"] as! Int >= 1 else { self.showNetConnectionAlert(); return }
                let result = (json["results"] as! [[String:Any]])[0]
                let trackID = result["trackId"] as! Int
                let itunesURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(trackID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
                DispatchQueue.main.async {
                    UIApplication.shared.openURL(URL(string: itunesURL)!)
                }
            } catch { }
        }
        task.resume()
    }
    func showNetConnectionAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "出错啦！", message: "无法打开 App Store，请检查网络连接", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openInstabug() {
        BugReporting.invoke()
    }
    
    class ImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        weak var superVC: SettingsTableViewController!
        
        override func viewWillAppear(_ animated: Bool) {
            hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                let fileManager = FileManager.default
                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                let localPath = documentDirectory?.appendingPathComponent("temp.jpg")
                let data = UIImageJPEGRepresentation(image, 0.6)
                try? data?.write(to: localPath!, options: .atomic)
                
                UserInfo.storeAvatar(path: localPath!) { record, error in
                    if error != nil { print(error!) }
                    // Update view
//                    DispatchQueue.main.async { self.superVC.avatarView.image = UserInfo.avatarImage }
                }
                dismiss(animated: true) {}
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true) {}
        }
    }
    let imagePicker = ImagePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = imagePicker
    }
    @IBOutlet weak var avatarView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        avatarView.image = UserInfo.avatarImage
        UserInfo.listeningImageView = avatarView
    }
    @IBAction func pickImage() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.superVC = self
        present(imagePicker, animated: true) {}
    }
}

class SettingsTableCell: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}


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

class SettingsViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    func initialize() {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true) {}
    }
    
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var reviewCell: UITableViewCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == tableView.indexPath(for: reviewCell) {
            openAppStore()
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
        let alert = UIAlertController(title: "出错啦！", message: "无法打开 App Store，请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
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


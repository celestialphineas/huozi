//
//  HomeTableViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Hero

class HomeTableCell: UITableViewCell {
    @IBOutlet weak var storyCard: StoryCard!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.masksToBounds = false
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}

class HomeTableViewController: UITableViewController {
    let headerHeight: CGFloat = 64
    let footerHeight: CGFloat = 40
    let characterSegueIdentifier = "homeToStory"

    let dataHandler = StoryDataOf("book-1")
    
    // Segue configuring
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == characterSegueIdentifier,
            let destination = segue.destination as? StoryHomeViewController,
            let itemIndex   = tableView.indexPathForSelectedRow?.row {
            destination.storyData = dataHandler.data?[itemIndex]
            destination.heroIndex = itemIndex
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: characterSegueIdentifier, sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        // TODO:
        // This is to be removed
        for cell in tableView.visibleCells as! [HomeTableCell] {
            // This line should be reserved
            cell.storyCard.isOpaque = false
            cell.storyCard.checked = TemporaryUserStateModel.shownMedal
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell
        if let title = dataHandler.data?[indexPath.item].title {
            if let titleLabel = cell.storyCard?.titleLabel {
                titleLabel.text = title
                titleLabel.hero.id = "title-\(indexPath.item)"
            }
        }
        
        if let cardImageName = dataHandler.data?[indexPath.item].cardImageName {
            if let img = UIImage(named: cardImageName) {
                if let backgroundImageView = cell.storyCard?.backgroundImageView {
                    backgroundImageView.image = img
                    backgroundImageView.hero.id = "img-\(indexPath.item)"
                }
            }
        }
        
        // TODO:
        // This is to be removed
        cell.storyCard.checked = TemporaryUserStateModel.shownMedal
        if indexPath.item > 0 {
            cell.storyCard.locked = true
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHandler.count
    }
    
    // Header and footer
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 64))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
}


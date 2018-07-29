//
//  scrollingLyricsView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/29.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class ScrollingLyricsView: UIView {
    @IBOutlet var scrollingLyricsView: UIView!
    @IBOutlet weak var tableView: LyricsTableView!
    @IBInspectable var textColor: UIColor = UIColor(white: 1.0, alpha: 0.8)
    @IBInspectable var highlightColor: UIColor = UIColor(red: 1.0, green: 0.25, blue: 0.5, alpha: 1.0)
    @IBInspectable var selectedColor: UIColor = UIColor(white: 1.0, alpha: 1.0)
    @IBInspectable var lineHeight: CGFloat = 40.0
    
    private var lyricsVal: [String]! = nil
    var lyrics: [String]! {
        set {
            lyricsVal = newValue
            tableView.lyrics = lyrics
        }
        get { return lyricsVal }
    }
    
    private func initialize() {
        // Connecting nib
        Bundle.main.loadNibNamed("ScrollingLyricsView", owner: self, options: nil)
        addSubview(scrollingLyricsView)
        scrollingLyricsView.frame = self.bounds
        scrollingLyricsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Initializing lyrics
        tableView.textColor = textColor
        tableView.highlightColor = highlightColor
        tableView.selectedColor = selectedColor
        tableView.lineHeight = lineHeight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func autoScroll(line: Int) {
        if tableView != nil { tableView.autoScroll(line: line) }
    }
    
    var x = -2
    @IBAction func testScroll() {
        x += 1
        autoScroll(line: x)
    }
}

@IBDesignable
class LyricsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var lyrics: [String]! = nil
    var textColor, highlightColor, selectedColor: UIColor!
    var lineHeight: CGFloat = 40.0
    let nilContent = "没有内容"
    
    private func initialize() {
        self.delegate = self
        self.dataSource = self
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lyrics == nil || lyrics.count == 0 { return 1 }
        return lyrics.count
    }
    
    // Table cells
    class Cell: UITableViewCell {
        var label: UILabel!
        func initialize() {
            label = UILabel(frame: frame)
            label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            label.numberOfLines = 3
            label.textAlignment = .center
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            initialize()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initialize()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell(frame: frame)
        let label = cell.label!
        if textColor != nil { label.textColor = textColor }
        if lyrics == nil || lyrics.count == 0 {
            label.text = nilContent
        } else {
            label.text = lyrics[indexPath.item]
        }
        cell.addSubview(label)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return lineHeight
    }
    
    // This makes the first line of the view almost at the center
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return bounds.height/2
    }
    // and the last line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: frame)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return bounds.height/2
    }
    
    // Scrolling automatically
    // Bounds of lineno: [-1, count]
    private var previousLine = 0
    func autoScroll(line: Int) {
        var lineno = -1
        if line > lyrics.count { lineno = lyrics.count }
        else if line > -1 { lineno = line }
        let calculatedHeight = lineHeight * CGFloat(lineno + 1)
        setContentOffset(CGPoint(x: 0, y: calculatedHeight), animated: true)
        if let previousLine = self.cellForRow(at: [0, self.previousLine]) as? Cell {
            previousLine.label.textColor = self.textColor
        }
        if lineno > -1 && lineno < self.lyrics.count {
            if let currentLine = self.cellForRow(at: [0, lineno]) as? Cell {
                currentLine.label.textColor = self.highlightColor
            }
        }
        previousLine = lineno
    }
}

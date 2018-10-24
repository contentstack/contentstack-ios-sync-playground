//
//  ViewController.swift
//  ContentstackSyncPlayground
//
//  Created by Uttam Ukkoji on 26/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

import UIKit
import Contentstack


class ViewController: UIViewController {

    var syncToken : String?
    var pageToken : String?
    var currentLoad : Int = 0
    
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deltaSyncButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.deltaSyncButton.isEnabled = false
//        if let syncT = UserDefaults.standard.value(forKey: "SYNC_TOKEN") as? String {
//            self.syncToken = syncT
//            self.tokenLabel.text = "Sync Token: \(syncT)"
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call this function when initial sync inturepted while paginating and you have Pagination Token
    func paginateSync() {
        if let pageT = UserDefaults.standard.value(forKey: "PAGE_TOKEN") as? String {
            self.pageToken = pageT
            self.tokenLabel.text = "Page Token: \(pageT)"
            APIManger.stack.syncPaginationToken(pageT, completion: {[weak self] (stack, error) in
                guard let slf = self, let syncStack = stack else {return}
                slf.parse(syncStack)
            })
        }
    }

    @IBAction func sync(_ sender: Any) {
        self.syncButton.isEnabled = false
        self.deltaSyncButton.isEnabled = false
        self.currentLoad = 0
        self.messageLabel.text = "Sync in progress..."
        APIManger.stack.sync {[weak self] (stack, error) in
            guard let slf = self, let syncStack = stack else {return}
            slf.parse(syncStack)
        }
    }
    
    @IBAction func deltaSync(_ sender: Any) {
        if let syncToken = self.syncToken {
            self.syncButton.isEnabled = false
            self.deltaSyncButton.isEnabled = false
            self.messageLabel.text = "Sync in progress..."
            APIManger.stack.syncToken(syncToken, completion: {[weak self] (stack, error) in
                guard let slf = self, let syncStack = stack else {return}
                slf.parse(syncStack)
            })
        }
    }
    
    func parse(_ syncStack: SyncStack) {
        self.syncButton.isEnabled = true
        if let token = syncStack.syncToken {
            self.deltaSyncButton.isEnabled = true
            self.messageLabel.text = "Contentstack Sync Done"
            self.syncToken = token //Store sync token for subsequent Sync
            UserDefaults.standard.setValue(token, forKey: "SYNC_TOKEN")
            UserDefaults.standard.synchronize()
            self.tokenLabel.text = "Next Sync Token: \(token)"
            if let itemArray = syncStack.items {
                self.currentLoad = Int(itemArray.count) + (self.currentLoad)
            }
        }else if let token = syncStack.paginationToken {
            self.messageLabel.text = "Contentstack Paginating Sync"
            self.pageToken = token //Store pagination token 
            UserDefaults.standard.setValue(token, forKey: "PAGE_TOKEN")
            UserDefaults.standard.synchronize()
            self.tokenLabel.text = "Pagination Token: \(token)"
            if let itemArray = syncStack.items {
                self.currentLoad = Int(itemArray.count) + (self.currentLoad)
            }
        }
        self.totalCountLabel.text = "Content Total Count: \(syncStack.totalCount)"
    }
    
}


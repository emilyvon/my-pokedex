//
//  MovesContainerViewController.swift
//  my-pokedex
//
//  Created by Mengying Feng on 15/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import UIKit

class MovesContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var passedData: Pokemon!
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passedData.downloadPokemonDetails { () -> () in
            print(self.passedData.moveLearnTypes)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MoveCell") as? MoveCell {
            let type = passedData.moveLearnTypes[indexPath.row]
            let name = passedData.moveNames[indexPath.row]
            cell.configureCell(type, typeStr: name)
            return cell
        } else {
            return MoveCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedData.moveLearnTypes.count / 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}

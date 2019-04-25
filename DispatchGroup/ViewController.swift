//
//  ViewController.swift
//  DispatchGroup
//
//  Created by Alex on 4/24/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

// Class simulates a network request
class ViewController: UIViewController {

    let groupA = ["user 1", "user 2"]
    let groupB = ["user 3", "user 4"]
    let groupC = ["user 5", "user 6"]

    var users = [String]() // what is this format?
    
    let dispatchGroup = DispatchGroup()
    
    // Delay function
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func downloadBtnPressed(_ sender: UIBarButtonItem) {
        print("downloading...")
        getGroupA()
        getGroupB()
        getGroupC()
        dispatchGroup.notify(queue: .main) { // .main is for main thread: threading
            self.displayUsers()
            print("finished all")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getGroupA(){
        dispatchGroup.enter()
        run(after: 2){
            print("got A")
            self.users.append(contentsOf: self.groupA)
            self.tableView.reloadData()
            self.dispatchGroup.leave()
        }
    }
    
    func getGroupB(){
        dispatchGroup.enter()
        run(after: 4) {
            print("got B")
            self.users.append(contentsOf: self.groupB)
            self.tableView.reloadData()
            self.dispatchGroup.leave()
        }
    }
    
    func getGroupC(){
        dispatchGroup.enter()
        run(after: 6) {
            print("got C")
            self.users.append(contentsOf: self.groupC)
            self.tableView.reloadData()
            self.dispatchGroup.leave()
        }
    }

    func displayUsers(){
        print("reloading data")
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = users[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

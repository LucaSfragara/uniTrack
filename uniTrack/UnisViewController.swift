//
//  UnisViewController.swift
//  uniTrack
//
//  Created by Luca Sfragara on 19/10/2020.
//

import UIKit

class UnisViewController: UIViewController {

    @IBOutlet private weak var tableview: UITableView!
    
    private var unisList: [University]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unisList?.append(contentsOf: [University(name: "Harvard", course: "Computer Science"), University(name: "Politecnico", course: "eng")])
        tableview.dataSource = self
        tableview.delegate = self
    }
}

//MARK: tableview datasource and delegate
extension UnisViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unisList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "UnisListTableViewCell", for: indexPath) as! UnisListTableViewCell
        cell.update(universityName: unisList?[indexPath.row].name, universityCourse: unisList?[indexPath.row].course)
        return cell
    }
    
}

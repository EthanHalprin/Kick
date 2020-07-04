//
//  TeamsViewController.swift
//  Kick
//
//  Created by Ethan on 12/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation
import UIKit

class TeamsViewController: UITableViewController {
    
    private var viewModel: TeamsViewModel!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Teams"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension TeamsViewController {
    
    func setup() {
        viewModel = TeamsViewModel(self)
        self.showActivityIndicator(activityIndicator)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        viewModel.fetchTeams()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TeamReuseIdentifier")

        let team = viewModel.teams[indexPath.item]
        cell.textLabel?.text = team.name
        cell.detailTextLabel?.text = team.email
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let teamProfileViewController = UIStoryboard.init(name: "Main",
                                                             bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamProfileViewController") as? TeamProfileViewController {
            let team = viewModel.teams[indexPath.item]
            teamProfileViewController.viewModel = TeamProfileViewModel(team)
            self.navigationController?.pushViewController(teamProfileViewController, animated: true)
        }
    }
}

extension TeamsViewController: Reoloadable {
    func reload() {
        self.tableView.reloadData()
        self.hideActivityIndicator(activityIndicator)
    }
    func networkErrorDispatched(_ description: String) {
        self.hideActivityIndicator(activityIndicator)
        self.issueNetworkErrorMessage(description)
    }
}

extension UIViewController {
    func showActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()

        let titleLabel = UILabel()
        titleLabel.text = "Loading..."
        titleLabel.font = UIFont.italicSystemFont(ofSize: 14)

        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRect(x: activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8,
                                  y: activityIndicatorView.frame.origin.y,
                                  width: fittingSize.width,
                                  height: fittingSize.height)

        let rect = CGRect(x: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2,
                          y: (activityIndicatorView.frame.size.height) / 2,
                          width: activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width,
                          height: activityIndicatorView.frame.size.height)
        let titleView = UIView(frame: rect)
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)

        self.navigationItem.titleView = titleView
        
    }

    func hideActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
        activityIndicatorView.stopAnimating()
        self.navigationItem.titleView = nil
    }
 
    func issueNetworkErrorMessage(_ description: String) {
        if description.contains("-1011") {
            //
            // NSURLError -1011 is a server error ("badServerResponse")
            // Probably because of overuse within time limits of a free account
            //
            print("Bad ServerNetwork ERROR : \(description)")
        }
    }

}

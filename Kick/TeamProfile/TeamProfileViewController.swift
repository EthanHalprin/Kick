//
//  TeamProfileViewController.swift
//  Kick
//
//  Created by Ethan on 13/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation
import UIKit
import Combine
import WebKit

class TeamProfileViewController: UIViewController {
    
    @IBOutlet var logoWebView: WKWebView!
    @IBOutlet var fullname: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var website: UILabel!
    @IBOutlet var colors: UILabel!
    @IBOutlet var founded: UILabel!
    @IBOutlet var playersTableView: UITableView!
    @IBOutlet var matchesTableView: UITableView!
    
    var viewModel: TeamProfileViewModel!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = self.viewModel else {
            assertionFailure("No team input to display on TeamProfileViewController")
            return
        }
        self.playersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlayerCellReuseIdentifier")
        self.playersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchCellReuseIdentifier")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        self.showActivityIndicator(activityIndicator)
    }
}

extension TeamProfileViewController {
    
    private func setup() {
        playersTableView.dataSource = self
        matchesTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = false
        addObserverSelectors()
        self.viewModel.fetch()
    }
    
    private func addObserverSelectors() {
        self.viewModel.notificationCenter.addObserver(self,
                                                      selector: #selector(playersTableReloadExecute),
                                                      name: .playersTableReload,
                                                      object: nil)

        self.viewModel.notificationCenter.addObserver(self,
                                                      selector: #selector(fixturesTableReloadExecute),
                                                      name: .fixturesTableReload,
                                                      object: nil)
        
        self.viewModel.notificationCenter.addObserver(self,
                                                      selector: #selector(webViewLogoSVGLoadExecute),
                                                      name: .crestURLReady,
                                                      object: nil)

        self.viewModel.notificationCenter.addObserver(self,
                                                      selector: #selector(teamInfoReadyExecute),
                                                      name: .teamInfoReady,
                                                      object: nil)

        self.viewModel.notificationCenter.addObserver(self,
                                                      selector: #selector(networkErrorDidOccur),
                                                      name: .networkError,
                                                      object: nil)
    }
    
    @objc private func playersTableReloadExecute(_ notification: Notification) {
        self.playersTableView.reloadData()
    }
    
    @objc private func fixturesTableReloadExecute(_ notification: Notification) {
        self.matchesTableView.reloadData()
        self.hideActivityIndicator(activityIndicator)
    }
    
    @objc private func webViewLogoSVGLoadExecute(_ notification: Notification) {
        guard let url = notification.object as? String else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }
        self.logoWebView.load(url)
    }
    
    @objc private func teamInfoReadyExecute(_ notification: Notification) {
        guard let info = notification.object as? Team else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }
        fullname.text = info.name
        area.text     = info.area?.name
        phone.text    = info.phone
        website.text  = info.website
        colors.text   = info.clubColors
        if let year =  info.founded {
            founded.text  = "\(String(describing: year))"
        }
        self.fullname.textColor = self.viewModel.primaryColor
    }

    @objc private func networkErrorDidOccur(_ notification: Notification) {
        guard let description = notification.object as? String else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }
        self.hideActivityIndicator(activityIndicator)
        issueNetworkErrorMessage(description)
    }
}

extension TeamProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == playersTableView ? self.viewModel.players.count : self.viewModel.matches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.playersTableView {
            return self.cellForPlayer(indexPath)
        } else {
            return self.cellForFixture(indexPath)
        }
    }
    
    private func cellForPlayer(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PlayerCellReuseIdentifier")
        let player = self.viewModel.players[indexPath.item]
        
        cell.textLabel?.textColor = self.viewModel.primaryColor
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = player.position
        
        return cell
    }
    
    private func cellForFixture(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MatchCellReuseIdentifier")
        let match = self.viewModel.matches[indexPath.item]
        
        cell.textLabel?.text = match.homeTeam.name.uppercased() + " - " + match.awayTeam.name.uppercased()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textColor = self.viewModel.primaryColor
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = match.competition.name + " " + match.utcDate.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:SSZ",
                                                                                             outGoingFormat: "MMM d, yyyy h:mm a")
        return cell
    }
 
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

extension String {
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = incomingFormat
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

      let dt = dateFormatter.date(from: self)
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = outGoingFormat

      return dateFormatter.string(from: dt ?? Date())
    }
}

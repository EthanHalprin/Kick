//
//  TeamProfileViewModel.swift
//  Kick
//
//  Created by Ethan on 13/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation
import UIKit
import Combine
import WebKit

extension Notification.Name {
    static var playersTableReload: Notification.Name {
        return .init(rawValue: "PlayersTableReloadData")
    }

    static var fixturesTableReload: Notification.Name {
        return .init(rawValue: "FixturesTableReloadData")
    }
    
    static var crestURLReady: Notification.Name {
        return .init(rawValue: "crestURLReady")
    }
    
    static var teamInfoReady: Notification.Name {
         return .init(rawValue: "teamInfoReady")
    }
    
    static var networkError: Notification.Name {
         return .init(rawValue: "networkError")
    }
}

class TeamProfileViewModel {
    
    var players = [Squad]() {
        didSet {
            self.notificationCenter.post(name: .playersTableReload, object: nil)
        }
    }
    var matches = [Match]() {
        didSet {
            self.notificationCenter.post(name: .fixturesTableReload, object: nil)
        }
    }
    let notificationCenter = NotificationCenter()
    var primaryColor = UIColor.black
    private var teamInfo: Team?
    private var teamInfoSubscriber: AnyCancellable?
    private var teamMatchSubscriber: AnyCancellable?
    
    required init(_ team: Team) {
        self.teamInfo = team
    }
    
    func fetch() {
        
        guard let info = self.teamInfo, let teamID = info.id else {
            return
        }
       
        self.setPrimaryColor()
        
       if let url = teamInfo?.crestURL {
           self.notificationCenter.post(name: .crestURLReady, object: url)
       }
       self.notificationCenter.post(name: .teamInfoReady, object: teamInfo)
        
        DispatchQueue.global().async {
            self.fetchPlayers(teamID)
        }
        DispatchQueue.global().async {
            self.fetchFixtures(teamID)
        }
    }
}

extension TeamProfileViewModel {

    private func setPrimaryColor() {
        
        if let info = self.teamInfo,
            let colors = info.clubColors,
            let primary = colors.components(separatedBy: " ").first {
            
            switch primary {
            case "Red":
                self.primaryColor = UIColor.red
            case "Green":
                self.primaryColor = UIColor.green
            case "Blue":
                self.primaryColor = UIColor.blue
            case "Royal":
                self.primaryColor = UIColor.blue
            case "Orange":
                self.primaryColor = UIColor.orange
            case "Navy":
                self.primaryColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 1.0)
            case "Sky":
                self.primaryColor = UIColor.init(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            case "Yellow":
                self.primaryColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            case "Claret":
                self.primaryColor = UIColor.init(red: 114.0/255.0, green: 47/255.0, blue: 55.0/255.0, alpha: 1.0)
            case "White":
                self.primaryColor = UIColor.lightGray
            default:
                self.primaryColor = UIColor.black
            }
        }
    }
        
    private func fetchPlayers(_ teamID: Int) {
        
        let networkProvider = NetworkProvider<TeamInfoModel>("http://api.football-data.org/v2/teams/\(teamID)")
 
        teamInfoSubscriber = networkProvider.publisher.mapError { error -> RequestError in
                self.notificationCenter.post(name: .networkError, object: error.localizedDescription)
                return RequestError.sessionError(error: error)
            }.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("receiveCompletion teamInfoSubscriber finished")
                    break
                case .failure(let error):
                    print("teamInfoSubscriber error: \(error.localizedDescription)")
                }
        }, receiveValue: { teamInfo in
            if let squad = teamInfo.squad {
                self.players = squad
            }
        })
    }

     private func fetchFixtures(_ teamID: Int) {

       let networkProvider = NetworkProvider<MatchModel>("http://api.football-data.org/v2/teams/\(teamID)/matches?status=SCHEDULED&limit=10")

       teamMatchSubscriber = networkProvider.publisher.mapError { error -> RequestError in
                self.notificationCenter.post(name: .networkError, object: error.localizedDescription)
                return RequestError.sessionError(error: error)
            }
            .sink(receiveCompletion: { completion in
               switch completion {
               case .finished:
                   print("receiveCompletion teamMatchSubscriber finished")
                   break
               case .failure(let error):
                   print("teamMatchSubscriber error: \(error.localizedDescription)")
               }
           }, receiveValue: { matchResponse in
               self.matches = matchResponse.matches
       })
    }
}

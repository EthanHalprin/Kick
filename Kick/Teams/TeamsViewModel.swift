//
//  TeamsViewModel.swift
//  Kick
//
//  Created by Ethan on 12/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import  Foundation
import UIKit
import Combine

protocol Reoloadable: UIViewController {
    func reload()
    func networkErrorDispatched(_ description: String)
}

class TeamsViewModel {
    
    var delegate: Reoloadable?
    var teams = [Team]() {
        didSet {
            self.delegate?.reload()
        }
    }
    private var teamsSubscriber: AnyCancellable?
    
    required init(_ delegate: Reoloadable) {
        self.delegate = delegate
    }
}

extension TeamsViewModel {

    func fetchTeams() {
        
        let networkProvider = NetworkProvider<TeamsModel>("http://api.football-data.org/v2/teams")
        
        teamsSubscriber = networkProvider.publisher.mapError { error -> RequestError in
            self.delegate?.networkErrorDispatched(error.localizedDescription)
            return RequestError.sessionError(error: error)
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("receiveCompletion finished")
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, receiveValue: { teamsResponse in
            print("receiveValue loaded to data source")
            dump(teamsResponse)
            self.teams = teamsResponse.teams!
        })
    }
}

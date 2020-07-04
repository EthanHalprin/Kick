//
//  TeamInfoModel.swift
//  Kick
//
//  Created by Ethan on 12/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation

// MARK: - TeamInfoModel
class TeamInfoModel: Codable {
    let id: Int?
    let area: AreaInfo?
    let activeCompetitions: [ActiveCompetition]?
    let name, shortName, tla: String?
    let crestURL: String?
    let address, phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let clubColors, venue: String?
    let squad: [Squad]?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, area, activeCompetitions, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue, squad, lastUpdated
    }

    init(id: Int?, area: AreaInfo?, activeCompetitions: [ActiveCompetition]?, name: String?, shortName: String?, tla: String?, crestURL: String?, address: String?, phone: String?, website: String?, email: String?, founded: Int?, clubColors: String?, venue: String?, squad: [Squad]?, lastUpdated: String?) {
        self.id = id
        self.area = area
        self.activeCompetitions = activeCompetitions
        self.name = name
        self.shortName = shortName
        self.tla = tla
        self.crestURL = crestURL
        self.address = address
        self.phone = phone
        self.website = website
        self.email = email
        self.founded = founded
        self.clubColors = clubColors
        self.venue = venue
        self.squad = squad
        self.lastUpdated = lastUpdated
    }
}

// MARK: - ActiveCompetition
class ActiveCompetition: Codable {
    let id: Int?
    let area: AreaInfo?
    let name, code, plan: String?
    let lastUpdated: String?

    init(id: Int?, area: AreaInfo?, name: String?, code: String?, plan: String?, lastUpdated: String?) {
        self.id = id
        self.area = area
        self.name = name
        self.code = code
        self.plan = plan
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Area
class AreaInfo: Codable {
    let id: Int?
    let name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - Squad
class Squad: Codable {
    let id: Int?
    let name, position: String?
    let dateOfBirth: String?
    let countryOfBirth, nationality: String?
    let shirtNumber: Int?//JSONNull?
    let role: String?

    init(id: Int?, name: String?, position: String?, dateOfBirth: String?, countryOfBirth: String?, nationality: String?,
         shirtNumber: Int?/*JSONNull?*/, role: String?) {
        self.id = id
        self.name = name
        self.position = position
        self.dateOfBirth = dateOfBirth
        self.countryOfBirth = countryOfBirth
        self.nationality = nationality
        self.shirtNumber = shirtNumber
        self.role = role
    }
}

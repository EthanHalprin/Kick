//
//  TeamsModel.swift
//  Kick
//
//  Created by Ethan on 13/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation

// MARK: - TeamsModel
class TeamsModel: Codable {
    let count: Int?
    let filters: Filters?
    let teams: [Team]?

    init(count: Int?, filters: Filters?, teams: [Team]?) {
        self.count = count
        self.filters = filters
        self.teams = teams
    }
}

// MARK: - Filters
class Filters: Codable {
    let areas: [Int]?
    let permission: String?

    init(areas: [Int]?, permission: String?) {
        self.areas = areas
        self.permission = permission
    }
}

// MARK: - Team
class Team: Codable {
    let id: Int?
    let area: Area?
    let name, shortName, tla: String?
    let crestURL: String?
    let address, phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let clubColors, venue: String?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, area, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue, lastUpdated
    }

    init(id: Int?, area: Area?, name: String?, shortName: String?, tla: String?, crestURL: String?, address: String?, phone: String?, website: String?, email: String?, founded: Int?, clubColors: String?, venue: String?, lastUpdated: String?) {
        self.id = id
        self.area = area
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
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Area
class Area: Codable {
    let id: Int?
    let name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}


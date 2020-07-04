//
//  MatchModel.swift
//  Kick
//
//  Created by Ethan on 12/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation

// MARK: - MatchModel
class MatchModel: Codable {
    let count: Int
    let filters: FiltersInMatch
    let matches: [Match]

    init(count: Int, filters: FiltersInMatch, matches: [Match]) {
        self.count = count
        self.filters = filters
        self.matches = matches
    }
}

// MARK: - Filters
class FiltersInMatch: Codable {
    let permission: String
    let status: [String]
    let limit: Int

    init(permission: String, status: [String], limit: Int) {
        self.permission = permission
        self.status = status
        self.limit = limit
    }
}

// MARK: - Match
class Match: Codable {
    let id: Int
    let competition: Competition
    let season: Season
    let utcDate: String
    let status: String
    let matchday: Int
    let stage, group: String
    let lastUpdated: String
    let homeTeam, awayTeam: TeamInMatch

    init(id: Int, competition: Competition, season: Season, utcDate: String, status: String, matchday: Int, stage: String, group: String, lastUpdated: String, homeTeam: TeamInMatch, awayTeam: TeamInMatch) {
        self.id = id
        self.competition = competition
        self.season = season
        self.utcDate = utcDate
        self.status = status
        self.matchday = matchday
        self.stage = stage
        self.group = group
        self.lastUpdated = lastUpdated
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
}

// MARK: - TeamInMatch
class TeamInMatch: Codable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Competition
class Competition: Codable {
    let id: Int
    let name: String
    let area: AreaOfMatch

    init(id: Int, name: String, area: AreaOfMatch) {
        self.id = id
        self.name = name
        self.area = area
    }
}

// MARK: - AreaOfMatch
class AreaOfMatch: Codable {
    let name, code: String
    let ensignURL: String

    enum CodingKeys: String, CodingKey {
        case name, code
        case ensignURL = "ensignUrl"
    }

    init(name: String, code: String, ensignURL: String) {
        self.name = name
        self.code = code
        self.ensignURL = ensignURL
    }
}

// MARK: - Season
class Season: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int

    init(id: Int, startDate: String, endDate: String, currentMatchday: Int) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.currentMatchday = currentMatchday
    }
}

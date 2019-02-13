//
//  Earthquake.swift
//  RxEarthquakeLearning
//
//  Created by 突突兔 on 2019/1/28.
//  Copyright © 2019年 突突兔. All rights reserved.
//

import Foundation
import CoreLocation

struct Earthquake {
    typealias ID = Identifier<Earthquake>
    let id: ID
    let coordinate: CLLocationCoordinate2D
    let depth: Double
    let magnitude: Double
    let name: String
    let location: CLLocation
    let weblink: URL?
    let timestamp: Date
}


extension Earthquake {
    static func earthquakes(from data: Data) -> [Earthquake] {
        let earthquakeSummary = try? JSONDecoder().decode(EarthquakeSummary.self, from: data)
        return earthquakeSummary?.features.map(Earthquake.init(_:)) ?? []
    }
    
    private init(_ feature: Feature) {
        id = ID(rawValue: feature.id)
        coordinate = CLLocationCoordinate2D(latitude: feature.geometry.coordinates[1], longitude: feature.geometry.coordinates[0])
        depth = feature.geometry.coordinates[2] * 1000
        magnitude = feature.properties.mag
        name = feature.properties.place
        timestamp = Date(timeIntervalSince1970: feature.properties.time)
        weblink = feature.properties.url
        location = CLLocation(coordinate: coordinate, altitude: -depth, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: kCLLocationAccuracyBest, timestamp: timestamp)
    }
}

struct Identifier<T>: RawRepresentable {
    let rawValue: String
}

private struct EarthquakeSummary: Decodable {
    let features: [Feature]
}

private struct Feature: Decodable {
    let geometry: Geometry
    let properties: Properties
    let id: String
}

private struct Geometry: Decodable {
    let coordinates: [Double]
}

private struct Properties: Decodable {
    let mag: Double
    let place: String
    let time: Double
    let url: URL?
}

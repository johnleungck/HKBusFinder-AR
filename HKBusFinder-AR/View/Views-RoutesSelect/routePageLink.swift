//
//  routePageNavigation.swift
//  HKBusFinder-AR
//
//  Created by John Leung on 22/2/2023.
//

import SwiftUI
import MapKit

struct routePageLink: View {
    @ObservedObject var matchRouteInfo: MatchRouteInfo
    
    var item: routeAvailable
    
    @State var travelTime = 0
    @State var srcWalkTime = 0
    @State var desWalkTime = 0
    
    var body: some View {
        NavigationLink(destination: RouteInfo(matchRouteInfo: matchRouteInfo, chosenRoute: item)) {
            HStack {
                Text(item.srcRS.routeStop.route)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(item.srcRS.Stop.name_en)
                    Text(item.desRS.Stop.name_en)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("🚌 \(travelTime) min")
                    Text("🚶 \(srcWalkTime+desWalkTime) min")
                }
            }
        }
        .onAppear {
            // Bus Estimated Travel Time
            matchRouteInfo.MKTransitETA(p1: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(item.srcRS.Stop.lat)!, longitude: Double(item.srcRS.Stop.long)!)), p2: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(item.desRS.Stop.lat)!, longitude: Double(item.desRS.Stop.long)!))) { busETA in
                travelTime = busETA
            }
            // Walk to Source Stop Time
            matchRouteInfo.MKWalkingETA(p1: MKPlacemark(coordinate: matchRouteInfo.srcCoord), p2: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(item.srcRS.Stop.lat)!, longitude: Double(item.srcRS.Stop.long)!))) { srcETA in
                srcWalkTime = srcETA
            }
            // Walk to Destination Stop Time
            matchRouteInfo.MKWalkingETA(p1: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(item.desRS.Stop.lat)!, longitude: Double(item.desRS.Stop.long)!)), p2: MKPlacemark(coordinate: matchRouteInfo.desCoord)) { desETA in
                srcWalkTime = desETA
            }
        }
    }
}

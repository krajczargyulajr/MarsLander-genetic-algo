//
//  SimulationList.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationList: View {
    var dataModel : [MarsSurface]
    
    @State var selectedSurfaceId : Int
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSurfaceId) {
                ForEach(dataModel) { surface in
                    NavigationLink(value: surface.id) {
                        SimulationCard(surface: surface)
                    }
                }
            }
        } detail: {
            SimulationDetail(
                dataModel: dataModel,
                selectedSurfaceId: selectedSurfaceId
            )
        }
    }
}

struct SimulationList_Previews: PreviewProvider {
    static var previews: some View {
        SimulationList(dataModel: surfaces, selectedSurfaceId: 0)
    }
}

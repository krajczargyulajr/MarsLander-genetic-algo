//
//  SimulationList.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationList: View {
    var dataModel : [Simulation]
    
    @State var selectedSimulationId : Int = 2
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSimulationId) {
                ForEach(dataModel) { sim in
                    NavigationLink(value: sim.id) {
                        SimulationCard(simulation: sim)
                    }
                }
            }
        } detail: {
            SimulationDetail(
                dataModel: dataModel,
                selectedSimulationId: selectedSimulationId
            )
        }
    }
}

struct SimulationList_Previews: PreviewProvider {
    static var previews: some View {
        SimulationList(dataModel: surfaces, selectedSimulationId: 0)
    }
}

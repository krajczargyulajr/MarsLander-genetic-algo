//
//  SimulationDetail.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationDetail: View {
    var dataModel : [Simulation]
    var selectedSimulationId : Int = -1
    
    var body: some View {
        ZStack {
            if selectedSimulationId <= 0 {
                Text("Please select one of the surfaces!")
            } else {
                SimulationDetailContent(simulation: dataModel.first(where: { $0.id == selectedSimulationId})!)
            }
        }
    }
}

struct SimulationDetail_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetail(dataModel: surfaces, selectedSimulationId: 0)
    }
}

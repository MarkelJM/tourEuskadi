//
//  EventRow.swift
//  tourBasqueCountry
//
//  Created by Markel Juaristi on 20/9/24.
//

import SwiftUI

struct EventRow: View {
    let event: EventModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Fecha: \(event.eventStartDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(event.documentName)
                .font(.headline)
        }
    }
}

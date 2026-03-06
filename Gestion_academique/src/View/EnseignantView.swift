//
//  EnseignantView.swift
//  list
//
//  Created by Guillaume on 23/02/2026.
//

import SwiftUI
import SwiftData

struct EnseignantView: View {
    let enseignantVM: EnseignantViewModel
    
    var body: some View {
        NavigationStack {
            List(enseignantVM.listeEnseignant, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text("\(item.prenom) \(item.nom)")
                        .font(.headline)
                    Text("Cours : \(item.coursEnseignes?.map { $0.titre }.joined(separator: ", ") ?? "Aucun")")
                        .font(.caption)
                }
            }
            .navigationTitle("Enseignants")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") { }
                }
            }
        }
    }
}

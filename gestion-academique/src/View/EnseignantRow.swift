//
//  EnseignantRow.swift
//  Gestion_academique
//
//  Created by Guillaume on 11/03/2026.
//

import SwiftUI
import SwiftData

struct EnseignantRow: View {
    let item: EnseignantEntity
    
    let etudiant: EtudiantViewModel
    let cours: CoursViewModel
    let enseignant: EnseignantViewModel
    
    var body: some View {
        NavigationLink(destination: EnseignantDetailView(enseigant: item)) {
            VStack(alignment: .leading) {
                Text("\(item.prenom) \(item.nom)")
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    func EnseignantDetailView(enseigant: EnseignantEntity) -> some View {
        List {
            Section("Cours enseignés") {
                if let coursInscrits = enseigant.coursEnseignes, !coursInscrits.isEmpty {
                    ForEach(coursInscrits) { c in
                        CoursRow(item: c, cours: cours, etudiant: etudiant, enseignants: enseignant)
                    }
                } else {
                    Text("Aucun cours inscrit")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("\(enseigant.prenom) \(enseigant.nom)")
    }
}

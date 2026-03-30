//
//  EtudiantRow.swift
//  list
//
//  Created by Guillaume on 25/02/2026.
//

import SwiftUI
import SwiftData

struct EtudiantRow: View {
    let item: EtudiantEntity
    
    let etudiant: EtudiantViewModel
    let cours: CoursViewModel
    let enseignant: EnseignantViewModel
    
    var body: some View {
        NavigationLink(destination: EtudiantDetailView(etudiant: item)) {
            VStack(alignment: .leading) {
                Text("\(item.prenom) \(item.nom)")
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    func EtudiantDetailView(etudiant: EtudiantEntity) -> some View {
        List {
            Section("Cours inscrits") {
                if let coursInscrits = etudiant.coursInscrits, !coursInscrits.isEmpty {
                    ForEach(coursInscrits) { c in
                        CoursRow(item: c, cours: self.cours, etudiant: self.etudiant, enseignants: self.enseignant)
                    }
                } else {
                    Text("Aucun cours inscrit")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("\(etudiant.prenom) \(etudiant.nom)")
    }
}

//
//  StudentView.swift
//  list
//
//  Created by Guillaume on 23/02/2026.
//
import SwiftUI
import SwiftData

struct EtudiantView: View {
    let etudiant: EtudiantViewModel
    let cours: CoursViewModel

    var body: some View {
        NavigationStack {
            List(etudiant.listeEtudiant) { item in
                EtudiantRow(item: item, etudiant: etudiant, cours: cours)
            }
            .navigationTitle("Étudiants")
        }
    }
    
    
}

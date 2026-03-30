//
//  SearchView.swift
//  gestion-academique
//
//  Created by Guillaume on 30/03/2026.
//


import SwiftUI
import SwiftData

struct SearchView: View {
    
    let cours: CoursViewModel
    let etudiant: EtudiantViewModel
    let enseignant: EnseignantViewModel
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                if !coursFiltres.isEmpty {
                    Section(header: Text("Cours")) {
                        ForEach(coursFiltres) { item in
                            CoursRow(item: item, cours: cours, etudiant: etudiant, enseignants: enseignant)
                        }
                    }
                }
                if !enseignantsFiltres.isEmpty {
                    Section(header: Text("Enseignants")) {
                        ForEach(enseignantsFiltres) { item in
                            EnseignantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignant)
                        }
                    }
                }
                if !etudiantsFiltres.isEmpty {
                    Section(header: Text("Étudiants")) {
                        ForEach(etudiantsFiltres) { item in
                            EtudiantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignant)
                        }
                    }
                }
                if searchText.isEmpty {
                    Text("Commencez à taper pour rechercher...")
                        .foregroundColor(.secondary)
                        .listRowBackground(Color.clear)
                } else if coursFiltres.isEmpty && etudiantsFiltres.isEmpty && enseignantsFiltres.isEmpty {
                    Text("Aucun résultat trouvé pour \"\(searchText)\".")
                        .foregroundColor(.secondary)
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Recherche")
            .searchable(text: $searchText, prompt: "Chercher un cours, un nom...")
        }
    }
    
    var coursFiltres: [CoursEntity] {
        if searchText.isEmpty { return [] }
        return cours.listeDeCours.filter { 
            $0.titre.localizedCaseInsensitiveContains(searchText) || 
            $0.id.localizedCaseInsensitiveContains(searchText) 
        }
    }
    
    var etudiantsFiltres: [EtudiantEntity] {
        if searchText.isEmpty { return [] }
        return etudiant.listeEtudiant.filter { 
            $0.nom.localizedCaseInsensitiveContains(searchText) || 
            $0.prenom.localizedCaseInsensitiveContains(searchText) 
        }
    }
    
    var enseignantsFiltres: [EnseignantEntity] {
        if searchText.isEmpty { return [] }
        return enseignant.listeEnseignant.filter { 
            $0.nom.localizedCaseInsensitiveContains(searchText) || 
            $0.prenom.localizedCaseInsensitiveContains(searchText) 
        }
    }
}

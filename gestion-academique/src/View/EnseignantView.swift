//
//  EnseignantView.swift
//  list
//
//  Created by Guillaume on 23/02/2026.
//

import SwiftUI
import SwiftData

struct EnseignantView: View {
    let etudiant: EtudiantViewModel
    let cours: CoursViewModel
    let enseignant: EnseignantViewModel
    
    @State private var showModal: Bool = false
    
    @State private var id = ""
    @State private var nom = ""
    @State private var prenom = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \CoursEntity.titre) var listeDeCours: [CoursEntity]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(enseignant.listeEnseignant) { item in
                    EnseignantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignant)
                }
                .onDelete(perform: deleteEnseignant)
            }
            .navigationTitle("Enseignant")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal){
                AddEnseignant()
            }
        }
    }
    
    @ViewBuilder
    func AddEnseignant() -> some View{
        NavigationStack {
            Form {
                Section("Détails") {
                    TextField("Nom", text: $nom)
                    TextField("Prenom", text: $prenom)
                }
            }
            .navigationTitle("Nouvel Enseignant")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter") {
                        let nouvelEnseignant = EnseignantEntity(id: id, nom: nom, prenom: prenom)
                        modelContext.insert(nouvelEnseignant)
                        enseignant.fetchFromDB(context: modelContext)
                        self.showModal = false
                        resetFields()
                    }
                    .disabled(nom.isEmpty || prenom.isEmpty)
                }
            }
        }
    }
    
    func resetFields() {
        nom = ""
        prenom = ""
    }
    
    func deleteEnseignant(at offsets: IndexSet) {
        for index in offsets {
            let enseignantToDelete = enseignant.listeEnseignant[index]
            modelContext.delete(enseignantToDelete)
        }
        try? modelContext.save()
        enseignant.fetchFromDB(context: modelContext)
    }
}

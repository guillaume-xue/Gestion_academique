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
    let enseignant: EnseignantViewModel
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var id = ""
    @State private var nom = ""
    @State private var prenom = ""
    
    @State var showModal: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(etudiant.listeEtudiant) { item in
                    EtudiantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignant)
                }
                .onDelete(perform: deleteEtudiant)
            }
            .navigationTitle("Étudiants")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal){
               AddEtudiant()
            }
        }
    }
    
    @ViewBuilder
    func AddEtudiant() -> some View{
        NavigationStack {
            Form {
                Section("Détails") {
                    TextField("Nom", text: $nom)
                    TextField("Prenom", text: $prenom)
                }
            }
            .navigationTitle("Nouvel Etudiant")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter") {
                        let nouveauEtudiant = EtudiantEntity(id: id, nom: nom, prenom: prenom)
                        modelContext.insert(nouveauEtudiant)
                        etudiant.fetchFromDB(context: modelContext)
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
    
    func deleteEtudiant(at offsets: IndexSet) {
        for index in offsets {
            let etudiantToDelete = etudiant.listeEtudiant[index]
            modelContext.delete(etudiantToDelete)
        }
        
        try? modelContext.save()
        etudiant.fetchFromDB(context: modelContext)
    }
    
}

//
//  CoursRow.swift
//  list
//
//  Created by Guillaume on 25/02/2026.
//

import SwiftUI
import SwiftData

struct CoursRow: View {
    @Bindable var item: CoursEntity
    let cours: CoursViewModel
    let etudiant: EtudiantViewModel
    let enseignants: EnseignantViewModel
    
    @State private var selection = 0
    @State var showModal: Bool = false
    @State var showModalPart: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationLink(destination: CoursWindow(id: item.id)) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black.opacity(0.3))
                        .frame(width: 50, height: 50)
                    Image(systemName: "book.fill")
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.titre)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    func CoursWindow(id: String) -> some View {
        VStack(spacing: 0) {
            Picker("", selection: $selection) {
                Text("Contenue").tag(0)
                Text("Participants").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(.ultraThinMaterial)
            
            Divider()
            ZStack {
                if selection == 0 {
                    CoursContent(id: id)
                } else if selection == 1 {
                    ParticipantsView(id: id)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            if selection == 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: "edit") {
                        self.showModalPart = true
                    }
                }
            } else if selection == 1 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        self.showModalPart = true
                    }
                }
            }
        }
        .sheet(isPresented: self.$showModalPart){
            if selection == 0 {
                EditCours(id: id)
            } else if selection == 1 {
                AddEtudiantAndEnseignant(id: id)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
    
    @ViewBuilder
    func CoursContent(id: String) -> some View {
        List {
            Section(header: Text("Cours")) {
                Text(item.titre)
            }
            Section(header: Text("Departement")) {
                Text(item.departement)
            }
            Section(header: Text("Horaire")) {
                Text(item.horaires)
            }
            Section(header: Text("Salle")) {
                Text(item.salle)
            }
            Section(header: Text("Description")) {
                Text(item.desc)
            }
            
        }
    }
    
    @ViewBuilder
    func ParticipantsView(id: String) -> some View{
        let etudiantsFiltres = etudiant.filtrerEtudiantsParCours(idCours: id)
        let enseignantsFiltres = enseignants.filtrerEnseignantParCours(idCours: id)
        List {
            Section(header: Text("Enseignants")) {
                ForEach(enseignantsFiltres) { item in
                    EnseignantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignants)
                }
            }
            Section(header: Text("Étudiants")) {
                ForEach(etudiantsFiltres) { item in
                    EtudiantRow(item: item, etudiant: etudiant, cours: cours, enseignant: enseignants)
                }
                .onDelete(perform: deleteEtudiant)
            }
        }
    }
    
    @ViewBuilder
    func AddEtudiantAndEnseignant(id: String) -> some View {
        NavigationStack {
            List {
                Section(header: Text("Enseignants disponibles")) {
                    ForEach(enseignants.listeEnseignant) { ens in
                        let dejaAjoute = ens.coursEnseignes?.contains(where: { $0.id == item.id }) ?? false
                        
                        HStack {
                            Text("\(ens.nom) \(ens.prenom)")
                            Spacer()
                            
                            Button(dejaAjoute ? "Ajouté" : "Ajouter") {
                                if ens.coursEnseignes == nil {
                                    ens.coursEnseignes = []
                                }
                                ens.coursEnseignes?.append(item)
                                try? modelContext.save()
                                enseignants.fetchFromDB(context: modelContext)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(dejaAjoute ? .gray : .blue)
                            .disabled(dejaAjoute)
                        }
                    }
                }
                
                Section(header: Text("Étudiants disponibles")) {
                    ForEach(etudiant.listeEtudiant) { etu in
                        let dejaAjoute = etu.coursInscrits?.contains(where: { $0.id == item.id }) ?? false
                        
                        HStack {
                            Text("\(etu.nom) \(etu.prenom)")
                            Spacer()
                            
                            Button(dejaAjoute ? "Inscrit" : "Ajouter") {
                                if etu.coursInscrits == nil {
                                    etu.coursInscrits = []
                                }
                                etu.coursInscrits?.append(item)
                                try? modelContext.save()
                                etudiant.fetchFromDB(context: modelContext)
                            }
                            .buttonStyle(.bordered)
                            .tint(dejaAjoute ? .gray : .green)
                            .disabled(dejaAjoute)
                        }
                    }
                }
            }
            .navigationTitle("Ajouter au cours")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Terminé") {
                        showModalPart = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func EditCours(id: String) -> some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations générales")) {
                    TextField("Titre du cours", text: $item.titre)
                    TextField("Département", text: $item.departement)
                }
                
                Section(header: Text("Détails pratiques")) {
                    TextField("Horaires", text: $item.horaires)
                    TextField("Salle", text: $item.salle)
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $item.desc)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Modifier le cours")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Enregistrer") {
                        try? modelContext.save()
                        showModalPart = false
                        dismiss()
                    }
                    .disabled(item.titre.isEmpty)
                }
            }
        }
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

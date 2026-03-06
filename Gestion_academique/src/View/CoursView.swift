//
//  CoursView.swift
//  list
//
//  Created by Guillaume on 20/02/2026.
//
import SwiftUI
import SwiftData

struct CoursView: View {
    let cours: CoursViewModel
    let etudiant: EtudiantViewModel
    
    @State private var selection = 0
    @State var showModal: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \CoursEntity.titre) var listeDeCours: [CoursEntity]

    @State private var id = ""
    @State private var titre = ""
    @State private var departement = ""
    @State private var credits = 0
    @State private var desc = ""
    @State private var horaires = ""
    @State private var salle = ""

    var body: some View {
        NavigationStack {
            List(cours.listeDeCours) { item in
                CoursRow(item: item, cours: self.cours, etudiant: self.etudiant)
            }
            .navigationTitle("Les Cours")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal){
               AddCours()
            }
        }
    }
    
    @ViewBuilder
    func AddCours() -> some View{
        NavigationStack {
                Form {
                    Section("Détails du cours") {
                        TextField("Code (ex: MAT101)", text: $id)
                        TextField("Titre du cours", text: $titre)
                    }
                }
                .navigationTitle("Nouveau Cours")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Ajouter") {
                            let nouveauCours = CoursEntity(
                                id: id,
                                titre: titre,
                                departement: departement,
                                credits: credits,
                                desc: desc,
                                horaires: horaires,
                                salle: salle,
                                isEnabled: false
                            )
                            modelContext.insert(nouveauCours)
                            cours.fetchFromDB(context: modelContext)
                            self.showModal = false
                            resetFields()
                        }
                        .disabled(id.isEmpty || titre.isEmpty)
                    }
                }
            }
    }
    
    func resetFields() {
        id = ""
        titre = ""
    }
}


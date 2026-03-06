//
//  CoursRow.swift
//  list
//
//  Created by Guillaume on 25/02/2026.
//

import SwiftUI
import SwiftData

struct CoursRow: View {
    let item: CoursEntity
    
    let cours: CoursViewModel
    let etudiant: EtudiantViewModel
    
    @State private var selection = 0
    @State var showModal: Bool = false
    
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
                        .foregroundColor(.primary) // Utilise primary pour s'adapter au mode sombre
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
                    
                } else if selection == 1 {
                    ParticipantsView(id: id)
                } else {
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func ParticipantsView(id: String) -> some View{
        let etudiants = etudiant.filtrerEtudiantsParCours(idCours: id)
        List(etudiants) { item in
            EtudiantRow(item: item, etudiant: etudiant, cours: cours)
        }
    }
}

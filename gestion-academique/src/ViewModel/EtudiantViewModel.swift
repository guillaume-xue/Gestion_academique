//
//  EtudiantViewModel.swift
//  list
//
//  Created by Guillaume on 20/02/2026.
//

import Foundation
import SwiftData

struct ReponseEtudiantsJSON: Codable {
    let etudiants: [EtudiantJSON]
}

struct EtudiantJSON: Codable {
    let id: String
    let nom: String
    let prenom: String
    let cours_inscrits: [String]
}

struct EtudiantDataImporter {
    @MainActor
    static func importEtudiants(context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<EtudiantEntity>())) ?? 0
        guard count == 0 else {
            return
        }
        
        guard let url = Bundle.main.url(forResource: "etudiants", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(ReponseEtudiantsJSON.self, from: data)
            let tousLesCours = (try? context.fetch(FetchDescriptor<CoursEntity>())) ?? []
            
            for e in decoded.etudiants {
                let nouvelEtudiant = EtudiantEntity(id: e.id, nom: e.nom, prenom: e.prenom)
                context.insert(nouvelEtudiant)
                for idCours in e.cours_inscrits {
                    if let coursTrouve = tousLesCours.first(where: { $0.id == idCours }) {
                        nouvelEtudiant.coursInscrits?.append(coursTrouve)
                    }
                }
            }
            try context.save()
            print("\(decoded.etudiants.count) étudiants importés avec succès")
        } catch {
            print("Erreur lors du décodage des étudiants : \(error)")
        }
    }
}

@Observable
class EtudiantViewModel {
    var listeEtudiant: [EtudiantEntity] = []

    func fetchFromDB(context: ModelContext) {
        let descriptor = FetchDescriptor<EtudiantEntity>(sortBy: [SortDescriptor(\.nom)])
        do {
            self.listeEtudiant = try context.fetch(descriptor)
        } catch {
            print("Erreur fetch étudiants : \(error)")
        }
    }

    func filtrerEtudiantsParCours(idCours: String) -> [EtudiantEntity] {
        return listeEtudiant.filter { etudiant in
            etudiant.coursInscrits?.contains(where: { $0.id == idCours }) ?? false
        }
    }
    
    func toggle(cours: CoursEntity) {
        cours.isEnabled.toggle()
    }
}

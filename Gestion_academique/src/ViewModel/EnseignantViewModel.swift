//
//  EnseignantViewModel.swift
//  list
//
//  Created by Guillaume on 23/02/2026.
//

import Foundation
import SwiftData

struct ReponseEnseignantsJSON: Codable {
    let enseignants: [EnseignantJSON]
}

struct EnseignantJSON: Codable {
    let id: String
    let nom: String
    let prenom: String
    let cours_enseignes: [String]
}

struct EnseignantDataImporter {
    @MainActor
    static func importEnseignants(context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<EnseignantEntity>())) ?? 0
        guard count == 0 else { return }
        
        guard let url = Bundle.main.url(forResource: "enseignants", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(ReponseEnseignantsJSON.self, from: data)
            let tousLesCours = (try? context.fetch(FetchDescriptor<CoursEntity>())) ?? []
            
            for e in decoded.enseignants {
                let nouvelEnseignant = EnseignantEntity(
                    id: e.id,
                    nom: e.nom,
                    prenom: e.prenom,
                )
                context.insert(nouvelEnseignant)
                for idCours in e.cours_enseignes {
                    if let coursTrouve = tousLesCours.first(where: { $0.id == idCours }) {
                        nouvelEnseignant.coursEnseignes?.append(coursTrouve)
                    }
                }
            }
            try context.save()
        } catch {
            print("Erreur import : \(error)")
        }
    }
}

@Observable
class EnseignantViewModel {
    var listeEnseignant: [EnseignantEntity] = []

    func fetchFromDB(context: ModelContext) {
        let descriptor = FetchDescriptor<EnseignantEntity>(sortBy: [SortDescriptor(\.nom)])
        do {
            self.listeEnseignant = try context.fetch(descriptor)
        } catch {
            print("Erreur fetch enseignants : \(error)")
        }
    }
}

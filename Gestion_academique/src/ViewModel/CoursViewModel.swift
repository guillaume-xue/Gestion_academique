//
//  CoursViewModel.swift
//  list
//
//  Created by Guillaume on 20/02/2026.
//

import Foundation
import SwiftData

struct ReponseCoursJSON: Codable {
    let cours: [Cours]
}

struct Cours: Codable {
    let id: String
    let titre: String
    let departement: String
    let credits: Int
    let description: String
    let horaires: String
    let salle: String
}

struct CoursDataImporter {
    @MainActor
    static func importCours(context: ModelContext) {
        let descriptor = FetchDescriptor<CoursEntity>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        
        guard existingCount == 0 else { return }
        
        guard let url = Bundle.main.url(forResource: "cours", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }
        
        do {
            let decoder = JSONDecoder()
            let reponse = try decoder.decode(ReponseCoursJSON.self, from: data)
            
            for c in reponse.cours {
                let nouvelleEntite = CoursEntity(
                    id: c.id,
                    titre: c.titre,
                    departement: c.departement,
                    credits: c.credits,
                    desc: c.description,
                    horaires: c.horaires,
                    salle: c.salle
                )
                context.insert(nouvelleEntite)
            }
            
            try context.save()
            print("Importation réussie")
        } catch {
            print("Erreur d'import : \(error)")
        }
    }
}

@Observable
class CoursViewModel {
    var listeDeCours: [CoursEntity] = []
    
    func fetchFromDB(context: ModelContext) {
        let descriptor = FetchDescriptor<CoursEntity>(sortBy: [SortDescriptor(\.titre)])
        do {
            self.listeDeCours = try context.fetch(descriptor)
        } catch {
            print("Erreur fetch")
        }
    }
    
    func filterCours(id: String) -> CoursEntity? {
        return listeDeCours.first(where: { $0.id == id })
    }
    
    func toggle(cours: CoursEntity) {
        cours.isEnabled.toggle()
    }
}


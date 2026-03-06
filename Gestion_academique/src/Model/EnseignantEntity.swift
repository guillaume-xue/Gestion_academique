//
//  EnseignantEntity.swift
//  list
//
//  Created by Guillaume on 23/02/2026.
//

import SwiftData

@Model
class EnseignantEntity {
    @Attribute(.unique) var id: String
    var nom: String
    var prenom: String
    var coursEnseignes: [CoursEntity]? = []
    
    init(id: String, nom: String, prenom: String, departement: String = "", specialite: String = "") {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.coursEnseignes = []
    }
}

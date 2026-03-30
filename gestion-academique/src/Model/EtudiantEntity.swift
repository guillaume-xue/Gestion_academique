//
//  EtudiantEntity.swift
//  list
//
//  Created by Guillaume on 20/02/2026.
//
import SwiftData

@Model
class EtudiantEntity {
    @Attribute(.unique) var id: String
    var nom: String
    var prenom: String
    var coursInscrits: [CoursEntity]? = []
    
    init(id: String, nom: String, prenom: String) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.coursInscrits = []
    }
}

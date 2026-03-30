//
//  CoursModel.swift
//  list
//
//  Created by Guillaume on 20/02/2026.
//
import SwiftData

@Model
class CoursEntity {
    @Attribute(.unique) var id: String
    var titre: String
    var departement: String
    var credits: Int
    var desc: String
    var horaires: String
    var salle: String
    var isEnabled: Bool
    
    @Relationship(inverse: \EtudiantEntity.coursInscrits)
        var etudiants: [EtudiantEntity]? = []
    
    init(id: String, titre: String, departement: String, credits: Int, desc: String, horaires: String, salle: String, isEnabled: Bool = false) {
        self.id = id
        self.titre = titre
        self.departement = departement
        self.credits = credits
        self.desc = desc
        self.horaires = horaires
        self.salle = salle
        self.isEnabled = isEnabled
        self.etudiants = []
    }
}

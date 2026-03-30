import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var cours = CoursViewModel()
    @State private var etudiant = EtudiantViewModel()
    @State private var enseignant = EnseignantViewModel()
    
    var body: some View {
        TabBar()
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        TabView {
            Tab("Cours", systemImage: "house"){
                CoursView(cours: self.cours, etudiant: self.etudiant, enseignant: self.enseignant)
            }
            Tab("Etudiant", systemImage: "person.3.fill"){
                EtudiantView(etudiant: etudiant, cours: self.cours, enseignant: enseignant)
            }
            Tab("Enseigants", systemImage: "person.2.badge.gearshape.fill"){
                EnseignantView(etudiant: etudiant, cours: cours, enseignant: enseignant)
            }
            Tab("Recherche", systemImage: "magnifyingglass", role: .search) {
                SearchView(
                    cours: self.cours,
                    etudiant: self.etudiant,
                    enseignant: self.enseignant
                )
            }
        }
        .onAppear {
            CoursDataImporter.importCours(context: modelContext)
            EtudiantDataImporter.importEtudiants(context: modelContext)
            EnseignantDataImporter.importEnseignants(context: modelContext)
            cours.fetchFromDB(context: modelContext)
            etudiant.fetchFromDB(context: modelContext)
            enseignant.fetchFromDB(context: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [CoursEntity.self, EtudiantEntity.self, EnseignantEntity.self], inMemory: true)
}

# Gestion académique - Projets Swift

Workspace contenant un applications de gestion académique Swift natives pour macOS.

## Projets

### 1. **Gestion académique** - Application de Gestion Académique

Application SwiftUI pour gérer les données universitaires (cours, étudiants, enseignants) avec persistance locale.

#### Features

- **3 onglets de navigation:**
  - **Cours** - Liste et gestion des cours disponibles
  - **Étudiants** - Gestion des étudiants et de leurs inscriptions
  - **Enseignants** - Gestion des enseignants et leurs cours

- Importation JSON automatique au démarrage
- Stockage persistant avec SwiftData
- Relations entre entités (étudiants ↔ cours)
- Interface réactive avec SwiftUI

#### Architecture

- **Pattern:** MVVM (Model-View-ViewModel)
- **Persistance:** SwiftData
- **UI Framework:** SwiftUI
- **Données:**
  - `src/Model/` - Entités données
  - `src/View/` - Interface utilisateur
  - `src/ViewModel/` - Logique métier et gestion d'état
  - `resources/` - Fichiers JSON (cours, étudiants, enseignants)

#### Lancer l'application

```bash
cd Gestion_academique
open Gestion_academique.xcodeproj
```

Sélectionner le schéma "Gestion_academique" et appuyer sur Run (⌘R).

---

## Structure du Workspace

```
Gestion_academique/                     # Application de gestion académique
  ├── Gestion_academique/
  │   ├── GestionAcademiqueApp.swift    # Point d'entrée SwiftUI
  │   ├── src/
  │   │   ├── Model/                    # Entités SwiftData
  │   │   ├── View/                     # Composants SwiftUI
  │   │   └── ViewModel/                # Logique métier
  │   ├── resources/                    # Fichiers JSON
  │   └── Assets.xcassets/              # Ressources visuelles
  └── Gestion_academique.xcodeproj/
```

---

## Environnement de développement

- **Gestion_academique:** Application SwiftUI moderne (iOS/macOS compatible)

Pour switch entre les projets, ouvrez simplement le fichier `.xcodeproj` correspondant.

---

## Notes de développement

### Gestion_academique
- Utilise SwiftData pour la persistance (remplace Core Data)
- Les données JSON sont chargées au démarrage et converties en entités SwiftData
- Les relations N-to-N entre étudiants et cours sont gérées via les ViewModels
import os

# Dossier lib existant (modifie si besoin)
lib_path = "lib"

# Structure à créer dans lib/
structure = {
    "main.dart": "",
    "models": {
        "employee.dart": ""
    },
    "services": {
        "api_service.dart": ""
    },
    "providers": {
        "auth_provider.dart": ""
    },
    "screens": {
        "login_screen.dart": "",
        "home_screen.dart": "",
        "add_employee_screen.dart": "",
        "edit_employee_screen.dart": ""
    },
    "widgets": {
        "employee_card.dart": ""
    }
}

def create_structure(base_path, struct):
    # Crée le dossier de base s'il n'existe pas
    os.makedirs(base_path, exist_ok=True)

    for name, content in struct.items():
        path = os.path.join(base_path, name)
        if isinstance(content, dict):
            # Créer un sous-dossier et récursion
            os.makedirs(path, exist_ok=True)
            create_structure(path, content)
        else:
            # Créer un fichier vide si n'existe pas déjà
            if not os.path.exists(path):
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Fichier créé : {path}")
            else:
                print(f"Fichier déjà existant : {path}")

# Exécution
create_structure(lib_path, structure)
print("\n✅ Structure Flutter lib/ créée avec succès !")

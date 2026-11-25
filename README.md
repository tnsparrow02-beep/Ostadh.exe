# Mon Prof (Flutter)

Assistant de classe hors-ligne pour professeur (toutes matières) : quiz, classes et points des élèves, emploi du temps (9 séances, fusion automatique), calendrier et notes. Arabe / français / anglais, chiffres toujours en 0-9.

## Fichiers (tous à la racine du dépôt)
- `*.dart` : le code (rangé automatiquement dans `lib/` par le workflow)
- `pubspec.yaml` : dépendances
- `success.wav` : son de réussite (rangé dans `assets/sounds/`)
- `build_apk.yml` : le workflow GitHub Actions (doit aussi exister dans `.github/workflows/`)
- `CHANGELOG.md` : liste des changements

## Mettre le projet sur GitHub
1. Créer un dépôt sur <https://github.com/new>.
2. **Add file > Upload files** : glisser **tous** les fichiers de ce dossier, puis **Commit changes** (branche `main`).
3. **Add file > Create new file**. Dans le nom, taper exactement `.github/workflows/build_apk.yml` (taper `/` crée les dossiers). Coller le contenu de `build_apk.yml`, puis **Commit changes**.
4. **Settings > Actions > General > Workflow permissions** : choisir **Read and write permissions**, puis **Save**.

## Récupérer l'APK
Chaque push sur `main` lance le build (5 à 10 minutes).
- **Releases** (colonne de droite du dépôt) : télécharger `math-teacher-v1.1.N.apk`.
- ou **Actions** > dernier run > **Artifacts** > `math-teacher-apk`.

Lancement manuel : **Actions > Build & Release Android APK > Run workflow**.

## Utilisation
- **Quiz** : liste déroulante pour choisir une question précise (sinon ordre aléatoire) ; pendant le quiz, l'icône liste permet de sauter à une question.
- **Élève sélectionné** : tirage au sort ou choix manuel ; son nom s'affiche en grand sous les boutons. Bonne réponse du premier coup = +1 point (réglable avec `kPointOnlyFirstTry` dans `presentation_screen.dart`).
- **Classes** : points visibles à côté de chaque élève ; bouton de remise à zéro.
- **Emploi du temps** : les séances consécutives de la même classe sont fusionnées.

## Vérification de l'e-mail à la création du compte (EmailJS, gratuit)

1. Créez un compte sur https://www.emailjs.com (plan gratuit).
2. **Email Services** → *Add New Service* (ex. Gmail) → notez le **Service ID**.
3. **Email Templates** → *Create New Template* : champ **To Email** = `{{to_email}}`, sujet « Code d'activation »,
   contenu « Bonjour {{name}}, votre code d'activation est : {{code}} ». Notez le **Template ID**.
4. **Account → General** : copiez la **Public Key**.
5. **Account → Security** : autorisez les appels API depuis les applications non-navigateur.
6. Ouvrez `email_config.dart` sur GitHub et collez les 3 valeurs. Tant qu'elles sont vides, le compte se crée sans e-mail.

## Installateur Windows (.exe)

Le fichier `build_windows.yml` (à placer dans `.github/workflows/`) construit l'application pour Windows à chaque envoi sur `main`.
Téléchargez `Ostadhi-Setup-1.9.N.exe` dans **Releases** (tag `win-v1.9.N`) ou dans **Actions → Artifacts**, puis lancez-le sur le PC.
Sur Windows, la photo se choisit dans un fichier (pas de caméra) et les données restent sur le PC (aucune synchronisation avec le téléphone, sauf sauvegarde/restauration).

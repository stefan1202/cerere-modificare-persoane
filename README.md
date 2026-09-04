# Cerere modificare număr persoane — Asociația de Proprietari Bl. M53 Sc. 2

Site static (GitHub Pages) prin care proprietarii depun online cererea de modificare a numărului de persoane dintr-un apartament, conform art. 30 din Legea nr. 196/2018.

Ce face site-ul:

- afișează pe scurt temeiul legal și trimite la procedura completă (`docs/`);
- colectează datele cererii (aceleași câmpuri ca Anexa 1 tipărită);
- proprietarul desenează semnătura pe ecran;
- în browser (nimic nu pleacă pe alt server) generează PDF-ul completat pe modelul oficial (`assets/cerere_template.pdf`), înglobează semnătura, data/ora și o amprentă SHA-256 a datelor trimise, apoi îl descarcă;
- opțional, trimite datele + amprenta asociației prin Formspree (e-mail) și deschide un e-mail pre-completat către asociație.

Semnătura este o **semnătură electronică simplă** (desen + amprentă SHA-256 + marcaj de timp), nu o semnătură calificată eIDAS. Pentru cererile interne ale asociației este suficientă; pentru o semnătură calificată ar fi nevoie de un furnizor acreditat (certSIGN, DigiSign, Trans Sped etc.).

## Structura

```
index.html                 pagina (formular + logică, fără backend)
assets/cerere_template.pdf modelul PDF completabil (Anexa 1 + Anexa 2)
assets/*.ttf               fonturi înglobate în PDF (diacritice)
assets/*.js                pdf-lib + fontkit (găzduite local, fără CDN)
docs/                      procedura completă (PDF și DOCX)
```

## Configurare (o singură dată)

Deschideți `index.html` și completați blocul `CONFIG` de la începutul scriptului:

```js
const CONFIG = {
  formspreeId: "",        // ex. "xabcdefg" — ID-ul formularului creat pe formspree.io
  associationEmail: "",   // adresa de e-mail a asociației, pentru butonul „Deschide e-mail”
  associationName: "Asociația de Proprietari Bl. M53 Sc. 2",
};
```

1. **Formspree** (gratuit, ~50 trimiteri/lună): creați un cont pe <https://formspree.io>, adăugați un formular cu adresa de e-mail a asociației, copiați ID-ul (`https://formspree.io/f/<ID>`) în `formspreeId`. Fiecare cerere ajunge pe e-mail cu toate câmpurile și amprenta SHA-256; proprietarul primește copie (`_replyto`).
2. **E-mail**: puneți adresa asociației în `associationEmail`. Dacă `formspreeId` rămâne gol, site-ul funcționează tot: proprietarul descarcă PDF-ul și îl trimite prin e-mail sau îl depune prin Aviziero.

## Publicare pe GitHub Pages

```bash
git init
git add .
git commit -m "Formular online cerere modificare numar persoane"
git branch -M main
git remote add origin git@github.com:stefan1202/cerere-modificare-persoane.git
git push -u origin main
```

Apoi, pe GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: `main` / `/ (root)` → Save**. Site-ul apare în 1–2 minute la `https://stefan1202.github.io/cerere-modificare-persoane/`.

## Verificarea unei cereri primite

PDF-ul conține pe pagina 1, sub semnătură, data/ora semnării și amprenta SHA-256; aceeași amprentă apare în e-mailul Formspree și în metadatele PDF-ului (câmpul *Subject*). Dacă cele două coincid, PDF-ul corespunde datelor trimise.

## Actualizarea modelului PDF sau a procedurii

Fișierele din `assets/` și `docs/` sunt generate din `Procedura_modificare_numar_persoane.docx`; după modificarea procedurii, înlocuiți PDF-urile și faceți un nou commit.

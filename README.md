# Cerere modificare număr persoane — Asociația de Proprietari Bl. M53 Sc. 2

Site static (GitHub Pages) prin care proprietarii depun online cererea de modificare a numărului de persoane dintr-un apartament, conform art. 30 din Legea nr. 196/2018.

Ce face site-ul:

- afișează pe scurt temeiul legal și trimite la procedura completă (`docs/`);
- colectează datele cererii (aceleași câmpuri ca Anexa 1 tipărită);
- proprietarul desenează semnătura pe ecran;
- în browser (nimic nu pleacă pe alt server) generează PDF-ul completat pe modelul oficial (`assets/cerere_template.pdf`), înglobează semnătura, data/ora și o amprentă SHA-256 a datelor trimise, apoi îl descarcă;
- trimite cererea asociației pe e-mail **cu PDF-ul semnat atașat** prin EmailJS (vezi `SETUP-EMAILJS.md`); alternativ, doar datele + amprenta prin Formspree, sau e-mail manual cu PDF-ul descărcat.

Semnătura este o **semnătură electronică simplă** (desen + amprentă SHA-256 + marcaj de timp), nu o semnătură calificată eIDAS. Pentru cererile interne ale asociației este suficientă; pentru o semnătură calificată ar fi nevoie de un furnizor acreditat (certSIGN, DigiSign, Trans Sped etc.).

## Structura

```
index.html                 pagina (formular + logică, fără backend)
assets/cerere_template.pdf modelul PDF completabil (Anexa 1 + Anexa 2)
assets/*.ttf               fonturi înglobate în PDF (diacritice)
assets/*.js                pdf-lib, fontkit, EmailJS SDK (găzduite local, fără CDN)
SETUP-EMAILJS.md           configurarea trimiterii pe e-mail cu PDF atașat
docs/                      procedura completă (PDF și DOCX)
```

## Configurare (o singură dată)

Deschideți `index.html` și completați blocul `CONFIG` de la începutul scriptului:

```js
const CONFIG = {
  associationName: "Asociația de Proprietari Bl. M53 Sc. 2",
  associationEmail: "",   // adresa de e-mail a asociației
  emailjs: { publicKey: "", serviceId: "", templateId: "" },  // vezi SETUP-EMAILJS.md
  formspreeId: "",        // alternativă fără atașament (formspree.io)
};
```

1. **EmailJS** (recomandat — PDF atașat): urmați pașii din [`SETUP-EMAILJS.md`](SETUP-EMAILJS.md). Planul Personal (9 $/lună) este necesar pentru atașamente.
2. **Formspree** (fără atașament): creați un formular pe <https://formspree.io> și puneți ID-ul în `formspreeId`. Se folosește doar dacă EmailJS nu este configurat.
3. **E-mail manual**: dacă nu configurați nimic, proprietarul descarcă PDF-ul și îl trimite la `associationEmail` (buton cu e-mail pre-completat) sau îl depune prin Aviziero.

## Publicare pe GitHub Pages

Dublu-click pe `PUBLICA.cmd` (prima dată inițializează repo-ul; ulterior face commit + push pentru orice modificare). Echivalentul manual:

```bash
git init && git add . && git commit -m "Formular online" && git branch -M main
git remote add origin git@github.com:stefan1202/cerere-modificare-persoane.git
git push -u origin main
```

Apoi, pe GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: `main` / `/ (root)` → Save**. Site-ul apare în 1–2 minute la `https://stefan1202.github.io/cerere-modificare-persoane/`.

## Verificarea unei cereri primite

PDF-ul conține pe pagina 1, sub semnătură, data/ora semnării și amprenta SHA-256; aceeași amprentă apare în e-mailul Formspree și în metadatele PDF-ului (câmpul *Subject*). Dacă cele două coincid, PDF-ul corespunde datelor trimise.

## Actualizarea modelului PDF sau a procedurii

Fișierele din `assets/` și `docs/` sunt generate din `Procedura_modificare_numar_persoane.docx`; după modificarea procedurii, înlocuiți PDF-urile și faceți un nou commit.

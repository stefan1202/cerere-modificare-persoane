# Configurare EmailJS — trimiterea cererii cu PDF-ul atașat

EmailJS trimite e-mailuri direct din browser, fără server propriu. Site-ul generează PDF-ul semnat și îl atașează e-mailului către asociație; proprietarul primește copie. Durata configurării: ~15 minute.

**Atenție la plan:** atașamentele necesită planul **Personal** (9 $/lună, până la 500 KB per atașament, 2.000 e-mailuri/lună). Pe planul gratuit (200 e-mailuri/lună) atașamentele nu sunt disponibile — site-ul va trimite tot datele, dar EmailJS va refuza atașamentul; în acest caz lăsați `pdf_attachment` neconfigurat în șablon. PDF-ul generat are ~150 KB, deci se încadrează în limita de 500 KB.

## 1. Cont și serviciu de e-mail

1. Creați un cont pe <https://www.emailjs.com> (ideal cu adresa de e-mail a asociației).
2. **Email Services → Add New Service** → alegeți furnizorul căsuței asociației (Gmail, Outlook, Yahoo etc.) → **Connect Account** și autorizați. Notați **Service ID** (ex. `service_ab12cd3`).

## 2. Șablonul de e-mail

**Email Templates → Create New Template**, apoi completați:

| Câmp | Valoare |
|---|---|
| Template Name | `Cerere modificare persoane` |
| Subject | `Cerere modificare număr persoane — ap. {{apartament}} — {{owner_name}}` |
| To Email | `{{to_email}}` (sau adresa asociației scrisă direct) |
| From Name | `Formular online AP Bl. M53 Sc. 2` |
| Reply To | `{{reply_to}}` |
| Cc | `{{owner_email}}` (proprietarul primește copia) |

**Content** (mod text sau HTML):

```
Bună ziua,

A fost depusă o cerere de modificare a numărului de persoane prin formularul online.

{{rezumat}}

Semnat electronic la: {{semnat_la}}
Amprentă SHA-256 a datelor: {{sha256}}
Fișier atașat: {{fisier_pdf}}

Cererea se înregistrează în registrul asociației și se operează în Aviziero conform procedurii (termen de răspuns: 10 zile).
```

Variabile disponibile în șablon: `to_email`, `owner_email`, `owner_name`, `reply_to`, `apartament`, `scara`, `etaj`, `telefon`, `calitate`, `persoane_anterior`, `persoane_nou`, `data_schimbarii`, `motive`, `persoane`, `documente`, `rezumat`, `semnat_la`, `sha256`, `fisier_pdf`.

## 3. Atașamentul PDF (tab „Attachments” din șablon)

1. **Add Attachment → Variable Attachment**.
2. **Parameter Name:** `pdf_attachment`
3. **Filename:** `{{fisier_pdf}}`
4. Content Type: `application/pdf` (dacă este cerut).
5. Salvați șablonul și notați **Template ID** (ex. `template_xy98zw7`).

## 4. Cheia publică și securitatea

1. **Account → General → Public Key** — copiați-l.
2. **Account → Security**: bifați **Allow EmailJS API for these domains only** și adăugați `stefan1202.github.io`. Astfel cheia publică (vizibilă în pagina site-ului) nu poate fi folosită de pe alte site-uri.
3. Opțional: **Enable reCAPTCHA** nu este necesar pentru volumul asociației; limita de 2.000 e-mailuri/lună este suficientă.

## 5. Completați `index.html`

În blocul `CONFIG` de la începutul scriptului:

```js
const CONFIG = {
  associationName: "Asociația de Proprietari Bl. M53 Sc. 2",
  associationEmail: "adresa@asociatiei.ro",
  emailjs: {
    publicKey: "AbCdEfGhIjKlMnOpQ",
    serviceId: "service_ab12cd3",
    templateId: "template_xy98zw7",
  },
  formspreeId: "",
};
```

Salvați, apoi rulați din nou `PUBLICA.cmd` (face commit + push). După 1–2 minute testați formularul cu butonul „Semnează și trimite cererea”; e-mailul trebuie să ajungă la asociație cu PDF-ul atașat și proprietarul în Cc.

## Depanare

- **„The attachment is too large” / eroare 50KB** — parametrul din șablon nu se numește exact `pdf_attachment` sau planul nu permite atașamente.
- **Eroare 412 / „domain not allowed”** — domeniul `stefan1202.github.io` nu este în lista din Account → Security.
- **E-mailul nu ajunge** — verificați în EmailJS **Email History** starea trimiterii și folderul Spam al căsuței asociației.
- Dacă EmailJS nu este configurat (câmpuri goale), site-ul funcționează în continuare: PDF-ul se descarcă și proprietarul îl trimite manual sau prin Aviziero.

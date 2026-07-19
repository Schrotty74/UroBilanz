#!/usr/bin/env python3
"""Create the public German and English UroBilanz user manuals."""

from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    Image,
    KeepTogether,
    PageBreak,
    PageTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "docs" / "output" / "pdf"
ICON = ROOT / "apps" / "web" / "assets" / "urobilanz-app-icon.png"
SCREENSHOTS = ROOT / "docs" / "screenshots" / "github"

NAVY = colors.HexColor("#172126")
TEAL = colors.HexColor("#1F6F78")
TEAL_DARK = colors.HexColor("#15545B")
BLUE = colors.HexColor("#2D62D9")
PALE_BLUE = colors.HexColor("#EAF2F8")
PALE_TEAL = colors.HexColor("#E8F4F3")
LINE = colors.HexColor("#D9E2E2")
MUTED = colors.HexColor("#63717A")
WHITE = colors.white


def asset(path):
    return str(path)


def image(path, max_width, max_height):
    item = Image(asset(path))
    scale = min(max_width / item.imageWidth, max_height / item.imageHeight)
    item.drawWidth = item.imageWidth * scale
    item.drawHeight = item.imageHeight * scale
    return item


def styles():
    base = getSampleStyleSheet()
    return {
        "title": ParagraphStyle(
            "ManualTitle", parent=base["Title"], fontName="Helvetica-Bold",
            fontSize=31, leading=37, textColor=NAVY, alignment=TA_CENTER,
            spaceAfter=12,
        ),
        "subtitle": ParagraphStyle(
            "ManualSubtitle", parent=base["Normal"], fontName="Helvetica",
            fontSize=15, leading=21, textColor=MUTED, alignment=TA_CENTER,
        ),
        "h1": ParagraphStyle(
            "ManualHeading1", parent=base["Heading1"], fontName="Helvetica-Bold",
            fontSize=23, leading=28, textColor=NAVY, spaceBefore=4, spaceAfter=12,
        ),
        "h2": ParagraphStyle(
            "ManualHeading2", parent=base["Heading2"], fontName="Helvetica-Bold",
            fontSize=15, leading=20, textColor=BLUE, spaceBefore=12, spaceAfter=7,
        ),
        "body": ParagraphStyle(
            "ManualBody", parent=base["BodyText"], fontName="Helvetica",
            fontSize=10.4, leading=15.2, textColor=NAVY, spaceAfter=6,
        ),
        "small": ParagraphStyle(
            "ManualSmall", parent=base["BodyText"], fontName="Helvetica",
            fontSize=8.8, leading=12, textColor=MUTED,
        ),
        "table": ParagraphStyle(
            "ManualTable", parent=base["BodyText"], fontName="Helvetica",
            fontSize=8.8, leading=11.5, textColor=NAVY,
        ),
        "tableHead": ParagraphStyle(
            "ManualTableHead", parent=base["BodyText"], fontName="Helvetica-Bold",
            fontSize=8.8, leading=11.5, textColor=WHITE,
        ),
        "callout": ParagraphStyle(
            "ManualCallout", parent=base["BodyText"], fontName="Helvetica",
            fontSize=10.2, leading=14.5, textColor=NAVY,
        ),
    }


def p(text, style):
    return Paragraph(text, style)


def bullets(items, style):
    return [p("- " + item, style) for item in items]


def callout(text, style, accent=BLUE):
    table = Table([[p(text, style)]], colWidths=[16.1 * cm])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), PALE_BLUE),
        ("BOX", (0, 0), (-1, -1), 0.5, accent),
        ("LINEBEFORE", (0, 0), (0, -1), 3, accent),
        ("LEFTPADDING", (0, 0), (-1, -1), 12),
        ("RIGHTPADDING", (0, 0), (-1, -1), 12),
        ("TOPPADDING", (0, 0), (-1, -1), 10),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
    ]))
    return table


def info_table(rows, s, widths=(4.4 * cm, 11.7 * cm)):
    data = [[p(a, s["tableHead"]), p(b, s["tableHead"])] for a, b in rows[:1]]
    data += [[p(a, s["table"]), p(b, s["table"])] for a, b in rows[1:]]
    table = Table(data, colWidths=list(widths), repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), BLUE),
        ("GRID", (0, 0), (-1, -1), 0.35, LINE),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 8),
        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
        ("BACKGROUND", (0, 1), (-1, -1), colors.HexColor("#FBFCFD")),
    ]))
    return table


def section(title, paragraphs, s, image_path=None, image_label=None):
    flow = [p(title, s["h1"])]
    for paragraph in paragraphs:
        if isinstance(paragraph, list):
            flow.extend(bullets(paragraph, s["body"]))
        else:
            flow.append(p(paragraph, s["body"]))
    if image_path:
        flow.extend([Spacer(1, 8), image(image_path, 15.9 * cm, 9.0 * cm)])
        if image_label:
            flow.append(Spacer(1, 4))
            flow.append(p(image_label, s["small"]))
    return flow


def footer(canvas, doc):
    canvas.saveState()
    width, _ = A4
    canvas.setStrokeColor(LINE)
    canvas.line(2.0 * cm, 1.45 * cm, width - 2.0 * cm, 1.45 * cm)
    canvas.setFont("Helvetica", 8.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(2.0 * cm, 0.95 * cm, doc.manual_footer)
    canvas.drawRightString(width - 2.0 * cm, 0.95 * cm, str(doc.page))
    canvas.restoreState()


def manual_data(language):
    german = language == "de"
    if german:
        return {
            "filename": "UroBilanz-Handbuch-DE.pdf",
            "title": "UroBilanz Handbuch",
            "subtitle": "Der klare Leitfaden fuer dein lokales Urin- und Fluessigkeitsprotokoll",
            "cover": "UroBilanz hilft dir, lokale Protokolldaten zu ordnen und auszuwerten. Dieses vollstaendige Handbuch beschreibt den ersten Start, jede Ansicht, Eingabefelder, Schalter, Exporte und Datenschutzgrenzen.",
            "edition": "Deutsch | Stand: Juli 2026",
            "footer": "UroBilanz Handbuch",
            "toc": [
                "1. Zweck, Grenzen und Plattformen", "2. Bildschirmkarte und Bedienelemente",
                "3. Erster Start, CSV laden und CSV ergaenzen", "4. Lokale Speicherung und Daten entfernen",
                "5. Eintraege erfassen, bearbeiten und loeschen", "6. Dashboard und Zeitansichten",
                "7. Messtage, Vollstaendigkeit und Regeln", "8. Backups und Exportformate",
                "9. Arztbericht erstellen", "10. Themes, Sprache und Darstellung",
                "11. Einstellungen, Updates und Ueber", "12. KI-Hilfe, Fehlerbericht und Support",
                "13. Datenschutz und sichere Weitergabe", "14. Problemloesung und Begriffe",
            ],
            "start": "Erster sinnvoller Start",
            "manual": "Handbuch oeffnen",
            "sections": {
                "overview": "1. Zweck, Grenzen und Plattformen",
                "where": "2. Bildschirmkarte und Bedienelemente",
                "first": "3. Erster Start, CSV laden und CSV ergaenzen",
                "storage": "4. Lokale Speicherung und Daten entfernen",
                "entries": "5. Eintraege erfassen, bearbeiten und loeschen",
                "views": "6. Dashboard und Zeitansichten",
                "rules": "7. Messtage, Vollstaendigkeit und Regeln",
                "exports": "8. Backups und Exportformate",
                "report": "9. Arztbericht erstellen",
                "settings": "10. Themes, Sprache und Darstellung",
                "updates": "11. Einstellungen, Updates und Ueber",
                "support": "12. KI-Hilfe, Fehlerbericht und Support",
                "privacy": "13. Datenschutz und sichere Weitergabe",
                "troubleshooting": "14. Problemloesung und Begriffe",
            },
        }
    return {
        "filename": "UroBilanz-User-Manual-EN.pdf",
        "title": "UroBilanz User Manual",
        "subtitle": "A clear guide to your local urine and fluid record",
        "cover": "UroBilanz helps you organize and review local record data. This complete manual covers first use, every view, input field, control, export, and privacy boundary.",
        "edition": "English | July 2026 edition",
        "footer": "UroBilanz User Manual",
        "toc": [
            "1. Purpose, limits, and platforms", "2. Screen map and controls",
            "3. First start, load CSV, and merge CSV", "4. Local storage and removing data",
            "5. Add, edit, and delete entries", "6. Dashboard and time views",
            "7. Measurement days, completeness, and rules", "8. Backups and export formats",
            "9. Create a medical report", "10. Themes, language, and appearance",
            "11. Settings, updates, and About", "12. AI help, bug reports, and support",
            "13. Privacy and safe sharing", "14. Troubleshooting and terms",
        ],
        "start": "First useful start",
        "manual": "Open manual",
        "sections": {
            "overview": "1. Purpose, limits, and platforms",
            "where": "2. Screen map and controls",
            "first": "3. First start, load CSV, and merge CSV",
            "storage": "4. Local storage and removing data",
            "entries": "5. Add, edit, and delete entries",
            "views": "6. Dashboard and time views",
            "rules": "7. Measurement days, completeness, and rules",
            "exports": "8. Backups and export formats",
            "report": "9. Create a medical report",
            "settings": "10. Themes, language, and appearance",
            "updates": "11. Settings, updates, and About",
            "support": "12. AI help, bug reports, and support",
            "privacy": "13. Privacy and safe sharing",
            "troubleshooting": "14. Troubleshooting and terms",
        },
    }


def build_manual(language):
    data = manual_data(language)
    s = styles()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    output = OUTPUT / data["filename"]
    frame = Frame(2.0 * cm, 1.75 * cm, 17.0 * cm, 25.4 * cm, id="main")
    doc = BaseDocTemplate(
        str(output), pagesize=A4, leftMargin=2.0 * cm, rightMargin=2.0 * cm,
        topMargin=1.8 * cm, bottomMargin=1.75 * cm,
        title=data["title"], author="Schrotty74", subject="UroBilanz user guide",
    )
    doc.manual_footer = data["footer"]
    doc.addPageTemplates([PageTemplate(id="manual", frames=[frame], onPage=footer)])
    story = []

    # Cover
    story.extend([
        Spacer(1, 2.2 * cm), image(ICON, 2.2 * cm, 2.2 * cm), Spacer(1, 0.45 * cm),
        p(data["title"], s["title"]), p(data["subtitle"], s["subtitle"]), Spacer(1, 0.75 * cm),
        callout(data["cover"], s["callout"]), Spacer(1, 0.55 * cm),
        p(data["edition"], s["subtitle"]), Spacer(1, 0.7 * cm),
        image(SCREENSHOTS / "web" / "web-dashboard-violet-night.png", 13.0 * cm, 7.5 * cm),
        Spacer(1, 4), p("UroBilanz - Web-App mit synthetischen Demo-Daten" if language == "de" else "UroBilanz - web app with synthetic demo data", s["small"]),
        PageBreak(),
    ])

    # Contents and overview.
    story.append(p("Inhalt" if language == "de" else "Contents", s["h1"]))
    for item in data["toc"]:
        story.append(p(item, s["body"]))
    overview_text = (
        "UroBilanz ist ein lokales Protokoll- und Auswertungstool fuer Urin-, Wasser- und Hinweis-Eintraege. Es erstellt keine Diagnose und gibt keine medizinischen Empfehlungen. Die Web-App und die macOS-App verwenden dieselben Grundfunktionen."
        if language == "de" else
        "UroBilanz is a local logging and review tool for urine, water, and note entries. It does not create diagnoses or provide medical recommendations. The web app and macOS app use the same core functions."
    )
    story.extend(section(data["sections"]["overview"], [overview_text, [
        "CSV laden: Eine Original-Urinote-CSV oder Tagesdaten-CSV lokal importieren." if language == "de" else "Load CSV: import an original Urinote CSV or daily-data CSV locally.",
        "Eintrag: Urin, Wasser oder einen Hinweis manuell erfassen." if language == "de" else "Entry: record urine, water, or a note manually.",
        "Ansichten: Dashboard sowie Jahr, Monat, Woche, Tag und Regeln vergleichen." if language == "de" else "Views: compare Dashboard, Year, Month, Week, Day, and Rules.",
        "Sichern: Daten als Backup, Tagesdaten oder JSON lokal exportieren." if language == "de" else "Keep copies: export data locally as a backup, daily data, or JSON.",
    ]], s))
    story.append(PageBreak())

    # Where to find what.
    where_rows = ([
        ("Funktion", "Ort und Wirkung"),
        ("CSV laden", "Oben rechts und auch in der leeren Startansicht. Oeffnet einen lokalen Dateidialog; die Datei bleibt auf deinem Geraet."),
        ("CSV ergaenzen", "Oben rechts. Fuegt neue Eintraege aus einer weiteren Original-Urinote-CSV hinzu und ueberspringt bereits vorhandene Eintraege."),
        ("Eintrag", "Oben rechts. Oeffnet die manuelle Eingabe fuer Urin, Wasser und Hinweise."),
        ("Dashboard / Jahr / Monat / Woche / Tag / Regeln", "Register links in der Werkzeugleiste. Sie wechseln nur die lokale Darstellung deiner geladenen Daten."),
        ("Jahr und Monat", "Filter rechts in der Werkzeugleiste. Begrenzen die angezeigten Tabellen und Diagramme auf den gewaehlten Zeitraum."),
        ("Backup", "Menue rechts: Komplett-Backup, Tagesbackup oder JSON-Export lokal speichern."),
        ("Arztbericht", "Rechts in der Werkzeugleiste. Waehlt Zeitraum und Inhalte fuer einen lokalen, druckfreundlichen Bericht."),
        ("Daten merken / gespeicherte Daten loeschen", "Rechts unter der Werkzeugleiste. Speichert die geladene CSV nur lokal im Browser bzw. in der macOS-App oder entfernt sie wieder."),
        ("Theme und Sprache", "Oben rechts. Veraendern das Erscheinungsbild beziehungsweise die sichtbare Sprache, nicht die Messdaten."),
    ] if language == "de" else [
        ("Function", "Location and effect"),
        ("Load CSV", "Top right and in the empty start view. Opens a local file dialog; the file stays on your device."),
        ("Merge CSV", "Top right. Adds new entries from another original Urinote CSV and skips entries already present."),
        ("Entry", "Top right. Opens manual entry for urine, water, and notes."),
        ("Dashboard / Year / Month / Week / Day / Rules", "Tabs on the left of the toolbar. They only change the local presentation of loaded data."),
        ("Year and Month", "Filters on the right of the toolbar. Limit visible tables and charts to the selected period."),
        ("Backup", "Menu on the right: save a complete backup, daily backup, or JSON export locally."),
        ("Medical report", "Right side of the toolbar. Choose a period and contents for a local print-friendly report."),
        ("Remember data / Delete saved data", "Below the toolbar. Saves the loaded CSV only locally in the browser or macOS app, or removes it again."),
        ("Theme and Language", "Top right. Change appearance or visible language, never measurement data."),
    ])
    story.extend([p(data["sections"]["where"], s["h1"]), info_table(where_rows, s), Spacer(1, 12), image(SCREENSHOTS / "web" / "web-day-violet-night.png", 15.6 * cm, 8.3 * cm), Spacer(1, 4), p("Register, Filter und Tagesansicht" if language == "de" else "Tabs, filters, and day view", s["small"]), PageBreak()])

    # First start and entries.
    first_steps = [
        "1. Oeffne UroBilanz. Solange keine Daten geladen sind, siehst du die Startansicht.",
        "2. Waehle CSV laden und waehle eine Original-Urinote-CSV oder eine Tagesdaten-CSV.",
        "3. Pruefe das Dashboard und wechsle bei Bedarf zu Tag oder Woche.",
        "4. Aktiviere Daten merken nur, wenn die CSV auf diesem Geraet lokal gespeichert bleiben soll.",
        "5. Sichere wichtige Staende regelmaessig ueber Backup.",
    ] if language == "de" else [
        "1. Open UroBilanz. As long as no data is loaded, you see the start view.",
        "2. Choose Load CSV and select an original Urinote CSV or a daily-data CSV.",
        "3. Review the Dashboard and switch to Day or Week when useful.",
        "4. Enable Remember data only when the CSV should stay stored locally on this device.",
        "5. Save important states regularly through Backup.",
    ]
    story.extend(section(data["sections"]["first"], [
        "Die App startet absichtlich leer. So bleiben vorhandene Daten anderer Personen oder anderer App-Varianten getrennt." if language == "de" else "The app deliberately starts empty. This keeps existing data from other people or app variants separate.",
        first_steps,
        "CSV ergaenzen ist nur fuer eine weitere Original-Urinote-CSV gedacht. Eine Tagesdaten-CSV ist ein Exportformat und kann nicht als Ergaenzung verwendet werden." if language == "de" else "Merge CSV is only for another original Urinote CSV. A daily-data CSV is an export format and cannot be merged.",
    ], s, SCREENSHOTS / "web" / "web-entry-violet-night.png", "Manuelle Eingabe in der Web-App" if language == "de" else "Manual entry in the web app"))
    story.append(PageBreak())

    storage_rows = ([
        ("Aktion", "Was lokal geschieht"),
        ("Ohne Daten merken", "Geladene und manuell erfasste Daten sind nur fuer die laufende Sitzung vorhanden. Beim erneuten Oeffnen laedt die App keine fruehere CSV automatisch."),
        ("Daten merken", "Die aktuell geladene CSV wird in der lokalen Speicherung des jeweiligen Browsers oder der macOS-App hinterlegt. Sie wird beim naechsten Start wieder verwendet."),
        ("Gespeicherte Daten loeschen", "Entfernt nur die von UroBilanz gemerkte lokale Kopie und deaktiviert Daten merken. Die urspruengliche Datei im Finder und externe Backups bleiben unveraendert."),
        ("Tag oder Eintrag loeschen", "Entfernt diese Inhalte aus der aktuellen lokalen Auswertung und damit aus kuenftigen Exporten. Erstelle vorher ein Backup, wenn du sie behalten willst."),
        ("App-Varianten", "Dev, Beta und Final verwenden getrennte App-Container. Daten aus einer Variante erscheinen nicht automatisch in einer anderen."),
    ] if language == "de" else [
        ("Action", "What happens locally"),
        ("Without Remember data", "Loaded and manually added data exists only for the current session. On reopening, the app does not automatically load an earlier CSV."),
        ("Remember data", "The currently loaded CSV is stored in the local storage of the browser or macOS app. It is used again at the next start."),
        ("Delete saved data", "Removes only the local copy remembered by UroBilanz and turns off Remember data. The original file in Finder and external backups remain unchanged."),
        ("Delete day or entry", "Removes this content from current local analysis and therefore future exports. Create a backup first if you need to keep it."),
        ("App variants", "Dev, Beta, and Final use separate app containers. Data from one variant does not automatically appear in another."),
    ])
    story.extend([p(data["sections"]["storage"], s["h1"]), p("UroBilanz speichert keine Messdaten in einem Cloud-Konto. Entscheidend ist, ob du die lokale Erinnerungsfunktion einschaltest. Die folgende Tabelle trennt die gleich klingenden Loesch- und Speicheraktionen." if language == "de" else "UroBilanz does not store measurement data in a cloud account. The important choice is whether you enable local remembering. The following table distinguishes the similarly named storage and deletion actions.", s["body"]), info_table(storage_rows, s), Spacer(1, 10), callout("Ein Backup ist eine eigenstaendige Datei. Daten merken ist kein Backup und schuetzt nicht vor dem Loeschen eines Tages oder dem Verlust des Geraets." if language == "de" else "A backup is a separate file. Remember data is not a backup and does not protect against deleting a day or losing the device.", s["callout"], TEAL), PageBreak()])

    entry_text = (
        "Mit Eintrag oeffnest du die manuelle Eingabe. Datum und Uhrzeit bestimmen, welchem Messtag eine Angabe zugeordnet wird. Trage mindestens einen Urinwert, einen Wasserwert oder einen Hinweis ein. Mit Hinzufuegen bleibt der Dialog offen; mit Hinzufuegen & schliessen wird er danach geschlossen. Zuruecksetzen leert den Dialog. In der Tagesansicht kannst du einzelne Eintraege bearbeiten oder loeschen; Tag loeschen entfernt alle Eintraege dieses Messtags aus der lokalen Auswertung und aus kuenftigen Exporten."
        if language == "de" else
        "Entry opens manual input. Date and time determine which measurement day receives a value. Enter at least a urine value, water value, or note. Add keeps the dialog open; Add & close closes it afterwards. Reset clears the dialog. In the Day view, you can edit or delete individual entries; Delete day removes all entries of that measurement day from local analysis and future exports."
    )
    story.extend(section(data["sections"]["entries"], [entry_text, [
        "Urin ml und Wasser ml: Mengen bleiben getrennt; Wasser wird nicht zur Urinmenge addiert." if language == "de" else "Urine ml and Water ml: amounts stay separate; water is not added to urine volume.",
        "Hinweis: sichtbarer Kontext, aber keine automatische medizinische Bewertung." if language == "de" else "Note: visible context, but no automatic medical assessment.",
        "Urin Hinweis: Ein Hinweis bei einem Urinwert bleibt an dessen Uhrzeit ausgerichtet." if language == "de" else "Urine note: a note for a urine value stays aligned with that time.",
    ]], s, SCREENSHOTS / "swift" / "swift-entry-creme-salbei.png", "Manuelle Eingabe in der macOS-App" if language == "de" else "Manual entry in the macOS app"))
    entry_rows = ([
        ("Feld oder Schalter", "Zweck und Wirkung"),
        ("Datum", "Legt den Kalendertag fest. Die Zuordnung zum Messtag folgt zusaetzlich der 06:00-Grenze aus Kapitel 7."),
        ("Uhrzeit Urin", "Zeitpunkt des Urinwerts. Sie erscheint in der Tagesansicht und bestimmt die zeitliche Reihenfolge."),
        ("Urin ml", "Menge eines Urinereignisses in Millilitern. Nur diese Menge wird fuer Urinsummen und die niedrig/normal-Kennzeichnung verwendet."),
        ("Uhrzeit Wasser", "Zeitpunkt einer Trinkmenge. Wasser bleibt eine getrennte Kategorie und wird nicht zur Urinmenge gerechnet."),
        ("Wasser ml", "Menge eines Trinkereignisses in Millilitern; sie dient als sichtbarer Kontext in den Ansichten und Exporten."),
        ("Hinweis", "Freier lokaler Text zu einem Zeitpunkt oder Tag. Er ist nur Kontext und aendert keine automatische Bewertung."),
        ("Hinzufuegen / Hinzufuegen & schliessen", "Speichert die eingegebenen Werte lokal. Die erste Variante laesst den Dialog fuer weitere Eingaben offen; die zweite beendet den Dialog danach."),
        ("Zuruecksetzen", "Leert die noch nicht gespeicherten Werte des Dialogs. Bereits gespeicherte Eintraege bleiben erhalten."),
    ] if language == "de" else [
        ("Field or control", "Purpose and effect"),
        ("Date", "Sets the calendar date. Assignment to a measurement day also follows the 06:00 boundary in chapter 7."),
        ("Urine time", "Time of the urine value. It appears in the Day view and determines chronological order."),
        ("Urine ml", "Amount of a urine event in millilitres. Only this amount is used for urine totals and the low/normal label."),
        ("Water time", "Time of a drinking amount. Water stays a separate category and is not counted as urine."),
        ("Water ml", "Amount of a drinking event in millilitres; it provides visible context in views and exports."),
        ("Note", "Free local text for a time or day. It is context only and does not change automatic evaluation."),
        ("Add / Add & close", "Stores the entered values locally. The first option keeps the dialog open for further entries; the second closes it afterwards."),
        ("Reset", "Clears the dialog values that have not been saved. Existing entries remain."),
    ])
    story.extend([
        PageBreak(),
        p("Eingabefelder und Aktionen" if language == "de" else "Input fields and actions", s["h2"]),
        p("Beim Bearbeiten eines vorhandenen Eintrags gilt dieselbe Bedeutung der Felder. Aendere nur die Werte, die korrigiert werden sollen; pruefe danach die Tagesansicht, weil sich Reihenfolge, Summen und Vollstaendigkeit dadurch aendern koennen." if language == "de" else "When editing an existing entry, the fields have the same meaning. Change only the values that need correction; then review the Day view because order, totals, and completeness can change.", s["body"]),
        info_table(entry_rows, s),
        Spacer(1, 9),
        callout("Loeschen ist eine lokale Aenderung und wird nicht rueckgaengig gemacht. Ein vorher erstelltes Komplett-Backup ist die einfachste Moeglichkeit, einen frueheren Stand zu behalten." if language == "de" else "Deletion is a local change and is not undone automatically. A complete backup created beforehand is the simplest way to retain an earlier state.", s["callout"], TEAL),
        PageBreak(),
    ])

    # Views and rules.
    view_rows = ([
        ("Ansicht", "Was sie zeigt und wann sie sinnvoll ist"),
        ("Dashboard", "Schneller Gesamtueberblick ueber den geladenen oder gefilterten Zeitraum: Summen, Durchschnittswerte, Verlauf und Kennzeichnungen. Nutze es nach dem Laden fuer den ersten Plausibilitaetscheck."),
        ("Jahr", "Zusammenfassung nach Monaten im gewaehlten Jahr. Sinnvoll fuer laengere Verlaeufe und den Vergleich von Monaten."),
        ("Monat", "Zusammenfassung der Messtage im gewaehlten Monat. Sinnvoll, um Regelmaessigkeit und einzelne unvollstaendige Tage zu sehen."),
        ("Woche", "Verdichtet die Daten in Kalenderwochen. Sinnvoll fuer einen mittleren Zeitraum ohne die Detailmenge der Tagesansicht."),
        ("Tag", "Chronologische Liste einzelner Urin-, Wasser- und Hinweis-Eintraege. Hier lassen sich einzelne Eintraege bearbeiten oder loeschen und ein ganzer Messtag entfernen."),
        ("Regeln", "Erklaert die feste Zuordnung zu Messtagen sowie Vollstaendigkeit und Kennzeichnungen. Diese Seite veraendert keine Daten."),
        ("Jahr-/Monat-Filter", "Begrenzen die angezeigten Daten in den passenden Ansichten. Sie loeschen, verschieben oder exportieren nichts."),
    ] if language == "de" else [
        ("View", "What it shows and when it is useful"),
        ("Dashboard", "Fast overview of the loaded or filtered period: totals, averages, progress, and labels. Use it for an initial plausibility check after loading."),
        ("Year", "Summary by month in the selected year. Useful for longer trends and comparing months."),
        ("Month", "Summary of measurement days in the selected month. Useful to see regularity and individual incomplete days."),
        ("Week", "Condenses data into calendar weeks. Useful for a medium period without the detail volume of Day."),
        ("Day", "Chronological list of individual urine, water, and note entries. Here you can edit or delete individual entries and remove a whole measurement day."),
        ("Rules", "Explains fixed measurement-day assignment, completeness, and labels. This page does not change data."),
        ("Year/month filters", "Limit visible data in suitable views. They do not delete, move, or export anything."),
    ])
    rules_rows = ([
        ("Regel", "Bedeutung"),
        ("Messtag", "Laeuft von 06:00 bis 05:59. Eintraege von 00:00 bis 05:59 gehoeren zum Vortag; die Uhrzeit bleibt sichtbar."),
        ("Vollstaendig", "Nur Tage mit mindestens acht Stunden zwischen erstem und letztem Urin- oder Wasserwert gehen in Summen, Durchschnitt und Bewertung ein."),
        ("Niedrig", "Ein vollstaendiger Tag mit weniger als 700 ml Urin wird als niedrig gezeigt."),
        ("Normal", "Ein vollstaendiger Tag ab 700 ml Urin wird als normal gezeigt."),
        ("Unvollstaendig", "Randtage bleiben sichtbar, fliessen aber nicht in Summen, Durchschnitt oder niedrig/normal ein."),
        ("Wasser und Hinweise", "Bleiben getrennt als Kontext sichtbar und veraendern keine Bewertung."),
    ] if language == "de" else [
        ("Rule", "Meaning"),
        ("Measurement day", "Runs from 06:00 to 05:59. Entries from 00:00 to 05:59 belong to the previous day; the time remains visible."),
        ("Complete", "Only days with at least eight hours between the first and last urine or water value are included in totals, averages, and evaluation."),
        ("Low", "A complete day with less than 700 ml of urine is shown as low."),
        ("Normal", "A complete day with 700 ml or more of urine is shown as normal."),
        ("Incomplete", "Boundary days stay visible but are excluded from totals, averages, and low/normal evaluation."),
        ("Water and notes", "Stay visible separately as context and do not change evaluation."),
    ])
    view_intro = (
        "Das Dashboard fasst den geladenen Zeitraum zusammen. Jahr, Monat und Woche verdichten dieselben Daten in Tabellen. Die Tagesansicht zeigt die einzelnen Zeiten, Mengen und Hinweise. Regeln erklaert die verwendete organisatorische Logik. Die Streak-Anzeige zaehlt aufeinanderfolgende Messtage mit Eintraegen."
        if language == "de" else
        "The Dashboard summarizes the loaded period. Year, Month, and Week condense the same data into tables. Day shows individual times, amounts, and notes. Rules explains the organizational logic in use. Streak counts consecutive measurement days with entries."
    )
    story.extend([p(data["sections"]["views"], s["h1"]), p(view_intro, s["body"]), info_table(view_rows, s), Spacer(1, 8), image(SCREENSHOTS / "swift" / "swift-day-creme-salbei.png", 15.6 * cm, 8.3 * cm), Spacer(1, 4), p("Tagesansicht in der macOS-App" if language == "de" else "Day view in the macOS app", s["small"]), PageBreak()])
    story.extend([p(data["sections"]["rules"], s["h1"]), p("UroBilanz verwendet feste organisatorische Regeln, damit Zeiten am Tagesrand einheitlich ausgewertet werden. Diese Regeln gelten gleich in allen Ansichten, Berichten und Exporten der Tageszusammenfassung." if language == "de" else "UroBilanz uses fixed organizational rules so times at the day boundary are evaluated consistently. These rules apply equally in all views, reports, and daily-summary exports.", s["body"]), info_table(rules_rows, s), Spacer(1, 10), callout("Die Kennzeichnungen niedrig, normal und unvollstaendig sind organisatorische Auswertungen. Sie sind keine Diagnose und ersetzen keine medizinische Beratung." if language == "de" else "The low, normal, and incomplete labels are organizational evaluations. They are not a diagnosis and do not replace medical advice.", s["callout"], TEAL), PageBreak()])

    # Exports.
    exports_rows = ([
        ("Option", "Was sie lokal erstellt"),
        ("Komplett-Backup", "CSV mit allen Eintraegen im Originalformat fuer eine spaetere Wiederherstellung oder Kontrolle."),
        ("Tagesbackup", "CSV mit zusammengefassten Messtagen fuer Austausch oder Archivierung."),
        ("JSON-Export", "Strukturierter Export der Eintraege fuer eine eigene lokale Weiterverarbeitung."),
        ("Arztbericht", "Druckfreundlicher Bericht mit Zeitraum, Zusammenfassung, Tagesverlauf und optionalen Tagesdetails sowie Hinweisen."),
    ] if language == "de" else [
        ("Option", "What it creates locally"),
        ("Complete backup", "CSV with all entries in the original format for later restoration or review."),
        ("Daily backup", "CSV with summarized measurement days for exchange or archive use."),
        ("JSON export", "Structured export of entries for your own local processing."),
        ("Medical report", "Print-friendly report with period, summary, daily progress, and optional daily details and notes."),
    ])
    story.extend([p(data["sections"]["exports"], s["h1"]), p("Oeffne Backup in der Werkzeugleiste und waehle das passende Format. Alle Dateien werden durch den Browser oder den macOS-Speicherdialog an einem von dir gewaehlten Ort gespeichert." if language == "de" else "Open Backup in the toolbar and choose the suitable format. Every file is saved at a location you choose through the browser or macOS save dialog.", s["body"]), info_table(exports_rows, s), Spacer(1, 10), p("Beim Arztbericht waehle zuerst den Zeitraum. Tagesdetails und Hinweise sind eigene Schalter: Lass sie aus, wenn sie fuer den vorgesehenen Zweck nicht benoetigt werden." if language == "de" else "For the medical report, choose the period first. Daily details and notes are separate switches: leave them off when they are not needed for the intended purpose.", s["body"]), callout("Teile exportierte Dateien nur bewusst. Ein Export kann die von dir protokollierten Inhalte enthalten." if language == "de" else "Share exported files only deliberately. An export can contain the content you recorded.", s["callout"], TEAL), PageBreak()])

    report_rows = ([
        ("Feld oder Schalter", "Wirkung im Bericht"),
        ("Von / Bis", "Begrenzt den Bericht auf einen von dir gewaehlten Zeitraum. Pruefe beide Daten vor dem Speichern, besonders bei Monatswechseln."),
        ("Tagesdetails einschliessen", "Fuegt die einzelnen Messtage zum Bericht hinzu. Ohne diesen Schalter bleibt der Bericht kompakter und zeigt vor allem die Zusammenfassung."),
        ("Hinweise einschliessen", "Nimmt deine freien Notizen in den Bericht auf. Lass den Schalter aus, wenn sie fuer den vorgesehenen Empfaenger nicht erforderlich sind."),
        ("Bericht speichern", "Erstellt einen lokalen, druckfreundlichen Bericht. In der macOS-App wird er als PDF gespeichert; die Web-App verwendet den lokalen Speicherdialog des Browsers."),
    ] if language == "de" else [
        ("Field or control", "Effect in the report"),
        ("From / To", "Limits the report to a period you select. Check both dates before saving, especially across month boundaries."),
        ("Include daily details", "Adds individual measurement days to the report. Without this switch, the report stays compact and mainly shows the summary."),
        ("Include notes", "Includes your free notes in the report. Leave it off when they are not necessary for the intended recipient."),
        ("Save report", "Creates a local print-friendly report. The macOS app saves it as a PDF; the web app uses the browser's local save dialog."),
    ])
    story.extend([p(data["sections"]["report"], s["h1"]), p("Der Arztbericht ist eine Auswahl deiner lokalen Protokolldaten, keine medizinische Beurteilung. Er enthaelt nur den Zeitraum und die Inhalte, die du bei der Erstellung einschaltest." if language == "de" else "The medical report is a selection of your local log data, not a medical assessment. It contains only the period and content you enable while creating it.", s["body"]), info_table(report_rows, s), Spacer(1, 10), callout("Vorschau und gespeicherte Datei vor einer Weitergabe pruefen. UroBilanz versendet keinen Bericht selbststaendig." if language == "de" else "Review the preview and saved file before sharing. UroBilanz never sends a report on its own.", s["callout"], TEAL), PageBreak()])

    # Settings and privacy.
    settings_text = (
        "Das Theme-Menue oben rechts wechselt zwischen eingebauten Themes. Theme importieren liest eine eigene lokale JSON-Theme-Datei ein. Theme exportieren erzeugt eine bearbeitbare lokale Kopie des aktuellen Themes. Theme loeschen ist nur fuer importierte Themes aktiv; eingebaute Themes bleiben erhalten. Die Sprachwahl DE/EN aendert alle sichtbaren Texte einschliesslich der Erststart-Hilfe. Farben und Sprache veraendern keine Messwerte, Hinweise oder Exportinhalte."
        if language == "de" else
        "The Theme menu at top right switches between built-in themes. Import theme reads a local JSON theme file. Export theme creates an editable local copy of the current theme. Delete theme is active only for imported themes; built-in themes remain available. The DE/EN language choice changes all visible text, including first-start help. Colours and language never change measurement values, notes, or export content."
    )
    story.extend(section(data["sections"]["settings"], [settings_text, [
        "Daten merken: speichert die aktuell geladene CSV lokal fuer den naechsten Start." if language == "de" else "Remember data: stores the currently loaded CSV locally for the next start.",
        "Gespeicherte Daten loeschen: entfernt diese lokale Merkliste; die urspruengliche Datei ausserhalb der App bleibt unveraendert." if language == "de" else "Delete saved data: removes this local remembered copy; the original file outside the app remains unchanged.",
        "Ueber UroBilanz: zeigt Version, Lizenz, Projektseite und Kontakt." if language == "de" else "About UroBilanz: shows version, license, project page, and contact.",
    ]], s))
    story.append(PageBreak())

    update_rows = ([
        ("Bereich", "Funktion"),
        ("Einstellungen (macOS)", "Enthaelt die Update-Informationen und die manuelle Suche nach einer neuen Version."),
        ("Auf Updates pruefen", "Fragt nur oeffentliche Release-Informationen des Projekts ab. Messwerte, CSV-Inhalte und lokale Dateien werden dabei nicht uebermittelt."),
        ("Release oeffnen", "Oeffnet nach deinem Klick die oeffentliche Release-Seite im Browser. Ein Download oder eine Installation erfolgt nicht automatisch."),
        ("Ueber UroBilanz", "Zeigt App-Version, Lizenz, Projektseite und Kontakt. Die sichtbaren GitHub- und Discord-Symbole sind Links und oeffnen nur nach einem Klick."),
    ] if language == "de" else [
        ("Area", "Function"),
        ("Settings (macOS)", "Contains update information and the manual check for a new version."),
        ("Check for updates", "Requests only public release information for the project. Measurement values, CSV content, and local files are not sent."),
        ("Open release", "Opens the public release page in the browser after your click. A download or installation never starts automatically."),
        ("About UroBilanz", "Shows app version, license, project page, and contact. The visible GitHub and Discord icons are links and open only after a click."),
    ])
    story.extend([p(data["sections"]["updates"], s["h1"]), p("Die Web-App besitzt keine native macOS-Einstellungsseite. Die Funktionen rund um App-Version, Projektseite und Hilfe sind dort ueber die Kopfleiste und den Ueber-Dialog erreichbar." if language == "de" else "The web app has no native macOS Settings page. Its app-version, project-page, and help functions are available through the header and About dialog.", s["body"]), info_table(update_rows, s), PageBreak()])

    support_rows = ([
        ("Funktion", "Ablauf und Datenschutz"),
        ("Handbuch oeffnen", "Auf der leeren Startansicht. Oeffnet dieses oeffentliche PDF im Browser; keine lokalen Inhalte werden angehaengt."),
        ("ChatGPT, Google Gemini, Claude", "Nur auf der leeren Startansicht. Ein Klick kopiert einen festen allgemeinen Hilfetext mit dem Handbuch-Link in die Zwischenablage und oeffnet die gewaehlte Website."),
        ("Text einfuegen", "Du fuegst den Text selbst mit Cmd+V in den Dienst ein und entscheidest selbst, ob du ihn absendest. UroBilanz sendet nie automatisch etwas an einen KI-Dienst."),
        ("Fehler melden", "Oeffnet einen lokalen Entwurf mit Beschreibung, Schritten zum Nachstellen und erwartetem Ergebnis. Du kannst die Vorschau pruefen, als Text speichern oder eine E-Mail bewusst vorbereiten."),
        ("Fehlerbericht-Inhalt", "CSV-Werte, Hinweise, Gesundheitsdaten, lokale Dateipfade, Lizenz- oder Zugangsdaten werden nicht automatisch in den Entwurf aufgenommen."),
    ] if language == "de" else [
        ("Function", "Flow and privacy"),
        ("Open manual", "In the empty start view. Opens this public PDF in the browser; no local content is attached."),
        ("ChatGPT, Google Gemini, Claude", "Only in the empty start view. A click copies a fixed general help text with the manual link to the clipboard and opens the selected website."),
        ("Paste text", "You paste the text into the service yourself with Cmd+V and decide whether to send it. UroBilanz never sends anything to an AI service automatically."),
        ("Report bug", "Opens a local draft with description, reproduction steps, and expected result. You can review the preview, save it as text, or deliberately prepare an email."),
        ("Bug report content", "CSV values, notes, health data, local file paths, license data, and credentials are not automatically added to the draft."),
    ])
    story.extend([p(data["sections"]["support"], s["h1"]), p("Die KI-Hilfe ist bewusst nur vor dem ersten Laden eigener Inhalte sichtbar. Sobald Daten vorhanden sind, bleibt die normale Arbeitsansicht im Vordergrund." if language == "de" else "AI help is deliberately visible only before you load your own content for the first time. Once data exists, the normal working view remains in the foreground.", s["body"]), info_table(support_rows, s), Spacer(1, 9), callout("Gib Messwerte, Notizen oder andere persoenliche Informationen nur weiter, wenn du das bewusst willst und den Empfaenger kennst." if language == "de" else "Share measurement values, notes, or other personal information only when you deliberately choose to and know the recipient.", s["callout"], TEAL), PageBreak()])

    privacy_rows = ([
        ("Bereich", "Was UroBilanz tut - und nicht tut"),
        ("Messdaten", "Verarbeitung und Auswertung erfolgen lokal in der Web-App oder macOS-App. Es gibt keinen Cloud-Sync und kein Daten-Backend."),
        ("Dateien", "CSV-, JSON-, Bericht- und Theme-Dateien werden nur ueber einen von dir ausgeloesten Oeffnen- oder Speichern-Dialog verarbeitet."),
        ("Links", "GitHub, Discord, Lizenz, Kontakt, Handbuch und externe KI-Dienste oeffnen erst nach einem bewussten Klick."),
        ("KI-Hilfe", "Erhaelt von der App nur den festen allgemeinen Text und den oeffentlichen Handbuch-Link in deiner Zwischenablage. Keine lokalen App-Daten werden in den Text eingesetzt."),
        ("Berichte und Backups", "Bleiben lokale Dateien, bis du sie selbst ueber einen anderen Dienst, E-Mail-Anhang oder Datentraeger weitergibst."),
    ] if language == "de" else [
        ("Area", "What UroBilanz does - and does not do"),
        ("Measurement data", "Processing and evaluation happen locally in the web app or macOS app. There is no cloud sync and no data backend."),
        ("Files", "CSV, JSON, report, and theme files are processed only through an open or save dialog you trigger."),
        ("Links", "GitHub, Discord, license, contact, manual, and external AI services open only after a deliberate click."),
        ("AI help", "Receives from the app only the fixed general text and public manual link in your clipboard. No local app data is inserted into the text."),
        ("Reports and backups", "Remain local files until you yourself share them through another service, an email attachment, or storage device."),
    ])
    story.extend([p(data["sections"]["privacy"], s["h1"]), info_table(privacy_rows, s), Spacer(1, 10), callout("Bei Beschwerden, Unsicherheit oder Veraenderungen deines Gesundheitszustands hole medizinischen Rat ein. Dieses Handbuch und die App ersetzen keine fachliche Beratung." if language == "de" else "For symptoms, uncertainty, or changes in your health, seek medical advice. This manual and the app do not replace professional guidance.", s["callout"], TEAL), PageBreak()])

    troubleshooting_rows = ([
        ("Situation", "Sinnvolle Pruefung"),
        ("Keine Daten sichtbar", "Pruefe, ob eine CSV geladen wurde, ob ein Jahr-/Monat-Filter den Zeitraum begrenzt oder ob gespeicherte Daten zuvor geloescht wurden."),
        ("CSV laesst sich nicht ergaenzen", "CSV ergaenzen akzeptiert nur eine weitere Original-Urinote-CSV. Lade eine Tagesdaten-CSV stattdessen normal oder verwende sie als Archiv."),
        ("Tag ist unvollstaendig", "Pruefe, ob zwischen erstem und letztem Urin- oder Wasserwert mindestens acht Stunden liegen. Randzeiten von 00:00 bis 05:59 gehoeren zum Vortag."),
        ("Werte fehlen nach Neustart", "Aktiviere Daten merken fuer die lokale Wiederverwendung oder lade die CSV erneut. Nutze fuer dauerhafte Sicherung ein Komplett-Backup."),
        ("Falsches Theme oder falsche Sprache", "Waehle oben rechts ein eingebautes Theme oder DE/EN. Diese Aktion betrifft nur Darstellung und Texte."),
        ("Begriff: Messtag", "Ein Auswertungszeitraum von 06:00 bis 05:59 des Folgetags; er kann von einem Kalendertag abweichen."),
        ("Begriff: vollstaendig", "Ein Messtag mit mindestens acht Stunden zwischen erstem und letztem Urin- oder Wasserwert; nur diese Tage gehen in die Kennzeichnungen ein."),
    ] if language == "de" else [
        ("Situation", "Useful check"),
        ("No data visible", "Check whether a CSV was loaded, whether a year/month filter limits the period, or whether saved data was previously deleted."),
        ("CSV cannot be merged", "Merge CSV accepts only another original Urinote CSV. Load a daily-data CSV normally instead or use it as an archive."),
        ("Day is incomplete", "Check whether at least eight hours lie between the first and last urine or water value. Times from 00:00 to 05:59 belong to the previous day."),
        ("Values missing after restart", "Enable Remember data for local reuse or load the CSV again. Use a complete backup for durable safeguarding."),
        ("Wrong theme or language", "Choose a built-in theme or DE/EN at top right. This action affects only appearance and text."),
        ("Term: measurement day", "An evaluation period from 06:00 to 05:59 the next day; it may differ from a calendar day."),
        ("Term: complete", "A measurement day with at least eight hours between the first and last urine or water value; only these days are included in labels."),
    ])
    story.extend([p(data["sections"]["troubleshooting"], s["h1"]), p("Wenn die Pruefungen das Problem nicht loesen, erstelle einen Fehlerbericht. Beschreibe dabei die Schritte moeglichst allgemein und fuege keine personenbezogenen Protokollinhalte bei." if language == "de" else "If these checks do not solve the problem, create a bug report. Describe the steps as generally as possible and do not include personal log content.", s["body"]), info_table(troubleshooting_rows, s)])

    doc.build(story)
    return output


if __name__ == "__main__":
    for locale in ("de", "en"):
        print(build_manual(locale))

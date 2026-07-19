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
            "cover": "UroBilanz hilft dir, lokale Protokolldaten zu ordnen und auszuwerten. Dieses Handbuch erklaert jeden sichtbaren Bereich, die wichtigsten Schalter und einen sinnvollen ersten Ablauf.",
            "edition": "Deutsch | Stand: Juli 2026",
            "footer": "UroBilanz Handbuch",
            "toc": [
                "1. UroBilanz auf einen Blick", "2. Wo finde ich was?", "3. Erster sinnvoller Start",
                "4. Eintraege erfassen und verwalten", "5. Ansichten und Auswertungsregeln",
                "6. Bericht, Backups und Exporte", "7. Themes, Sprache und Einstellungen",
                "8. Datenschutz, KI-Hilfe und Fehlerberichte",
            ],
            "start": "Erster sinnvoller Start",
            "manual": "Handbuch oeffnen",
            "sections": {
                "overview": "1. UroBilanz auf einen Blick",
                "where": "2. Wo finde ich was?",
                "first": "3. Erster sinnvoller Start",
                "entries": "4. Eintraege erfassen und verwalten",
                "views": "5. Ansichten und Auswertungsregeln",
                "exports": "6. Bericht, Backups und Exporte",
                "settings": "7. Themes, Sprache und Einstellungen",
                "privacy": "8. Datenschutz, KI-Hilfe und Fehlerberichte",
            },
        }
    return {
        "filename": "UroBilanz-User-Manual-EN.pdf",
        "title": "UroBilanz User Manual",
        "subtitle": "A clear guide to your local urine and fluid record",
        "cover": "UroBilanz helps you organize and review local record data. This manual explains every visible area, the important controls, and a useful first workflow.",
        "edition": "English | July 2026 edition",
        "footer": "UroBilanz User Manual",
        "toc": [
            "1. UroBilanz at a glance", "2. Where to find each function", "3. First useful start",
            "4. Add and manage entries", "5. Views and evaluation rules",
            "6. Report, backups and exports", "7. Themes, language and settings",
            "8. Privacy, AI help and bug reports",
        ],
        "start": "First useful start",
        "manual": "Open manual",
        "sections": {
            "overview": "1. UroBilanz at a glance",
            "where": "2. Where to find each function",
            "first": "3. First useful start",
            "entries": "4. Add and manage entries",
            "views": "5. Views and evaluation rules",
            "exports": "6. Report, backups and exports",
            "settings": "7. Themes, language and settings",
            "privacy": "8. Privacy, AI help and bug reports",
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
    ]], s, SCREENSHOTS / "swift" / "swift-dashboard-creme-salbei.png", "SwiftUI-App mit Demo-Daten" if language == "de" else "SwiftUI app with demo data"))
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
    story.append(PageBreak())

    # Views and rules.
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
    story.extend([p(data["sections"]["views"], s["h1"]), p(view_intro, s["body"]), info_table(rules_rows, s), Spacer(1, 10), callout("Die Kennzeichnungen niedrig, normal und unvollstaendig sind organisatorische Auswertungen. Sie sind keine Diagnose und ersetzen keine medizinische Beratung." if language == "de" else "The low, normal, and incomplete labels are organizational evaluations. They are not a diagnosis and do not replace medical advice.", s["callout"], TEAL), PageBreak()])

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

    # Settings and privacy.
    settings_text = (
        "Das Theme-Menue oben rechts wechselt zwischen eingebauten Themes. Theme importieren liest eine eigene lokale JSON-Theme-Datei ein. Theme exportieren erzeugt eine bearbeitbare lokale Kopie des aktuellen Themes. Theme loeschen ist nur fuer importierte Themes aktiv; eingebaute Themes bleiben erhalten. Die Sprachwahl DE/EN aendert alle sichtbaren Texte einschliesslich der Erststart-Hilfe. In der macOS-App findest du unter Einstellungen zusaetzlich die Update-Pruefung; sie wird bewusst gestartet und prueft nur die oeffentliche Release-Information."
        if language == "de" else
        "The Theme menu at top right switches between built-in themes. Import theme reads a local JSON theme file. Export theme creates an editable local copy of the current theme. Delete theme is active only for imported themes; built-in themes remain available. The DE/EN language choice changes all visible text, including first-start help. In the macOS app, Settings also contains the update check; it is started deliberately and checks only public release information."
    )
    story.extend(section(data["sections"]["settings"], [settings_text, [
        "Daten merken: speichert die aktuell geladene CSV lokal fuer den naechsten Start." if language == "de" else "Remember data: stores the currently loaded CSV locally for the next start.",
        "Gespeicherte Daten loeschen: entfernt diese lokale Merkliste; die urspruengliche Datei ausserhalb der App bleibt unveraendert." if language == "de" else "Delete saved data: removes this local remembered copy; the original file outside the app remains unchanged.",
        "Ueber UroBilanz: zeigt Version, Lizenz, Projektseite und Kontakt." if language == "de" else "About UroBilanz: shows version, license, project page, and contact.",
    ]], s))
    story.extend([p(data["sections"]["privacy"], s["h1"]), p("UroBilanz verarbeitet Messdaten lokal. Es gibt keinen Cloud-Sync und keinen Daten-Backend-Dienst. Die sichtbaren GitHub-, Discord-, Lizenz- und Kontaktlinks oeffnen erst nach einem Klick. Fehler melden erzeugt einen pruefbaren Textentwurf; CSV-Werte, Hinweise und Gesundheitsdaten werden nicht automatisch hinzugefuegt." if language == "de" else "UroBilanz processes measurement data locally. There is no cloud sync and no data backend. Visible GitHub, Discord, license, and contact links open only after a click. Report bug creates a reviewable text draft; CSV values, notes, and health data are not added automatically.", s["body"]), p("In der leeren Startansicht kannst du das Handbuch oeffnen oder ChatGPT, Google Gemini oder Claude auswaehlen. Erst dein Klick kopiert eine feste allgemeine Frage mit diesem oeffentlichen Handbuch-Link in die Zwischenablage und oeffnet den jeweiligen Dienst. Die App uebergibt dabei keine Eintraege, Messwerte, Dateipfade oder gespeicherten Daten. Fuege die Frage nur selbst mit Cmd+V ein und sende sie nur, wenn du das moechtest." if language == "de" else "In the empty start view, you can open the manual or choose ChatGPT, Google Gemini, or Claude. Only your click copies a fixed general question with this public manual link to the clipboard and opens the selected service. The app does not pass entries, measurements, file paths, or saved data. Paste the question yourself with Cmd+V and send it only when you choose to do so.", s["body"]), callout("Bei Beschwerden, Unsicherheit oder Veraenderungen deines Gesundheitszustands hole medizinischen Rat ein. Dieses Handbuch und die App ersetzen keine fachliche Beratung." if language == "de" else "For symptoms, uncertainty, or changes in your health, seek medical advice. This manual and the app do not replace professional guidance.", s["callout"], TEAL)])

    doc.build(story)
    return output


if __name__ == "__main__":
    for locale in ("de", "en"):
        print(build_manual(locale))

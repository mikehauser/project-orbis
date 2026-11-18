# ADR 0001 – Linux-Basis

- **Status:** vorgeschlagen (von Mike mit "ja" bestätigt am 18.11.2026)
- **Kontext:** Ein eigener Kernel oder ein Windows-Nachbau ist nicht machbar und bringt für Gaming nichts, weil die Windows-Kompatibilität über Proton, DXVK und VKD3D-Proton aus dem Linux-Umfeld kommt.
- **Entscheidung:** Eigenes Image auf Bazzite-Basis (Fedora Atomic, KDE Plasma). Stand 4. November 2026: Bazzite 45 auf Fedora 45 mit KDE Plasma 6.8. Spätere Option: Wechsel auf Fedora Kinoite mit selektiv übernommenen Bazzite-Teilen.
- **Folgen:** Abhängigkeit von Upstream. Fedora erscheint etwa halbjährlich, also ist ein Rebase alle sechs Monate Pflicht. Branding und Marken von Fedora und Bazzite müssen ersetzt werden (Markenrichtlinien prüfen).

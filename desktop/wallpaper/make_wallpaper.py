#!/usr/bin/env python3
"""Project Orbis – erzeugt die Hintergrundbilder (Dunkel und Hell) als SVG.

Motiv: das Logo "Abflug" (ADR 0008) im Grossen – eine weite Umlaufbahn, aus deren Öffnung
ein Gleiter startet, dazu Sterne (nur dunkel). Ausgabe nach dark.svg und light.svg;
render.sh macht daraus PNGs. Feste Zufallszahl, damit das Ergebnis immer gleich ist.
"""
import math
import random
from pathlib import Path

W, H = 3840, 2160
OUT = Path(__file__).parent

SHIP = '<path d="M48.5 10L48.5 70L24 84Z"/><path d="M51.5 10L76 84L51.5 70Z"/>'


def arc_with_gap(cx, cy, r, gap_deg, half_gap):
    a1 = math.radians(gap_deg + half_gap)
    a2 = math.radians(gap_deg - half_gap)
    x1, y1 = cx + r * math.cos(a1), cy + r * math.sin(a1)
    x2, y2 = cx + r * math.cos(a2), cy + r * math.sin(a2)
    return f"M{x1:.1f} {y1:.1f}A{r} {r} 0 1 1 {x2:.1f} {y2:.1f}"


def build(dark: bool) -> str:
    bg = "#07090F" if dark else "#F3EFE6"
    teal, violet = "#5EEAD4", "#8B7CFF"
    ring_op = 0.55 if dark else 0.30
    ship_col = teal if dark else "#0F766E"
    cx, cy, r = 2500, 1330, 1020
    gap = -45  # oben rechts, wie im Logo
    gx = cx + r * math.cos(math.radians(gap))
    gy = cy + r * math.sin(math.radians(gap))
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
        "<defs>",
        f'<radialGradient id="gt" cx="0.80" cy="0.15" r="0.6"><stop offset="0" stop-color="{teal}" stop-opacity="{0.22 if dark else 0.20}"/><stop offset="1" stop-color="{teal}" stop-opacity="0"/></radialGradient>',
        f'<radialGradient id="gv" cx="0.10" cy="0.95" r="0.7"><stop offset="0" stop-color="{violet}" stop-opacity="{0.30 if dark else 0.16}"/><stop offset="1" stop-color="{violet}" stop-opacity="0"/></radialGradient>',
        f'<linearGradient id="ring" x1="0" y1="1" x2="1" y2="0"><stop offset="0" stop-color="{violet}"/><stop offset="1" stop-color="{teal if dark else "#0F766E"}"/></linearGradient>',
        '<filter id="glow" x="-1" y="-1" width="3" height="3"><feGaussianBlur stdDeviation="18"/></filter>',
        "</defs>",
        f'<rect width="{W}" height="{H}" fill="{bg}"/>',
        f'<rect width="{W}" height="{H}" fill="url(#gt)"/>',
        f'<rect width="{W}" height="{H}" fill="url(#gv)"/>',
    ]
    if dark:
        rnd = random.Random(45)
        for _ in range(260):
            x, y = rnd.uniform(0, W), rnd.uniform(0, H)
            rr = rnd.choice([0.8, 1.0, 1.2, 1.6, 2.2])
            op = rnd.uniform(0.15, 0.75)
            parts.append(f'<circle cx="{x:.0f}" cy="{y:.0f}" r="{rr}" fill="#E8EBF4" opacity="{op:.2f}"/>')
    # weite, schwache äussere Bahn und die Hauptbahn mit Öffnung
    parts.append(f'<circle cx="{cx}" cy="{cy}" r="{r + 380}" fill="none" stroke="url(#ring)" stroke-width="2" opacity="{ring_op * 0.3:.2f}"/>')
    parts.append(f'<path d="{arc_with_gap(cx, cy, r, gap, 7)}" fill="none" stroke="url(#ring)" stroke-width="5" stroke-linecap="round" opacity="{ring_op}"/>')
    # Gleiter in der Öffnung, mit Leuchten
    ship_tf = f"translate({gx:.1f} {gy:.1f}) rotate(45) scale(1.15) translate(-50 -47)"
    parts.append(f'<g transform="{ship_tf}" fill="{ship_col}" filter="url(#glow)" opacity="0.8">{SHIP}</g>')
    parts.append(f'<g transform="{ship_tf}" fill="{ship_col}">{SHIP}</g>')
    parts.append("</svg>")
    return "\n".join(parts)


if __name__ == "__main__":
    (OUT / "dark.svg").write_text(build(True))
    (OUT / "light.svg").write_text(build(False))
    print("dark.svg und light.svg geschrieben")

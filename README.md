# chess-drills

Browser-based chess training drills. Each drill is a single self-contained HTML
file: open it, or serve the folder. No build step, no dependencies, no network
calls beyond a Google Fonts stylesheet.

## Drills

### [Square Pressure](square-pressure/) &mdash; attacked squares

A plausible position appears and one side is named. Stamp every square that side
attacks, once per attacker, and check yourself against the real counts. Positions
are generated from named pawn skeletons (Najdorf, Carlsbad, Mar del Plata,
hedgehog, four-against-three and more) with pieces sampled from the squares they
usually occupy in that structure, so the patterns are ones you will actually meet.

[Full description](square-pressure/README.md)

## Running

Open the drill's `index.html` in a browser, or serve the repository root:

```
python3 -m http.server 8000   # then visit localhost:8000/square-pressure/
```

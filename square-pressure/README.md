# Square Pressure

A board-vision drill. A plausible chess position appears, one side is named, and
you stamp every square that side attacks — once per attacker, so a square covered
twice takes two taps. Marks are a translucent red wash; checking shows the real
count against yours.

Open `index.html` in any browser. No build, no dependencies, no network calls
beyond the Google Fonts stylesheet.

## What counts as an attack

- Any square the piece could capture on, **including squares holding its own
  pieces** — a defence is an attack.
- Pawns attack diagonally only; a push is not an attack.
- Sliding pieces stop at the first piece in the way. No x-rays through a battery.
- Pins are ignored: a pinned piece still attacks.
- The king attacks all eight neighbours. En passant and castling are ignored.

## Positions

Positions are not random scatterings. Each is built from a named pawn skeleton —
Najdorf, Dragon, Carlsbad, isolated queen's pawn, Mar del Plata, French advance,
closed Ruy Lopez, Caro-Kann classical, Semi-Slav, hedgehog, Benoni, Grünfeld
exchange, Stonewall, Botvinnik English, plus six endgame skeletons — then castling
is chosen with weights that fit the structure and the pieces are sampled from the
squares they habitually occupy in it. Positions where both kings are in check, or
where the kings are adjacent, are rejected.

## Settings

- **What to mark** — the threats against the side to move, that side's own
  pressure, or mixed.
- **Material** — endgame, middlegame, or a full board.
- **Area** — one 4×4 quadrant (quick reps) or the whole board.

## Controls

Tap a square once per attacker. Shift-click, right-click or press-and-hold takes
one back. Keyboard: arrows to move, space to add, backspace to remove, and
`C` check, `N` new position, `R` reveal, `F` flip. Session stats live in
localStorage.

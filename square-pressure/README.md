# Square Pressure

A board-vision drill. A plausible chess position appears, one side is named, and
you stamp every square that side attacks — once per attacker, so a square covered
twice takes two taps. Marks are a translucent red wash; checking shows the real
count against yours.

Open `index.html` in any browser. No build, no dependencies, no network calls
beyond the Google Fonts stylesheet.

## Install on Windows

1. Download the repository (green **Code** button, then **Download ZIP**) and unzip it,
   or `git clone` it.
2. Open `square-pressure\windows` and double-click **`install.cmd`**.

That installs it for your Windows user only, so no admin rights are needed. It copies
the drill to `%LOCALAPPDATA%\Programs\Square Pressure` and adds Start menu and desktop
shortcuts with the Square Pressure icon. The shortcuts open it in its own window
(Microsoft Edge in app mode, or Chrome if Edge is missing), with no tabs or address bar.
It also registers it under **Settings → Apps → Installed apps**, so you can uninstall
it from there like any other program. Run the installer again to upgrade. Options:
`install.cmd -NoDesktop` skips the desktop shortcut, and `-NoLaunch` skips opening it
when it finishes.

Your session stats are kept in the browser's local storage, so uninstalling does not
erase them.

## Install from the web

When the folder is served over HTTPS (for example from GitHub Pages), the page is an
installable web app. It has a manifest, icons, and an offline cache. In Edge or Chrome,
use **Install app** in the address bar (on a phone, **Add to Home Screen**). After the
first visit it runs offline.

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
squares they habitually occupy in it.

Every position is then filtered so it could have come from a real game:

- The side that just moved has left nothing hanging. No piece is attacked by
  something cheaper, attacked and undefended, or attacked more times than defended.
- The side to move faces at most one such threat, the move just played.
- Pawns come off in trades, the same number from each side (occasionally one
  extra), and never from in front of a castled king.
- After castling, a rook is never left in the corner beyond its king.
- Material is level. Checks are allowed but rare, and the kings never touch.

## Settings

- **What to mark** — the threats against the side to move, that side's own
  pressure, or mixed.
- **Material** — endgame, middlegame, or a full board.
- **Area** — the whole board (default), or one 4×4 quadrant for quick reps.

## Controls

**Check** scores your marks. **Reveal** shows the answer without scoring it: if you
had marked anything, each square is judged the same way Check does it. Green means
right. Blue shows the real count with your mark struck through. Tap a square
afterwards to list its attackers.

Tap a square once per attacker. Shift-click, right-click or press-and-hold takes
one back. Keyboard: arrows to move, space to add, backspace to remove, and
`C` check, `N` new position, `R` reveal, `F` flip. Session stats live in
localStorage.

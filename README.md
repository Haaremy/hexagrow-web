# hexagrow-web

Standalone-Static-Deploy von **Hexagrow ver. 1.0** (Unity-WebGL) für die Domain
[hexagrow.haaremy.de](https://hexagrow.haaremy.de).

Studentenprojekt aus dem Modul *Spieleentwicklung* an der Hochschule Anhalt
(April–September 2023). Credits: Jamila Gränzer (Musik), Ashly Fonseka (Code),
Jeremy (Code, Design & Graphik).

## Inhalt

| Pfad | Bedeutung |
|---|---|
| `index.html` | Einstieg, deutscher Text |
| `style.css` | Layout (pink/light + dark) |
| `hexagrow.js` | Unity-Loader-Glue, ohne React-Abhängigkeit |
| `unity/` | Unity-WebGL-Build (~120 MB) |
| `deploy.sh` | rsync auf LXC 124 (`/var/www/hexagrow.haaremy.de/`) + Apache reload |

## Hosting

Reine Static-Site, ausgeliefert direkt aus Apache auf **LXC 124** (Reverse Proxy).
Wildcard `*.haaremy.de` → `37.120.114.157` → DNAT auf LXC 124. Spezifischer
VHost `hexagrow.haaremy.de.conf` hat Vorrang vor dem Wildcard-Catch.

MIME-Types für `.wasm` und `.data` müssen korrekt gesetzt sein, sonst
verweigert der Browser das Streaming-Compile. Siehe Apache-VHost.

## Deploy

```bash
./deploy.sh   # rsync + apache2ctl graceful auf LXC 124 (vom Proxmox-Host aus)
```

## Quelle

Extrahiert aus dem ehemaligen Monorepo `Haaremy/haaremy.de` (`app/de/Hexagrow/page.tsx`,
`public/unity/`). Das Original benutzt Next.js + `react-unity-webgl`; für den
eigenständigen Deploy wurde die Page als reines HTML/JS neu geschrieben.

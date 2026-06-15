# Generates ghost-light-grove.tmx — blockout of the Grove from map draft 4
# Tile gids (grass_biome tileset, firstgid=1, gid = tile id + 1):
#   2   plain grass        62  water           71  forest (trees)
#   65  deep-dark floor    31  tan path        19  sand
#   122 cliff edge         109/110/111 stone bridge
#   188/189 crop rows      241/242/243 small buildings (decor)
#   217/218/219 graves (decor)

$W = 80; $H = 60
$ground = New-Object 'int[][]' $H
$decor  = New-Object 'int[][]' $H
for ($y=0; $y -lt $H; $y++) { $ground[$y] = New-Object 'int[]' $W; $decor[$y] = New-Object 'int[]' $W
  for ($x=0; $x -lt $W; $x++) { $ground[$y][$x] = 2 } }

function Fill($arr,$x0,$y0,$x1,$y1,$gid) {
  for ($y=$y0; $y -le $y1; $y++) { for ($x=$x0; $x -le $x1; $x++) {
    if ($x -ge 0 -and $x -lt 80 -and $y -ge 0 -and $y -lt 60) { $arr[$y][$x] = $gid } } }
}

# --- north treeline (map edge), with Deep Woods combat entrance gap at top-left
Fill $ground 0 0 79 2 71
Fill $ground 4 0 7 3 65          # the dark gap into the Deep Woods

# --- the western Woods (safe), darker core
Fill $ground 1 5 20 46 71
Fill $ground 1 8 9 42 65
Fill $ground 18 26 20 29 2       # woods entrance clearing
Fill $ground 8 20 11 23 2        # Hazel's clearing
Fill $ground 15 23 17 25 2       # Briar's clearing

# --- plateau farm + cliff edge + stairs
Fill $ground 30 8 36 12 188
for ($yy=8; $yy -le 12; $yy+=2) { Fill $ground 30 $yy 36 $yy 189 }
Fill $ground 28 17 52 17 122     # cliff edge line
Fill $ground 39 18 40 19 31      # stairs

# --- graveyard at the stairs' base
Fill $ground 34 20 47 23 2
for ($gx=35; $gx -le 45; $gx+=2) { $decor[21][$gx] = 218; $decor[22][$gx+1] = 217 }
$decor[21][47] = 241             # Cliff's hut

# --- town square + canal + bridge
Fill $ground 34 30 52 40 31      # town square (tan)
Fill $ground 43 26 45 47 62      # canal
Fill $decor  42 34 42 35 109; Fill $decor 43 34 45 35 110; Fill $decor 46 34 46 35 111  # bridge

# --- river in from the NE, hugging the cliff's right side
$pts = @(@(76,3),@(74,5),@(71,7),@(68,9),@(65,11),@(62,13),@(59,15),@(57,17),@(55,19),@(54,21),@(52,23),@(50,24),@(48,25),@(46,26),@(44,26))
foreach ($p in $pts) { Fill $ground $p[0] $p[1] ($p[0]+1) ($p[1]+1) 62 }

# --- canal south to the sea, beach, sea
Fill $ground 43 48 45 51 62
Fill $ground 0 50 79 51 19       # beach sand
Fill $ground 0 52 79 59 62       # the sea

# --- paths
Fill $ground 39 24 40 29 31      # graveyard -> town
Fill $ground 28 34 33 35 31      # square -> sanctuary
Fill $ground 21 29 27 30 31      # sanctuary -> woods entrance
Fill $ground 53 34 59 35 31      # square -> lab
Fill $ground 53 40 59 41 31      # square -> cornfield

# --- sanctuary paddock area
Fill $ground 22 28 27 33 2

# --- cornfield (Jack)
Fill $ground 60 41 70 45 188
for ($yy=41; $yy -le 45; $yy+=2) { Fill $ground 60 $yy 70 $yy 189 }

# --- building markers (decor layer)
$decor[28][36] = 241   # Benny's bar
$decor[28][50] = 242   # museum
$decor[42][36] = 241   # general store
$decor[42][50] = 242   # library
$decor[21][9]  = 242   # Hazel's cottage
$decor[24][16] = 241   # Briar's shack
$decor[30][24] = 242   # sanctuary house
$decor[31][61] = 242   # Victor's lab
$decor[49][66] = 242   # lighthouse

function LayerCsv($arr) {
  $rows = @()
  for ($y=0; $y -lt 60; $y++) { $rows += ($arr[$y] -join ',') }
  return ($rows -join ",`n")
}

$objects = @"
  <object id="1" name="THE MANOR" x="576" y="64" width="160" height="96"/>
  <object id="2" name="farm fields" x="480" y="128" width="112" height="80"/>
  <object id="3" name="cliff stair" x="624" y="288" width="32" height="32"/>
  <object id="4" name="graveyard" x="544" y="320" width="192" height="64"/>
  <object id="5" name="Cliff's hut" x="752" y="320" width="32" height="32"/>
  <object id="6" name="Benny's bar + family home" x="560" y="432" width="48" height="48"/>
  <object id="7" name="museum - Alastair &amp; Skitter" x="784" y="432" width="48" height="48"/>
  <object id="8" name="general store (owner TBD)" x="560" y="656" width="48" height="48"/>
  <object id="9" name="library - Alice" x="784" y="656" width="48" height="48"/>
  <object id="10" name="cobblestone bridge" x="672" y="544" width="80" height="32"/>
  <object id="11" name="sewer entrance - Marshal" x="688" y="576" width="48" height="16"/>
  <object id="12" name="town square" x="544" y="480" width="304" height="176"/>
  <object id="13" name="monster sanctuary - Myra &amp; Alice" x="352" y="448" width="96" height="96"/>
  <object id="14" name="Briar's shack" x="240" y="368" width="48" height="48"/>
  <object id="15" name="Hazel's cottage" x="128" y="320" width="64" height="64"/>
  <object id="16" name="DEEP WOODS entrance (combat)" x="64" y="0" width="64" height="64"/>
  <object id="17" name="Victor's lab" x="960" y="480" width="64" height="64"/>
  <object id="18" name="cornfield - Jack" x="960" y="656" width="176" height="80"/>
  <object id="19" name="lighthouse (keeper TBD)" x="1040" y="768" width="48" height="64"/>
  <object id="20" name="the river - Marshal's road in" x="1184" y="48" width="64" height="32"/>
  <object id="21" name="woods entrance" x="288" y="416" width="48" height="64"/>
"@

# empty layer (all zeros) for Paths / Front / AlwaysFront
$empty = New-Object 'int[][]' $H
for ($y=0; $y -lt $H; $y++) { $empty[$y] = New-Object 'int[]' $W }

$tmx = @"
<?xml version="1.0" encoding="UTF-8"?>
<map version="1.10" tiledversion="1.11.2" orientation="orthogonal" renderorder="right-down" width="$W" height="$H" tilewidth="16" tileheight="16" infinite="0" nextlayerid="8" nextobjectid="30">
 <tileset firstgid="1" source="tilesets/TilesetGrass/grass_biome.tsx"/>
 <layer id="1" name="Back" width="$W" height="$H">
  <data encoding="csv">
$(LayerCsv $ground)
</data>
 </layer>
 <layer id="2" name="Buildings" width="$W" height="$H">
  <data encoding="csv">
$(LayerCsv $decor)
</data>
 </layer>
 <layer id="4" name="Paths" width="$W" height="$H" visible="0">
  <data encoding="csv">
$(LayerCsv $empty)
</data>
 </layer>
 <layer id="5" name="Front" width="$W" height="$H">
  <data encoding="csv">
$(LayerCsv $empty)
</data>
 </layer>
 <layer id="6" name="AlwaysFront" width="$W" height="$H">
  <data encoding="csv">
$(LayerCsv $empty)
</data>
 </layer>
 <objectgroup id="3" name="Locations">
$objects
 </objectgroup>
</map>
"@

Set-Content -Path "C:\Users\danie\GhostLightGrove\tiled\ghost-light-grove.tmx" -Value $tmx -Encoding utf8
"written: ghost-light-grove.tmx"

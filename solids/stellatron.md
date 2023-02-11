The Fifty Nine Stellations of the Icosahedron
=============================================

Each of the stellations has a selectable collection of pieces.  For those with
multiple pieces, these can be glued together.  The division into pieces has been
choosen to make the assembly relatively painless, and to make join lines
unobtrusive.

The raw object is defined as being a stellation of a icosahedron with radius 1,
while the printable pieces are scaled to a target size.

Not all of these are (sensibly) printable.  E.g., some are disjoint parts, or
have multiple parts joined only by corners.

**NOTE**: It is recommended **not** to scale STL files of objects printed in
multiple pieces.  Run openscad on the .scad file instead, changing parameters to
suit.  The reason for this is that the 'joiner' holes for aligning the pieces
when they are glued are sized to a specific size.  See below for more details.

**NODE**: Keep your filament dry!  Many of these pieces have layers with
multiple spikes not connected within that layer.  This is a recipe for stringing
and artifacts!  Even with PLA I see a noticable reduction in stringing if the
filament is dried before printing.  Consider increasing retraction from Cura
defaults.

Variables
---------

### object ###

Select which of the icosahedral stellations to print, using the Crennell
numbering.

This only works for objects I have worked out how to print.  For others, you can
replace the call to `main` with the `cNN` module directly.

### piece ###

Select which piece of the object to print.

`piece=0` is always the raw object.

`piece=1`, `piece=2` etc., are the printable pieces.  Typically there are two
pieces, although some can be printed as a single piece.  `piece=1` is always the
main piece of the object, and other pieces are typically spike or star shaped
objects.

`pidce=10` may be a stand for the object.  Not all objects have stands defined.
The stands are designed so they do not need to be glued to the object—the object
should balance just fine on the stand.  A few have extra stands defined on 11.

If there is no printable part defined, then you can always just use piece=0 and
manually scale and rotate.  In that case you may need lots of support
structures!

### radius ###

Radius in millimeters to the outer extremity of the object.  This is applied to
all pieces, except for the raw object.

Pieces should print fine with radius between 50 and 100.  Do check for defects
like joiners poking through an external surface.

### extra_z_remove ###

Millimeters to remove from the mating face of a piece.  Setting this to 1 or 2
times the layer height (e.g., 0.2) may be useful for pieces that have bare edges
on the printer platform (see e.g., the Great Icosahedron (c7) main piece).

Joiners
-------

Where an object has multiple pieces, there are guiding indentations in the
mating surface.  These can have a smaller 'joiner' inserted as a mechanical
guide.

The joiner is just a few short segments of 1.75mm filament.  There are two types
of these:

'Post' joiners are placed vertically in the surface.  Each part has 2.3mm
diameter holes going 10mm deep.  Cut a piece of filament just short of 20mm, and
insert into a hole.  You may need to poke the joiner into the hole a few times
to loosen it up.

'Spoke' joiners are place horizontally on the surface.  The indentation goes
from the center to near the boundary of the surface.  You don't need to fill the
entire length of the indentation—just 10mm or so near the extremity is fine.

Where there are five joiner indentations, you don't need to use all five.  Three
is quite adequate, and is easier to assembly.

Support
-------

Many do not need supports—and in some cases that they print without support is
at first sight surprising.

Your (or at least my) eyes are drawn to the angles of edges, while it seems that
it is the angle of the faces that matters.  For spikey shapes in particular, a
very shallow edge angle overhang can be made between two faces with a much tamer
overhang.

Where supports are needed, it generally is just needed for edges

Slicing
-------

Always scroll through the sliced layers sanity checking what you are about to
print.  If you are using lightning infill, or no infill, then make sure the
infil looks adequate.

Pieces with horizontal surfaces benefit greatly from Cura ironing.

Lightning infill generally works well, with 10% to 20% infill.  Many pieces
print fine with no infill (0%).

1 – Icosahedron
---------------------

Just a plain icosahedron.  Prints as a single piece.

6 – Second Stellation
---------------------

Prints as two pieces.  Somewhat like object 23, except the dodecahedron is
reduced to a second set of (small) spikes.  I prefer object 28.

Both parts need infil.  Has a stand.

7 – Great Icosahedron
---------------------------

Prints as two pieces with post joiners.  The main piece needs infill but the
spike does not.

Print the main piece on a raft and use `extra_z_remove` to make sure the bottom
ring of spikes touches the raft.

The overhangs look really scary but it printed fine for me with no support.

I set `radius=85`.

8 – The Mighty Final Stellation
-------------------------------

Two pieces.  Provision for both spike and post joiners.  Print as large as
possible.

13 – Dodecahedral Cage
----------------------

Some of the edges need support.  Use Cura tree support.  Set the support angle
high enough that only edges, not faces, get supported.

I set Cura horizontal expansion to 0.1mm and hole horizontal expansion to -0.2mm
to remove some internal artifacts.

Use the same radius as 26 for matching objects.  Piece 11 gives a stand which
will height match 23 at corresponding size.

23 – Sixth stellation – Excavated Dodecahedron plus Spikes
----------------------------------------------------------

Prints as two pieces.  For a matching pair, print with the dodecahedral part the
same size as 26 (needs radius ratio r7/r6).

26 – Excavated Dodecahedron
---------------------------

Prints as a single piece.  As it rests on edges, slice with a Cura raft.  I set
`radius=60`.

Piece 10 is a low-profile stand, while piece 11 gives a stand which will height
match 23 at corresponding size.

28 – Twelve big spikes, twenty small
------------------------------------

This is a compound of the triambic icosahedron (the twelve big spikes) and the
seventh stellation (the twenty small spikes).

Both pieces need infill.  I printed with `radius=90` to match my Great
Icosohedron.

Stand `piece=10` places the object on a tripod stand, while `11` exposes the
rectangular aspect.

37 – Chiral Dodecahedral Cage
----------------------

Chiral but otherwise very similar to 13.  Comments are repeated verbatim…

Some of the edges need support.  Use Cura tree support.  Set the support angle
high enough that only edges, not faces, get supported.

I set Cura horizontal expansion to 0.1mm and hole horizontal expansion to -0.2mm
to remove some internal artifacts.

Use the same radius as 26 for matching objects.  Stand 10 is low profile while
stand 11 height matches 23 with corresponding size.

46 – Filled Fiftenth Stellation
-------------------------------

A printable version of object 45.  Object 45 is the fiftenth stellation and is
hollow with pieces connected by corners, making it fairly unprintable.  Here, we
fill in enough to make it printable.

Print six copies of the piece, they then fit together in a cubical arrangement.

Needs infill.  Has a stand.

47 – Five Tetrahedra
--------------------

Prints as two pieces with spoke joiners.  I set `radius=65`.  The main piece
needs infill, the second piece does not.

Check the positioning of the joiners through the first few layers, and adjust if
too close to the edges.

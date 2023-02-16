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
when they are glued are a specific size, and should not be scaled.  See below
for more details.

**NODE**: Keep your filament dry!  Many of these pieces have layers with
multiple spikes not connected within that layer.  This is a recipe for stringing
and artifacts!  Even with PLA I see a noticable reduction in stringing if the
filament is dried before printing.  Consider increasing retraction from Cura
defaults.

Variables
---------

### crennell ###

Select which of the icosahedral stellations to print, using the Crennell
numbering.

This only works for objects I have worked out how to print.  For others, you can
replace the call to `main` with the `cNN` module directly.

### piece ###

Select which piece of the object to print.

`piece=0` is always the raw object, which will not be convenient for printing.
If I haven't worked out a printing and assembly procedure for a particular
stellation, then this is the only thing you get.

`piece=1`, `piece=2` etc., are the printable pieces.  Typically there are two
pieces, although some can be printed as a single piece.  `piece=1` is always the
main piece of the object, and other pieces are typically spike or star shaped
objects.

`piece=10` may be a stand for the object.  Not all objects have stands defined.
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

Support
-------

Most do not need supports—and in some cases that they print without support is
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

Assembly
========

Most objects need to be printed in multiple pieces and then glued.  The cutting
into multiple pieces has been choosen both for printability, and also to keep
the glue lines unobtrusive.

I generally find it is easiest to place the joiner segments and glue on the
smaller of two pieces, and then fit the larger piece on top of the smaller.
This may sound counter-intuitive, but spreading glue on the smaller surface
avoids getting glue onto non-mating areas.

Where you are glueing, always practice mating the peices without glue first, so
that you understand how they will fit together, and two ensure that there are no
obstructions in holes etc.

If the mating surfaces were printed face down on the print bed, then they should
already be adequately smooth.  If not, then lightly sanding the mating surfaces
may ensure better contact.

Joiners
-------

Where an object has multiple pieces, there are guide holes in the mating
surfaces.  These can have a 'joiner' inserted as a mechanical guide.

The joiners are short segments of 1.75mm filament.  Each part has 2.3mm diameter
holes in the mating faces.  Cut a short piece of filament to insert into each
hole. You may need to poke filament into the holes a few times to loosen them
up.

Cut the filament with side cutters.  Use the angled, not flat, blade side to
create the end of the joiner&mdash;this leaves a slight point that makes finding
the mating hole easier when you push the pieces together.

Where there are many joiner holes, you don't need to use them all.  Fewer is
easier to assemble.  The joiners are for alignment, not structural support.
Three or even just two is quite adequate.  Choose the joiner holes to use so as
to spread them out as much as possible.

Where there are multiple mating surfaces at angles to each other, the edges
provide some additional alignment.  In that case, use just two
joiners&mdash;most likely these will be at different angles, so keep them as
short as possible.

Dodecahedral Assembly
---------------------

Not all objects can be conveniently split into printable parts by a single split
place through the object.  A few require more complex assembly.

This is accomplished by splitting into 12 dodecahedral pieces, or small clusters
of those.  (E.g., 6 pieces each built from two adjacent dodecahedral pieces.
The pieces are identical, so print multiple times.  Use different colours if you
wish!

The best assembly procedure is hierarchical: don't assembly by adding one piece
at a time incrementally.  Instead, build clusters of 2 pieces, then pair those
into 3 clusters of 4 pieces, and then glue into 8 + 4 pieces before the final
assembly.  This procesdure avoids tolerances building up to the point where the
last piece(s) don't fit in properly.

As you assemble clusters together, the joiner segments may be at an angle to the
direction at which the pieces fit onto each other!  If you keep the joiners
short, and only use two spread as far as possible from each other, then this
should not be a problem.

Printing in multiple pieces, you can print in multiple colours if wanted.  In
that case, plan the arrangement of colours!

* E.g., if you want opposing pieces to have the same colour, then the object
  will have inversion symmetry through the center.  In that case, as you
  assemble, create clusters in pairs that are mirror images of each other.

* E.g., if you want four pieces of each of three colours, with a tetrahedral
  arrangement, then likely you want each cluster of three to have the same
  handedness.

The Stellations
===============

1 – Icosahedron
---------------------

Just a plain icosahedron.  Prints as a single piece.

6 – Second Stellation
---------------------

Prints as two pieces.  Somewhat like Crennell 23, except the dodecahedron is
reduced to a second set of (small) spikes.  Also see Crennell 28 (which I
prefer), which again is very similar except that the small spikes are slightly
different.

Both parts need infill.  Has a stand.

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

Use the same radius as Crennell 26 for matching objects.  Piece 11 gives a stand
which will height match Crennell 23 at corresponding size.

23 – Sixth stellation – Excavated Dodecahedron plus Spikes
----------------------------------------------------------

Prints as two pieces.  For a matching pair, print with the dodecahedral part the
same size as Crennell 26 (needs radius ratio r7/r6).

26 – Excavated Dodecahedron
---------------------------

Prints as a single piece.  As it rests on edges, slice with a Cura raft.  I set
`radius=60`.

Piece 10 is a low-profile stand, while piece 11 gives a stand which will height
match 23 at corresponding size.

27 - Twelve Pentagonal Turrets
------------------------------

Pieces 1 and 2 join together.  Alternatively, print twelve of piece three.

It doesn't really need a stand, but we give you two: `piece=10` is a tripod
stand while `piece=11` is a pentapod stand.

28 – Twelve big spikes, twenty small
------------------------------------

This is a compound of the great triambic icosahedron (the twelve big spikes) and
the seventh stellation (the twenty small spikes).

Both pieces need infill.  I printed with `radius=90` to match my Great
Icosahedron.

Stand `piece=10` places the object on a tripod stand, while `11` exposes the
rectangular aspect.

29 - Eighth Stellation
----------------------

Twelve pentagram spikes.  Similar to the great icosahedren, I'd print the great
not the eighth!

30 - Great (or medial) Triambic
-------------------------------

Twelve sharp pentagonal spikes.  Has a stand.

37 – Chiral Dodecahedral Cage
----------------------

Chiral but otherwise very similar to Crennell 13.  Comments are repeated
verbatim…

Some of the edges need support.  Use Cura tree support.  Set the support angle
high enough that only edges, not faces, get supported.

I set Cura horizontal expansion to 0.1mm and hole horizontal expansion to -0.2mm
to remove some internal artifacts.

Use the same radius as Crennell 26 for matching objects.  Stand 10 is low
profile while stand 11 height matches Crennell 23 with corresponding size.

46 – Filled Fiftenth Stellation
-------------------------------

A printable version of Crennell 45.  Crennell 45 is the fiftenth stellation and
is hollow with pieces connected by corners, making it fairly unprintable.  Here,
we fill in enough to make it printable.

It requires dodecahedral assembly.  Print twelve copies of the piece and follow
the instructions above re dodecahedral assembly.

Needs infill.  Slice with a raft or brim, as the contact area to the print bed
is a bit small.  Has a stand.

47 – Five Tetrahedra
--------------------

Prints as two pieces.  I set `radius=65`.  The main piece needs infill, the
second piece does not.


include <numbers.scad>

function sum(v, n=0) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

// NUMERIC CANONICALIZATION - exact Q(ϕ) representation.
//
// The object vertexes all have co-ordinates in the form `q·ϕ + r` where `q` and
// `r` are rational, and `ϕ` is the golden ratio.
//
// We use an 'exact' representation for the points in question.  We keep a table
// of the expected values, and round calculated co-ordinates to the table.
//
// This keeps openscad happy: the shared vertexes, edges and faces are exactly
// shared.  This turns out to be easier than the usual procedure of slightly
// over-sizing an object to compensate for in-exact floating point arithmetic.

// A table of the fractional parts of point co-ordinates, along with
// decomposition in Q(ϕ).
value_table = [
    [-0.4 * gold + 0.2, -0.4, 0.2], // -0.44721359549995804
    [1.0 * gold + -2.0, 1.0, -2.0], // -0.3819660112501051
    [-1.2 * gold + 1.6, -1.2, 1.6], // -0.3416407864998736
    [-7.0 * gold + 11.0, -7.0, 11.0], // -0.3262379212492643
    [-0.5 * gold + 0.5, -0.5, 0.5], // -0.30901699437494745
    [6.0 * gold + -10.0, 6.0, -10.0], // -0.2917960675006306
    [0.2 * gold + -0.6, 0.2, -0.6], // -0.27639320225002095
    [-2.0 * gold + 3.0, -2.0, 3.0], // -0.2360679774997898
    [0.5 * gold + -1.0, 0.5, -1.0], // -0.19098300562505255
    [-0.6 * gold + 0.8, -0.6, 0.8], // -0.1708203932499368
    [3.0 * gold + -5.0, 3.0, -5.0], // -0.1458980337503153
    [-1.0 * gold + 1.5, -1.0, 1.5], // -0.1180339887498949
    [0.8 * gold + -1.4, 0.8, -1.4], // -0.10557280900008381
    [-5.0 * gold + 8.0, -5.0, 8.0], // -0.09016994374947451
    [-1.4 * gold + 2.2, -1.4, 2.2], // -0.06524758424985233
    [-0.0 * gold + -0.0, -0.0, -0.0], // 0.0
    [1.4 * gold + -2.2, 1.4, -2.2], // 0.06524758424985233
    [5.0 * gold + -8.0, 5.0, -8.0], // 0.09016994374947451
    [-0.8 * gold + 1.4, -0.8, 1.4], // 0.10557280900008381
    [1.0 * gold + -1.5, 1.0, -1.5], // 0.1180339887498949
    [-3.0 * gold + 5.0, -3.0, 5.0], // 0.1458980337503153
    [0.6 * gold + -0.8, 0.6, -0.8], // 0.1708203932499368
    [-0.5 * gold + 1.0, -0.5, 1.0], // 0.19098300562505255
    [2.0 * gold + -3.0, 2.0, -3.0], // 0.2360679774997898
    [-0.2 * gold + 0.6, -0.2, 0.6], // 0.27639320225002095
    [-6.0 * gold + 10.0, -6.0, 10.0], // 0.2917960675006306
    [0.5 * gold + -0.5, 0.5, -0.5], // 0.30901699437494745
    [7.0 * gold + -11.0, 7.0, -11.0], // 0.3262379212492643
    [1.2 * gold + -1.6, 1.2, -1.6], // 0.3416407864998736
    [-1.0 * gold + 2.0, -1.0, 2.0], // 0.3819660112501051
    [0.4 * gold + -0.2, 0.4, -0.2], // 0.44721359549995804
    ];

for (i = [1 : len(value_table) - 1])
    assert(value_table[i-1][0] < value_table[i][0]);

for (v = value_table)
    assert(abs(v[0] - gold * v[1] - v[2]) < 1e-7);

// Binary search helper on the `value_table`.
function canon_find(v, m, p) =
    let (n = floor((m + p) / 2))
    p - m <= 1 ? m : (
        v <= value_table[n][0] ? canon_find(v, m, n) : canon_find(v, n, p));

// Look up a value in the `value_table`.  If we don't get a good match, the
// barf.
function canon(v) =
    let (rv = round(v),
         fv = v - rv,
         m = canon_find(fv, 0, len(value_table) - 1),
         mid = (value_table[m][0] + value_table[m+1][0]) / 2,
         mm = fv < mid ? m : m + 1,
         pp = value_table[mm][1],
         ii = value_table[mm][2],
         recalc = pp * gold + (rv + ii))
    assert(abs(recalc - v) < 1e-7)
    recalc;

function canonv(v) = [for (x = v) canon(x)];
function canonvv(vv) = [for (v = vv) canonv(v)];

module describe(v) {
    rv = round(v);
    fv = v - rv;
    m = canon_find(fv, 0, len(value_table) - 1);
    mid = (value_table[m][0] + value_table[m+1][0]) / 2;
    mm = fv < mid ? m : m + 1;
    pp = value_table[mm][1];
    ii = value_table[mm][2];
    recalc = pp * gold + (rv + ii);
    echo(v, recalc, pp, rv + ii);
}


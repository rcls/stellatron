
// Compare two items.  If tol==undef then this is just the < operator.
// Otherwise, we compare vectors lexicographically, but taking two components
// as equal if their absolute difference is less than tol.
function vless(u, v, tol, n=0) = is_undef(tol) ? u < v
    : n >= len(u) ? false
    : abs(u[n] - v[n]) < tol ? vless(u, v, tol, n+1)
    : u[n] < v[n];

// Drop the first n items from a linked list.  (A linked list is represented
// as undef for the empty list, and [tail list, head value] for a non-empty
// list.
function drop(ll, n) = n == 0 ? ll : drop(ll[0], n-1);

// Flatten the first n items in a linked list.
function flatten_n(ll, n) = n==0 ? []
    : n == 1 ? [ll[1]]
    : [each flatten_n(ll, floor(n/2)),
       each flatten_n(drop(ll, floor(n/2)), ceil(n/2))];

// Count the items in a linked list.
function link_len(ll, n=0) = is_undef(ll) ? n : link_len(ll[0], n+1);

// Flatten a linked list.
function flatten(ll) = flatten_n(ll, link_len(ll));

// Make a more-or-less balanced binary tree out of a vector.
// Parent nodes are pairs [a,b] and carry no value.
// Leaves are singleton vectors [v] with a value.
// The empty tree [] is only used stand-alone.
function tree(v, m, n) = m == n ? [] : m+1 == n ? [v[m]]
    : let (p = floor((m + n) / 2)) [tree(v, m, p), tree(v, p, n)];

// Merge two ascending sorted linked lists producing a descending sorted linked
// list.
function merge_l_a_to_d(s, t, tol, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(t) && (is_undef(s) || vless(t[1], s[1], tol))
    ? merge_l_a_to_d(s, t[0], tol, [tail, t[1]])
    : merge_l_a_to_d(s[0], t, tol, [tail, s[1]]);

// Merge two descending sorted linked lists producing an ascending sorted linked
// list.
function merge_l_d_to_a(s, t, tol, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(s) && (is_undef(t) || vless(t[1], s[1], tol))
    ? merge_l_d_to_a(s[0], t, tol, [tail, s[1]])
    : merge_l_d_to_a(s, t[0], tol, [tail, t[1]]);

// Sort a tree to an ascending linked list.
function merge_t_a(t, tol) = len(t) == 1 ? [undef, t[0]]
    : merge_l_d_to_a(merge_t_d(t[0], tol), merge_t_d(t[1], tol), tol, undef);

// Sort a tree to an descending linked list.
function merge_t_d(t, tol) = len(t) == 1 ? [undef, t[0]]
    : merge_l_a_to_d(merge_t_a(t[0], tol), merge_t_a(t[1], tol), tol, undef);

// Sort using vless to an ascending vector.
function sort(v, tol=undef) = flatten(merge_t_a(tree(v, 0, len(v)), tol));

l = [5, 3, 6, 8, 7, 0, 9, 1, 2];
echo(sort([5, 3, 6, 8, 7, 0, 9, 1, 2]));
echo(sort([for (i = [0:8]) [0, i * 1e-9]], 0));

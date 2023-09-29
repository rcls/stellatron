
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
function merge_l_a_to_d(s, t, less, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(t) && (is_undef(s) || less(t[1], s[1]))
    ? merge_l_a_to_d(s, t[0], less, [tail, t[1]])
    : merge_l_a_to_d(s[0], t, less, [tail, s[1]]);

// Merge two descending sorted linked lists producing an ascending sorted linked
// list.
function merge_l_d_to_a(s, t, less, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(s) && (is_undef(t) || less(t[1], s[1]))
    ? merge_l_d_to_a(s[0], t, less, [tail, s[1]])
    : merge_l_d_to_a(s, t[0], less, [tail, t[1]]);

// Sort a tree to an ascending linked list.
function merge_t_a(t, less) = len(t) == 1 ? [undef, t[0]]
    : merge_l_d_to_a(merge_t_d(t[0], less), merge_t_d(t[1], less), less, undef);

// Sort a tree to an descending linked list.
function merge_t_d(t, less) = len(t) == 1 ? [undef, t[0]]
    : merge_l_a_to_d(merge_t_a(t[0], less), merge_t_a(t[1], less), less, undef);

// Sort using less to an ascending vector.
function sort(v, less=function(a,b) a < b) = flatten(merge_t_a(tree(v, 0, len(v)), less));

function unique(v, less=function(a,b) a < b) = let (u = sort(v, less)) [
    for i = [0:len(u-1)] if (i == 0 || less(u[i-1], u[i])) u[i]];

l = [5, 3, 6, 8, 7, 0, 9, 1, 2];
echo(sort([5, 3, 6, 8, 7, 0, 9, 1, 2]));
echo(sort([for (i = [0:8]) [0, i * 1e-9]], function(a,b) a.x > b.x));

module polyhedron1(faces, tol=0) {
    points = unique([for f in faces each f],
                    function(a,b) norm(a-b) <= tol && a < b);
    polyhedron(
        points,
        [for (f = faces)
                [for (v = f)
                        last(points, function(x) x <= v || norm(x - v) <= tol)]]);
}

function map(l, k) = let (
    index = last(l, function(x) !(k < x[0]))
    //, dummy = echo("Last=", k, index)
    )
    index < 0 || l[index][0] < k ? undef : l[index][1];

// Return index i of first item of l with pred(l[i]) (or len(l) if none).  pred
// should be non-decreasing boolean.
function first(l, pred) = last_range(l, pred, -1, len(l));
function first_range(l, pred, low, high) = low + 1 >= high ? high : let (
    mid = floor((low + high) / 2))
    pred(l[mid]) ? last_range(l, pred, low, mid) : last_range(l, pred, mid, high);

// Return index i of last item of l with pred(l[i]) (or -1 if none). pred should
// be non-increasing boolean.
function last(l, pred) = last_range(l, pred, -1, len(l));
function last_range(l, pred, low, high) = low + 1 >= high ? low : let (
    mid = floor((low + high) / 2))
    pred(l[mid]) ? last_range(l, pred, mid, high) : last_range(l, pred, low, mid);

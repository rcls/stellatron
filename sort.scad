
function vless(u, v, tol, n=0) = is_undef(tol) ? u < v
    : n >= len(u) ? false
    : abs(u[n] - v[n]) < tol ? vless(u, v, tol, n+1)
    : u[n] < v[n];

function drop(ll, n) = n == 0 ? ll : drop(ll[0], n-1);

function flatten_n(ll, n) = n==0 ? []
    : n == 1 ? [ll[1]]
    : [each flatten_n(ll, floor(n/2)),
       each flatten_n(drop(ll, floor(n/2)), ceil(n/2))];

function link_len(ll, n=0) = is_undef(ll) ? n : link_len(ll[0], n+1);

function flatten(ll) = flatten_n(ll, link_len(ll));

function tree(v, m, n) = m == n ? [] : m+1 == n ? [v[m]]
    : let (p = floor((m + n) / 2)) [tree(v, m, p), tree(v, p, n)];

function merge_l_a_to_d(s, t, tol, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(t) && (is_undef(s) || vless(t[1], s[1], tol))
    ? merge_l_a_to_d(s, t[0], tol, [tail, t[1]])
    : merge_l_a_to_d(s[0], t, tol, [tail, s[1]]);

function merge_l_d_to_a(s, t, tol, tail) =
    is_undef(s) && is_undef(t) ? tail
    : !is_undef(s) && (is_undef(t) || vless(t[1], s[1], tol))
    ? merge_l_d_to_a(s[0], t, tol, [tail, s[1]])
    : merge_l_d_to_a(s, t[0], tol, [tail, t[1]]);

function merge_t_a(t, tol) = len(t) == 1 ? [undef, t[0]]
    : merge_l_d_to_a(merge_t_d(t[0], tol), merge_t_d(t[1], tol), tol, undef);

function merge_t_d(t, tol) = len(t) == 1 ? [undef, t[0]]
    : merge_l_a_to_d(merge_t_a(t[0], tol), merge_t_a(t[1], tol), tol, undef);

function sort(v, tol=undef) = flatten(merge_t_a(tree(v, 0, len(v)), tol));

l = [5, 3, 6, 8, 7, 0, 9, 1, 2];
echo(sort([5, 3, 6, 8, 7, 0, 9, 1, 2]));
echo(sort([for (i = [0:8]) [0, i * 1e-9]], 0));

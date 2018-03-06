function groupTable(n, t, i) {
    if (i !== 0) {
        var r, s = t,
            e = 1,
            u = [],
            f = n.find("td:eq(" + s + ")"),
            o = $(f[0]);
        for (u.push(n[0]), r = 1; r <= f.length; r++) o.text() == $(f[r]).text() ? (e++, $(f[r]).addClass("deleted"), u.push(n[r])) : (e > 1 && (o.attr("rowspan", e), groupTable($(u), t + 1, i - 1)), e = 1, u = [], o = $(f[r]), u.push(n[r]))
    }
}

(function (n) {
    n.fn.highchartTable = function () {
        var r = ["column", "line", "area", "spline", "pie"],
            u = function (t, i) {
                var e = n(t).data(i),
                    r, u, f, o;
                if (typeof e != "undefined") {
                    for (r = e.split("."), u = window[r[0]], f = 1, o = r.length; f < o; f++) u = u[r[f]];
                    return u
                }
            };
        return this.each(function () {
            var o = n(this),
                f = n(o),
                ut = 1,
                ft = n("caption", o),
                et = ft.length ? n(ft[0]).text() : "",
                s, c, y, a, l, p, v, g, e, nt, tt, h, it, rt;
            if (f.data("graph-container-before") != 1) {
                if (c = f.data("graph-container"), !c) throw "graph-container data attribute is mandatory";
                if (c[0] === "#" || c.indexOf("..") === -1) s = n(c);
                else {
                    for (y = o, a = c; a.indexOf("..") !== -1;) a = a.replace(/^.. /, ""), y = y.parent();
                    s = n(a, y)
                } if (s.length !== 1) throw "graph-container is not available in this DOM or available multiple times";
                s = s[0]
            } else f.before("<div><\/div>"), s = f.prev(), s = s[0]; if (l = f.data("graph-type"), !l) throw "graph-type data attribute is mandatory";
            if (n.inArray(l, r) == -1) throw "graph-container data attribute must be one of " + r.join(", ");
            p = f.data("graph-stacking");
            p || (p = "normal");
            var ti = f.data("graph-datalabels-enabled"),
                b = f.data("graph-inverted") == 1,
                ii = n("thead th", o),
                k = [],
                ot = [],
                d = 0,
                st = !1;
            ii.each(function (t, i) {
                var u = n(i),
                    y = u.data("graph-value-scale"),
                    s = u.data("graph-type"),
                    c, h, o, a, e, v;
                n.inArray(s, r) == -1 && (s = l);
                c = u.data("graph-stack-group");
                c && (st = !0);
                h = u.data("graph-datalabels-enabled");
                typeof h == "undefined" && (h = ti);
                o = u.data("graph-yaxis");
                typeof o != "undefined" && o == "1" && (ut = 2);
                a = u.data("graph-skip") == 1;
                a && (d = d + 1);
                e = {
                    libelle: u.text(),
                    skip: a,
                    indexTd: t - d - 1,
                    color: u.data("graph-color"),
                    visible: !u.data("graph-hidden"),
                    yAxis: typeof o != "undefined" ? o : 0,
                    dashStyle: u.data("graph-dash-style") || "solid",
                    dataLabelsEnabled: h == 1,
                    dataLabelsColor: u.data("graph-datalabels-color") || f.data("graph-datalabels-color")
                };
                v = u.data("graph-vline-x");
                typeof v == "undefined" ? (e.scale = typeof y != "undefined" ? parseFloat(y) : 1, e.graphType = s == "column" && b ? "bar" : s, e.stack = c, e.unit = u.data("graph-unit"), k[t] = e) : (e.x = v, e.height = u.data("graph-vline-height"), e.name = u.data("graph-vline-name"), ot[t] = e)
            });
            v = [];
            n(k).each(function (n, t) {
                var i, r;
                n == 0 || t.skip || (i = {
                    name: t.libelle + (t.unit ? " (" + t.unit + ")" : ""),
                    data: [],
                    type: t.graphType,
                    stack: t.stack,
                    color: t.color,
                    visible: t.visible,
                    yAxis: t.yAxis,
                    dashStyle: t.dashStyle,
                    marker: {
                        enabled: !0
                    },
                    dataLabels: {
                        enabled: t.dataLabelsEnabled,
                        color: t.dataLabelsColor,
                        align: f.data("graph-datalabels-align") || (l == "column" && b == 1 ? undefined : "center")
                    }
                }, t.dataLabelsEnabled && (r = u(o, "graph-datalabels-formatter"), r && (i.dataLabels.formatter = function () {
                    return r(this.y)
                })), v.push(i))
            });
            n(ot).each(function (n, t) {
                typeof t == "undefined" || t.skip || v.push({
                    name: t.libelle,
                    data: [{
                        x: t.x,
                        y: 0,
                        name: t.name
                    }, {
                        x: t.x,
                        y: t.height,
                        name: t.name
                    }],
                    type: "spline",
                    color: t.color,
                    visible: t.visible,
                    marker: {
                        enabled: !1
                    }
                })
            });
            var w = [],
                ht = u(o, "graph-point-callback"),
                ct = f.data("graph-xaxis-type") == "datetime",
                ri = n("tbody:first tr", o);
            for (ri.each(function (t, r) {
                if (!n(r).data("graph-skip")) {
                    var u = n("td", r);
                    u.each(function (t, u) {
                        var s, h = k[t],
                            f, c, l, b, e, a, y, o, p;
                        h.skip || (f = n(u), t == 0 ? (s = f.text(), w.push(s)) : (c = f.text(), l = v[h.indexTd], c.length == 0 ? ct || l.data.push(null) : (b = c.replace(/ /g, "").replace(/,/, "."), s = Math.round(parseFloat(b) * h.scale * 100) / 100, e = f.data("graph-x"), ct && (e = n("td", n(r)).first().text(), a = i(e), e = a.getTime() - a.getTimezoneOffset() * 6e4), y = f.data("graph-name"), o = {
                name: typeof y != "undefined" ? y : c,
                y: s,
                x: e
            }, ht && (o.events = {
                click: function () {
                                return ht(this)
            }
            }), h.graphType === "pie" && f.data("graph-item-highlight") && (o.sliced = 1), p = f.data("graph-item-color"), typeof p != "undefined" && (o.color = p), l.data.push(o))))
            })
            }
            }), g = [], e = 1; e <= ut; e++) nt = {
                title: {
                    text: typeof f.data("graph-yaxis-" + e + "-title-text") != "undefined" ? f.data("graph-yaxis-" + e + "-title-text") : ""
                },
                max: typeof f.data("graph-yaxis-" + e + "-max") != "undefined" ? f.data("graph-yaxis-" + e + "-max") : null,
                min: typeof f.data("graph-yaxis-" + e + "-min") != "undefined" ? f.data("graph-yaxis-" + e + "-min") : null,
                reversed: f.data("graph-yaxis-" + e + "-reversed") == "1",
                opposite: f.data("graph-yaxis-" + e + "-opposite") == "1",
                tickInterval: f.data("graph-yaxis-" + e + "-tick-interval") || null,
                labels: {
                    rotation: f.data("graph-yaxis-" + e + "-rotation") || 0
                },
                startOnTick: f.data("graph-yaxis-" + e + "-start-on-tick") !== "0",
                endOnTick: f.data("graph-yaxis-" + e + "-end-on-tick") !== "0",
                stackLabels: {
                    enabled: f.data("graph-yaxis-" + e + "-stacklabels-enabled") == "1"
                },
                gridLineInterpolation: f.data("graph-yaxis-" + e + "-grid-line-interpolation") || null
            }, tt = u(o, "graph-yaxis-" + e + "-formatter-callback"), tt && (nt.labels.formatter = function () {
                return tt(this.value)
            }), g.push(nt);
            var ui = ["#4572A7", "#AA4643", "#89A54E", "#80699B", "#3D96AE", "#DB843D", "#92A8CD", "#A47D7C", "#B5CA92", "#008000", "#0000FF", "#800080", "#FF00FF", "#008080", "#FFFF00", "#808080", "#00FFFF", "#000080", "#800000", "#FF3939", "#7F7F00", "#C0C0C0", "#FF6347", "#FFE4B5", "#E6E6FA", "#FFF0F5", "#FFDAB9", "#FFFACD", "#FFE4E1", "#F0FFF0", "#F0F8FF", "#F5F5F5", "#FAEBD7", "#E0FFFF", "#87CEEB", "#32CD32", "#BA55D3", "#F08080", "#4682B4", "#9ACD32", "#40E0D0", "#FF69B4", "#F0E68C", "#D2B48C", "#8FBC8B", "#6495ED", "#DDA0DD", "#5F9EA0", "#FFDAB9", "#FFA07A"],
                lt = [],
                at = typeof Highcharts.theme != "undefined" && typeof Highcharts.theme.colors != "undefined" ? Highcharts.theme.colors : [],
                vt = f.data("graph-line-shadow"),
                yt = f.data("graph-line-width") || 2;
            for (h = 0; h < 9; h++) it = "graph-color-" + (h + 1), lt.push(typeof f.data(it) != "undefined" ? f.data(it) : typeof at[h] != "undefined" ? at[h] : ui[h]);
            var pt = f.data("graph-margin-top"),
                wt = f.data("graph-margin-right"),
                bt = f.data("graph-margin-bottom"),
                kt = f.data("graph-margin-left"),
                dt = f.data("graph-xaxis-labels-enabled"),
                gt = {},
                ni = f.data("graph-xaxis-labels-font-size");
            typeof ni != "undefined" && (gt.fontSize = ni);
            rt = {
                colors: lt,
                chart: {
                    renderTo: s,
                    inverted: b,
                    marginTop: typeof pt != "undefined" ? pt : null,
                    marginRight: typeof wt != "undefined" ? wt : null,
                    marginBottom: typeof bt != "undefined" ? bt : null,
                    marginLeft: typeof kt != "undefined" ? kt : null,
                    spacingTop: f.data("graph-spacing-top") || 10,
                    height: f.data("graph-height") || null,
                    zoomType: f.data("graph-zoom-type") || null,
                    polar: f.data("graph-polar") || null
                },
                title: {
                    text: et
                },
                subtitle: {
                    text: f.data("graph-subtitle-text") || ""
                },
                legend: {
                    enabled: f.data("graph-legend-disabled") != "1",
                    layout: f.data("graph-legend-layout") || "horizontal",
                    symbolWidth: f.data("graph-legend-width") || 30,
                    x: f.data("graph-legend-x") || 15,
                    y: f.data("graph-legend-y") || 0
                },
                xAxis: {
                    categories: f.data("graph-xaxis-type") != "datetime" ? w : undefined,
                    type: f.data("graph-xaxis-type") == "datetime" ? "datetime" : undefined,
                    reversed: f.data("graph-xaxis-reversed") == "1",
                    opposite: f.data("graph-xaxis-opposite") == "1",
                    showLastLabel: typeof f.data("graph-xaxis-show-last-label") != "undefined" ? f.data("graph-xaxis-show-last-label") : !0,
                    tickInterval: f.data("graph-xaxis-tick-interval") || null,
                    dateTimeLabelFormats: {
                        second: "%e. %b",
                        minute: "%e. %b",
                        hour: "%e. %b",
                        day: "%e. %b",
                        week: "%e. %b",
                        month: "%e. %b",
                        year: "%e. %b"
                    },
                    labels: {
                        rotation: f.data("graph-xaxis-rotation") || 0,
                        align: f.data("graph-xaxis-align") || "center",
                        enabled: typeof dt != "undefined" ? dt : !0,
                        style: gt
                    },
                    startOnTick: f.data("graph-xaxis-start-on-tick"),
                    endOnTick: f.data("graph-xaxis-end-on-tick"),
                    min: t(o, "min"),
                    max: t(o, "max"),
                    alternateGridColor: f.data("graph-xaxis-alternateGridColor") || null,
                    title: {
                        text: f.data("graph-xaxis-title-text") || null
                    },
                    gridLineWidth: f.data("graph-xaxis-gridLine-width") || 0,
                    gridLineDashStyle: f.data("graph-xaxis-gridLine-style") || "ShortDot",
                    tickmarkPlacement: f.data("graph-xaxis-tickmark-placement") || "between",
                    lineWidth: f.data("graph-xaxis-line-width") || 0
                },
                yAxis: g,
                tooltip: {
                    formatter: function () {
                        if (f.data("graph-xaxis-type") == "datetime") return "<b>" + this.series.name + "<\/b><br/>" + Highcharts.dateFormat("%e. %b", this.x) + " : " + this.y;
                        var n = typeof w[this.point.x] != "undefined" ? w[this.point.x] : this.point.x;
                        return l === "pie" ? "<strong>" + this.series.name + "<\/strong><br />" + n + " : " + this.point.y : "<strong>" + this.series.name + "<\/strong><br />" + n + " : " + this.point.name
                    }
                },
                credits: {
                    enabled: !1
                },
                plotOptions: {
                    line: {
                        dataLabels: {
                            enabled: !0
                        },
                        lineWidth: yt
                    },
                    area: {
                        lineWidth: yt,
                        shadow: typeof vt != "undefined" ? vt : !0,
                        fillOpacity: f.data("graph-area-fillOpacity") || .75
                    },
                    pie: {
                        allowPointSelect: !0,
                        dataLabels: {
                            enabled: !0
                        },
                        showInLegend: f.data("graph-pie-show-in-legend") == "1",
                        size: "80%"
                    },
                    series: {
                        animation: !1,
                        stickyTracking: !1,
                        stacking: st ? p : null,
                        groupPadding: f.data("graph-group-padding") || 0
                    }
                },
                series: v,
                exporting: {
                    filename: et.replace(/ /g, "_"),
                    buttons: {
                        exportButton: {
                            menuItems: null,
                            onclick: function () {
                                this.exportChart()
                            }
                        }
                    }
                }
            };
            f.trigger("highchartTable.beforeRender", rt);
            new Highcharts.Chart(rt)
        }), this
    };
    var t = function (t, r) {
        var u = n(t).data("graph-xaxis-" + r),
            f;
        return typeof u != "undefined" ? n(t).data("graph-xaxis-type") == "datetime" ? (f = i(u), f.getTime() - f.getTimezoneOffset() * 6e4) : u : null
    },
        i = function (n) {
            var t = n.split(" "),
                i = t[0].split("-"),
                u = null,
                f = null,
                r;
            return t[1] && (r = t[1].split(":"), u = parseInt(r[0], 10), f = parseInt(r[1], 10)), new Date(parseInt(i[0], 10), parseInt(i[1], 10) - 1, parseInt(i[2], 10), u, f)
        }
})(jQuery);
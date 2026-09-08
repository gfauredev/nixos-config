#set text(lang: "fr")
// LTeX: language=fr
#import "@local/lib:1.0.0": coll, date, fig, fullpage, i18n, info, rc, res, sign
#let serif = ("Libertinus Serif",) // "Libre Baskerville", "Vollkorn")
#let sans = ("Aileron", "Inter") // "Nacelle")
#let mono = ("JetBrainsMono Nerd Font",) // "FiraCode Nerd Font")
// Glossary (initialization)
// #import "@preview/glossarium:0.5.4": (gls, glspl, make-glossary, print-glossary, register-glossary,)
#import "@preview/cetz:0.3.4"
// #import "@preview/cetz-plot:0.1.1": chart, plot
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/fletcher:0.5.7" as fletcher: diagram, edge, node
// #import "@preview/physica:0.9.5" // Engineering
#import "@preview/lovelace:0.3.0": * // Pseudocode rendering
#let pseudo = pseudocode-list // Shortcut
#set page(margin: margin, paper: paper)
#set par(justify: true)
#set text(font: serif, lang: lang)
#show link: underline


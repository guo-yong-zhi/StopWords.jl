using Documenter
using StopWords

Documenter.makedocs(
    clean = true,
    doctest = true,
    repo = "",
    highlightsig = true,
    sitename = "StopWords.jl",
    expandfirst = [],
    pages = [
        "Index" => "index.md",
    ],
)

deploydocs(;
    repo  =  "github.com/guo-yong-zhi/StopWords.jl.git",
)

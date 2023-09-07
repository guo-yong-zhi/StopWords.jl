# StopWords.jl
[![docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://guo-yong-zhi.github.io/StopWords.jl/dev) [![CI](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci.yml) [![CI-nightly](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci-nightly.yml/badge.svg)](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci-nightly.yml) [![codecov](https://codecov.io/gh/guo-yong-zhi/StopWords.jl/graph/badge.svg?token=tolYlABD6o)](https://codecov.io/gh/guo-yong-zhi/StopWords.jl)

[Stop words](https://en.wikipedia.org/wiki/Stop_word) are the words in a negative dictionary which are filtered out before or after processing of natural language data (text) because they are insignificant. This julia package contains a collection of stop words for multiple languages. The data is sourced from: <https://github.com/stopwords-iso/stopwords-iso>. Currently, this package supports 57 languages, identified by their [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639_macrolanguage) codes:
> afr ara ben bre bul cat ces dan deu ell eng epo est eus fas fin fra gle glg guj hau hbs heb hin hun hye ita jpn kor kur lat lav lit mar msa nld nor pol por ron rus slk slv som sot spa swa swe tgl tha tur ukr urd vie yor zho zul
# Installation
```julia
import Pkg; Pkg.add("StopWords")
```
# Usage
The `stopwords` variable is the only exported symbol of this package. It can be regarded as a lazy dictionary of stop words for multiple languages. You can access the stop words for a given language using the language name or [ISO 639](https://en.wikipedia.org/wiki/ISO_639) code. For example, to get the stop words for English, you can use `stopwords["eng"]`, `stopwords["en"]`, or `stopwords["English"]`.
```julia
julia> using StopWords
julia> stopwords["eng"]
```
```julia
Set{String} with 1298 elements:
  "nu"
  "youd"
  "whoever"
  "shouldn"
  "null"
  "everywhere"
  ⋮ 
```
```julia
julia> stopwords["eng"] === stopwords["en"] === stopwords["English"]
```
```julia
true
```
You can also get the stop words for multiple languages at once.
```julia
julia> stopwords[["eng", "fra"]]
```
```julia
Set{String} with 1922 elements:
  "nu"
  "youd"
  "ont"
  "pfut"
  "whoever"
  "shouldn"
  "enfin"
  "tac"
  ⋮ 
```
```julia
julia> stopwords[["eng", "fra"]] === stopwords[("eng", "fra")] == stopwords["eng"] ∪ stopwords["fra"]
```
```julia
true
```
You can also get the stop words for all languages at once.
```julia
julia> stopwords[:] === stopwords[] === stopwords[StopWords.supported_languages()]
```
```julia
true
```
The `StopWords.supported_languages()` function returns a set of all the languages currently supported by the package. To check if a specific language is supported, you can use the `haskey` function. And for multiple languages, you can pass a list to the `haskey` function.
```julia
julia> haskey(stopwords, "eng")
```
```julia
true
```
```julia
julia> haskey(stopwords, ["English", "fra"])
```
```julia
true
```
```julia
julia> haskey(stopwords, ["English", "foo"])
```
```julia
false
```
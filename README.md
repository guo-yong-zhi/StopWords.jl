# StopWords.jl
[![docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://guo-yong-zhi.github.io/StopWords.jl/dev) [![CI](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci.yml) [![CI-nightly](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci-nightly.yml/badge.svg)](https://github.com/guo-yong-zhi/StopWords.jl/actions/workflows/ci-nightly.yml) [![codecov](https://codecov.io/gh/guo-yong-zhi/StopWords.jl/graph/badge.svg?token=tolYlABD6o)](https://codecov.io/gh/guo-yong-zhi/StopWords.jl)

This package contains a collection of stopwords for multiple languages. The data is sourced from: https://github.com/stopwords-iso/stopwords-iso
# Installation
```julia
import Pkg; Pkg.add("StopWords")
```
# Usage
This package exports a single object `stopwords`. `stopwords` can be regarded as a lazy dictionary of stop words for multiple languages. You can access the stop words for a given language using the language's name or ISO 639 code.
For example, to get the stop words for English, you can use `stopwords["eng"]`, `stopwords["en"]`, or `stopwords["English"]`.
```julia
using StopWords
stopwords["eng"]
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
stopwords["eng"] === stopwords["en"] === stopwords["English"]
```
```julia
true
```
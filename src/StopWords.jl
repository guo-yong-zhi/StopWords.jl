module StopWords
include("iso639codes.jl")

export stopwords

const PACKAGE_PATH = pkgdir(StopWords)
const DATA_PATH = joinpath(PACKAGE_PATH, "stopwords")

struct StopWordsDict <: AbstractDict{Any,Set{String}}
    dict::Dict{String,Set{String}}
    dict2::Dict{Any,Set{String}}
    languages::Set{String}
    path::String
end
function StopWordsDict(path=DATA_PATH)
    languages = Set([f[1:end-4] for f in readdir(path)])
    return StopWordsDict(Dict{String,Set{String}}(), Dict{Any,Set{String}}(), languages, path)
end
function Base.iterate(sw::StopWordsDict, state=(1, nothing))
    its = (sw.dict, sw.dict2)
    ind, st = state
    ind > length(its) && return nothing
    res = st === nothing ? iterate(its[ind]) : iterate(its[ind], st)
    res === nothing ? iterate(sw, (ind+1, nothing)) : (res[1], (ind, res[2]))
end
function Base.length(sw::StopWordsDict)
    length(sw.dict) + length(sw.dict2)
end
function Base.getindex(sw::StopWordsDict, lang::String)
    if haskey(sw.dict, lang)
        return sw.dict[lang]
    else
        if lang in sw.languages
            return sw.dict[lang] = load_stopwords(lang, path=sw.path)
        end
        norm_lang = normcode(lang)
        if haskey(sw.dict, norm_lang)
            return sw.dict[lang] = sw.dict[norm_lang]
        else
            if norm_lang in sw.languages
                return sw.dict[lang] = sw.dict[norm_lang] = load_stopwords(norm_lang, path=sw.path)
            else
                error("Language $lang ($norm_lang) not supported.")
            end
        end
    end
end
Base.getindex(sw::StopWordsDict, lang::AbstractString) = sw[String(lang)]
function Base.getindex(sw::StopWordsDict, langs)
    if haskey(sw.dict2, langs)
        return sw.dict2[langs]
    else
        norm_langs = sort(unique([String(normcode(lang)) for lang in langs]))
        if haskey(sw.dict2, norm_langs)
            return sw.dict2[langs] = sw.dict2[norm_langs]
        else
            if length(norm_langs) == 1
                return sw.dict2[langs] = sw.dict2[norm_langs] = sw[norm_langs[1]]
            else
                return sw.dict2[langs] = sw.dict2[norm_langs] = union((sw[lang] for lang in norm_langs)...)
            end
        end
    end
end
Base.getindex(sw::StopWordsDict, c::Colon=:) = sw[supported_languages(sw)]
Base.get(sw::StopWordsDict, ind) = sw[ind]
Base.get(sw::StopWordsDict, ind, default) = haskey(sw, ind) ? sw[ind] : default
Base.get(default::Union{Function, Type}, sw::StopWordsDict, ind) = haskey(sw, ind) ? sw[ind] : default()
Base.setindex!(sw::StopWordsDict, val, lang::AbstractString) = sw.dict[String(lang)] = Set(val)
Base.setindex!(sw::StopWordsDict, val, langs) = sw.dict2[langs] = Set(val)

"""
    haskey(sw::StopWordsDict, lang::AbstractString) -> Bool
    haskey(sw::StopWordsDict, langs) -> Bool

Check if `lang` is a supported language. You can use either the language's name or its ISO 639 code.
For example, `haskey(stopwords, "en")`, `haskey(stopwords, "eng")`, and `haskey(stopwords, "English")` all return `true`.
And `haskey(stopwords, ["en", "fr"])` returns `true` if both English and French are supported.
"""
function Base.haskey(sw::StopWordsDict, lang::String)
    haskey(sw.dict, lang) || lang in sw.languages || normcode(lang) in sw.languages
end
Base.haskey(sw::StopWordsDict, lang::AbstractString) = haskey(sw, String(lang))
Base.haskey(sw::StopWordsDict, langs) = haskey(sw.dict2, langs) || all(haskey(sw, lang::AbstractString) for lang in langs)
Base.haskey(sw::StopWordsDict, c::Colon=:) = true

function load_stopwords(lang; path=DATA_PATH)
    filename = joinpath(path, "$lang.txt")
    open(filename) do f
        return Set(eachline(f))
    end
end

"""
`stopwords` is a lazy dictionary of stop words for multiple languages. 
You can access the stop words for a given language using the language's name or ISO 639 code.
For example, to get the stop words for English, you can use `stopwords["eng"]`, `stopwords["en"]`, or `stopwords["English"]`.
And to get the stop words for multiple languages, you can use a list, e.g. `stopwords[["en", "fr"]]`.
"""
const stopwords = StopWordsDict(DATA_PATH)

"""
    supported_languages() -> Set{String}

Return a set containing all the languages (ISO 639-3 codes) that are supported by this package. 
"""
function supported_languages(sw::StopWordsDict=stopwords)
    return sw.languages
end

end

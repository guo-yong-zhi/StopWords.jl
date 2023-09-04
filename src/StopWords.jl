module StopWords
include("iso639codes.jl")

export stopwords

const PACKAGE_PATH = pkgdir(StopWords)
const DATA_PATH = joinpath(PACKAGE_PATH, "stopwords")

struct StopWordsDict <: AbstractDict{String,Set{String}}
    dict::Dict{String,Set{String}}
    languages::Set{String}
    path::String
end
function StopWordsDict(path=DATA_PATH)
    languages = Set([f[1:end-4] for f in readdir(path)])
    return StopWordsDict(Dict{String,Set{String}}(), languages, path)
end
function Base.iterate(sw::StopWordsDict, state=1)
    iterate(sw.dict, state)
end
function Base.length(sw::StopWordsDict)
    length(sw.dict)
end
function Base.getindex(sw::StopWordsDict, lang::String)
    if haskey(sw.dict, lang)
        return sw.dict[lang]
    else
        if lang in sw.languages
            return sw.dict[lang] = load_stopwords(norm_lang, path=sw.path)
        end
        norm_lang = normcode(lang)
        if haskey(sw.dict, norm_lang)
            return sw.dict[lang] = sw.dict[norm_lang]
        else
            if norm_lang in sw.languages
                return sw.dict[lang] = sw.dict[norm_lang] = load_stopwords(norm_lang, path=sw.path)
            else
                error("Language $lang not supported")
            end
        end
    end
end
function Base.haskey(sw::StopWordsDict, lang::String)
    haskey(sw.dict, lang) || lang in sw.languages || normcode(lang) in sw.languages
end

function load_stopwords(lang; path=DATA_PATH)
    filename = joinpath(path, "$lang.txt")
    open(filename) do f
        return Set(eachline(f))
    end
end

const stopwords = StopWordsDict(DATA_PATH)

"""
supported_languages() -> Vector{String}

Return a vector containing all the languages (ISO 639-3 codes) that are supported by this package. 
"""
function supported_languages(sw::StopWordsDict=stopwords)
    return sw.languages
end

end

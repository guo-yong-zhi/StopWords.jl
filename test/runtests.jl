using StopWords
using Test
@testset "StopWords.jl" begin
    langs = collect(StopWords.supported_languages())
    @test length(langs) == 57
    @test all(StopWords.normcode.(langs) .== langs)
    @test all(l in StopWords.id_all for l in langs)
    @test isempty(stopwords)
    println(stopwords)
    @test StopWords.normcode("english") == "eng"
    @test StopWords.normcode("asdfghjkl") == "asdfghjkl"
    @test StopWords.normcode("as dfg-hjkl") == "as dfg-hjkl"
    for (k,v) in StopWords.name_id
        @test StopWords.normcode(k) == v
    end
    @test stopwords["en"] === stopwords["eng"] === stopwords["English"]
    @test stopwords["ENGLISH"] === stopwords["english"] === stopwords["EnGlIsH"]
    @test stopwords["fra"] === stopwords["fra"] === stopwords["French"] === stopwords["fr"]
    @test !isempty(stopwords["zh"])
    @test !isempty(stopwords)
    @test get(stopwords, "jpn") === stopwords["jpn"]
    @test get(stopwords, "foo", 1234) == 1234
    @test get(stopwords, "bar") do 
        Set(["a", "b"])
    end == Set(["a", "b"])
    @test haskey(stopwords, "en")
    @test haskey(stopwords, "French")
    @test haskey(stopwords, "zho")
    @test haskey(stopwords, ["zh"])
    @test haskey(stopwords, ["zh", "French"])
    @test haskey(stopwords, Set(["zh", "French"]))
    @test haskey(stopwords, ("zh-cn", "French", "zho"))
    @test haskey(stopwords, :)
    @test !haskey(stopwords, "balabala")
    @test !haskey(stopwords, ["balabala", "French"])
    @test !haskey(stopwords, Set(["balabala", "French"]))
    @test !haskey(stopwords, ("balabala", "French"))
    @test stopwords[["en", "Chinese"]] === stopwords[["zho", "eng"]] === stopwords[Set(["zh-cn", "English"])] === stopwords[("Chinese", "English")]
    @test stopwords[["en", "French"]] == stopwords["French"] ∪ stopwords["English"]
    @test stopwords[["en", "eng", "en"]] === stopwords["English"] === stopwords[["eng"]] === stopwords[Set(["en"])]
    println(keys(stopwords))
    @test stopwords[] === stopwords[:] === stopwords[StopWords.supported_languages()]

    substr = @view "eng"[1:3]
    @test haskey(stopwords, [substr])
    @test haskey(stopwords, substr)
    @test get(stopwords, substr) === stopwords["eng"] === stopwords[[substr, "eng"]]
    @test length(collect(stopwords)) == length(stopwords) #test iterate
end

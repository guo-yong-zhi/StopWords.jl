using StopWords
using Test
@testset "StopWords.jl" begin
    @test length(StopWords.supported_languages()) == 57
    @test isempty(stopwords)
    println(stopwords)
    @test stopwords["en"] === stopwords["eng"] === stopwords["English"]
    @test stopwords["fra"] === stopwords["fra"] === stopwords["French"] === stopwords["fr"]
    @test !isempty(stopwords["zh"])
    @test !isempty(stopwords)
    @test haskey(stopwords, "en")
    @test haskey(stopwords, "French")
    @test haskey(stopwords, "zho")
    @test haskey(stopwords, ["zh"])
    @test haskey(stopwords, ["zh", "French"])
    @test haskey(stopwords, Set(["zh", "French"]))
    @test haskey(stopwords, ("zh", "French", "zho"))
    @test haskey(stopwords, :)
    @test !haskey(stopwords, "balabala")
    @test !haskey(stopwords, ["balabala", "French"])
    @test !haskey(stopwords, Set(["balabala", "French"]))
    @test !haskey(stopwords, ("balabala", "French"))
    @test stopwords[["en", "Chinese"]] === stopwords[["zho", "eng"]] === stopwords[Set(["zh", "English"])] === stopwords[("Chinese", "English")]
    @test stopwords[["en", "French"]] == stopwords["French"] ∪ stopwords["English"]
    @test stopwords[["en", "eng", "en"]] === stopwords["English"] === stopwords[["eng"]] === stopwords[Set(["en"])]
    println(keys(stopwords))
    @test stopwords[] === stopwords[:] === stopwords[StopWords.supported_languages()]
end

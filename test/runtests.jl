using StopWords
using Test
@testset "StopWords.jl" begin
    @test length(StopWords.supported_languages()) == 57
    @test isempty(stopwords)
    println(stopwords)
    @test stopwords["en"] === stopwords["eng"] === stopwords["English"]
    @test !isempty(stopwords["zh"])
    @test !isempty(stopwords)
    @test haskey(stopwords, "en")
    @test haskey(stopwords, "French")
    @test haskey(stopwords, "zho")
end

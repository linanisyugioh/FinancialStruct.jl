using FinancialStruct
using Documenter

DocMeta.setdocmeta!(FinancialStruct, :DocTestSetup, :(using FinancialStruct); recursive=true)

makedocs(;
    modules=[FinancialStruct],
    authors="linan <linanisyugioh@163.com>",
    sitename="FinancialStruct.jl",
    format=Documenter.HTML(;
        canonical="https://linanisyugioh.github.io/FinancialStruct.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/linanisyugioh/FinancialStruct.jl",
    devbranch="master",
)

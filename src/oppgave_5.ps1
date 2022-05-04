[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når paramater ikke er gitt brukes default verdi
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)


$ErrorActionPreference = 'Stop'

$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

# StatusCode        :200
# StatusDescription : OK
# Content           : [{"suit":"SPADES","value":"3"},{"suit":"SPADES","value":"Q"},{"suit":"HEARTS","value":"4"},{"suit":"DIAMONDS","value":"5"},
#                     {"suit":"HEARTS","value":"6"},{"suit":"CLUBS","value":"3"},{"suit":"SPADES","…
# RawContent        : HTTP/1.1 200 OK
#                     Server: Cowboy
#                     Connection: keep-alive
#                     Transfer-Encoding: chunked
#                     Date: Mon, 27 Sep 2021 05:12:49 GMT
#                     Via: 1.1 vegur
#                     Content-Type: application/json; charset=UTF-8
#                     [{"suit":"SPADES","va…
# Headers           : {[Server, System.String[]], [Connection, System.String[]], …}
# Images            : {}
# InputFields       : {}
# Links             : {}
# RawContentLength  : 1578
# RelationLink      : {}


$kortstokkJson = $webRequest.Content
# [{"suit":"SPADES","value":"3"},{"suit":"SPADES","value":"Q"},{"suit":"HEARTS","value":"4"},{"suit":"DIAMONDS","value":"5"},{"suit":"HEARTS","value":"6"},{"suit":"CLUBS","value":"3"},{"suit":"SPADES","value":"7"},{"suit":"CLUBS","value":"6"},{"suit":"HEARTS","value":"7"},{"suit":"DIAMONDS","value":"8"},{"suit":"HEARTS","value":"Q"},{"suit":"CLUBS","value":"K"},{"suit":"CLUBS","value":"8"},{"suit":"CLUBS","value":"J"},{"suit":"SPADES","value":"8"},{"suit":"DIAMONDS","value":"4"},{"suit":"DIAMONDS","value":"2"},{"suit":"HEARTS","value":"8"},{"suit":"HEARTS","value":"K"},{"suit":"CLUBS","value":"A"},{"suit":"SPADES","value":"5"},{"suit":"HEARTS","value":"10"},{"suit":"SPADES","value":"2"},{"suit":"HEARTS","value":"J"},{"suit":"DIAMONDS","value":"6"},{"suit":"SPADES","value":"9"},{"suit":"CLUBS","value":"4"},{"suit":"SPADES","value":"J"},{"suit":"DIAMONDS","value":"A"},{"suit":"CLUBS","value":"7"},{"suit":"CLUBS","value":"5"},{"suit":"HEARTS","value":"3"},{"suit":"DIAMONDS","value":"7"},{"suit":"CLUBS","value":"9"},{"suit":"DIAMONDS","value":"9"},{"suit":"CLUBS","value":"2"},{"suit":"SPADES","value":"4"},{"suit":"CLUBS","value":"Q"},{"suit":"SPADES","value":"6"},{"suit":"DIAMONDS","value":"K"},{"suit":"HEARTS","value":"2"},{"suit":"SPADES","value":"10"},{"suit":"DIAMONDS","value":"J"},{"suit":"SPADES","value":"K"},{"suit":"DIAMONDS","value":"3"},{"suit":"DIAMONDS","value":"10"},{"suit":"DIAMONDS","value":"Q"},{"suit":"HEARTS","value":"A"},{"suit":"HEARTS","value":"5"},{"suit":"CLUBS","value":"10"},{"suit":"SPADES","value":"A"},{"suit":"HEARTS","value":"9"}]


$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson
# suit     value
# ----     -----
# SPADES   8
# HEARTS   J
# DIAMONDS A
# HEARTS   K
# CLUBS    J
# DIAMONDS 6
# CLUBS    A
# CLUBS    K
# DIAMONDS 3
# ...


function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)" + ","
    }

    $streng = $streng.Substring(0,$streng.Length-1)

    return $streng
}


Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"



### Regn ut den samlede poengsummen til kortstokk
#   Nummererte kort har poeng som angitt på kortet
#   Knekt (J), Dronning (Q) og Konge (K) teller som 10 poeng
#   Ess (A) teller som 11 poeng

# https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.1

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += `
            switch ($kort.value) {
                { $_ -cin @('J', "Q", "K") } { 10 }
                'A' { 11 }
                default { $kort.value }
            }
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
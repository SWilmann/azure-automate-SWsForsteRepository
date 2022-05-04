# Feilhåndtering - stopp programmet hvis det dukker opp noen feil
# Se https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.2#erroractionpreference
$ErrorActionPreference = 'Stop'

$webRequest = Invoke-WebRequest -Uri http://nav-deckofcards.herokuapp.com/shuffle

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

# å skrive ut kortene i kortstokken er form for loop/iterere oppgave

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

# hvorfor kommer det et komma ',' etter siste kort?
# frivillig oppgave - kan du forbedre funksjonen 'kortTilStreng' - ikke skrive ut komma etter siste kort?


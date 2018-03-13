<#

    Detta PowerShell script innehåller funktioner för att anropa TrafiStorstockholms Lokaltrafik (SL) webbservices för realtidsinformation.

    Uppdaterat till de nya APIerna 2014-11-06
    Uppdaterat till de nya APIerna 2018-03-11
    
#>
function Get-SLRealTimeDepartures {

    <#
.SYNOPSIS
    Hämta avgångar i närtid för en specifik plats

.DESCRIPTION
    Används för att hämta avgångar i närtid för en specifik site gällande tunnelbana. För övriga trafikslag så använd metoden Get-SLDpsDepartures.

    Metoden tar emot ett site-id och returnerar aktuella avgångar


.PARAMETER SiteId
    Unikt identifikationsnummer för den site som aktuella avgångar skall hämtas för, t.ex. 9192 för Slussen. Detta id fås från GetSite metoden


.PARAMETER apiKey
    En giltig API nyckel 

    Läs mer om hur man får en API nyckel på http://www.trafiklab.se/kom-igang

.PARAMETER TimeWindow
    Hämta avgångar inom önskat tidsfönster. Där tidsfönstret är antalet minuter från och med nu. Max 60.

.EXAMPLE 
    (Get-SLRealTimeDepartures -SiteId 9192 -Key '<MYOWNAPIKEY>').Buses

    Hämtar ut aktuella bussavgångar från Slussen (id=9192)

.EXAMPLE
    (Get-SLRealTimeDepartures -SiteId 9192 -Key '<MYOWNAPIKEY>').Metros

    Hämtar ut aktuella tunnelbaneavångar från Slussen (id=9192)


.NOTES
    Mer information om APIet som används finns här https://www.trafiklab.se/api/sl-realtidsinformation-4

#>   
    [CmdletBinding()]       
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [int]$SiteId, 
        [Parameter(Mandatory = $true)]
        [Alias('apikey')]
        [string]$Key, 
        [Parameter(Mandatory = $false)]
        [Alias('time')]
        [int]$TimeWindow = 15,
        [Parameter(Mandatory = $false)]
        [ValidateSet("json", "xml")]
        [string]$Format = 'json'
    )
    
    process {
        $uri = "http://api.sl.se/api2/realtimedeparturesV4.$($Format)?key=$Key&siteid=$SiteId&timewindow=$TimeWindow"
        (Invoke-RestMethod $uri).ResponseData
    }
     
}

function Get-SLSite {
    <#
.SYNOPSIS
    Med denna funktion kan du få information om en plats genom att skicka in delar av platsens namn. Du kan välja mellan att bara söka efter hållplatsområden eller hållplatser, adresser och platser.

.PARAMETER Key
    Din API nyckel

.PARAMETER SearchString
    Söksträngen

.PARAMETER StationsOnly
    Om ”True” returneras endast hållplatser. True = default

.PARAMETER MaxResults
    Maximalt antal resultat som önskas. 10 är default, det går inte att få mer än 50.

.EXAMPLE
    Get-SLSite -Key $TrafikLab.'<MYOWNAPIKEY>' -SearchString 'Roslags Näsby'

    Name   : Roslags Näsby (Täby)
    SiteId : 9633
    Type   : Station
    X      : 18057450
    Y      : 59435714

    Name   : Roslags Näsby trafikplats (Täby)
    SiteId : 2200
    Type   : Station
    X      : 18069189
    Y      : 59434446
    .
    .
    .



.NOTES
    Det krävs en API nyckel för att använda Trafkiklabs APIer. Skaffa en egen nyckel här.

#>
    [CmdletBinding()]       
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key, 

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SearchString,

        [Parameter(Mandatory = $false)]
        [bool]$StationsOnly = $true,

        [Parameter(Mandatory = $false)]
        [ValidateRange(10, 50)]
        [int]$MaxResults = 10,

        [Parameter(Mandatory = $false)]
        [ValidateSet("json", "xml")]
        [string]$Format = 'json'
    )
    
    process {    
        $uri = "https://api.sl.se/api2/typeahead.$($Format)?key=$Key&searchstring=$SearchString&stationsonly=$($StationsOnly)&maxresults=$($MaxResults)"
        Write-Verbose $uri
        (Invoke-RestMethod $uri).ResponseData
    }
}

get-help Get-SLSite -Examples

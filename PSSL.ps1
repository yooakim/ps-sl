<#

    Detta PowerShell script innehåller funktioner för att anropa Storstockholms Lokaltrafik (SL) webbservices för realtidsinformation.

    
  
#>


function Get-SLRealtidSite {            
<#

.SYNOPSIS

sök fram en site, d.v.s. en hållplats med ett eller flera stoppställen. 

Slussen är ett exempel på en site med flera stoppställen för olika sorters trafik


.DESCRIPTION

Metoden används för att söka fram en site, d.v.s. en hållplats med ett eller flera stoppställen. Slussen är ett exempel på en site med flera stoppställen för olika sorters trafik.

Metoden tar emot ett argument, hållplatsnamn, och returnerar matchande siter.


Metoden returnerar en lista med matchande siter. Listan kan innehåll inga, en eller flera siter. Varje site består av ett id-nummer (Number) och ett namn (Name).

Metoden returnerar dessutom exekveringstid (ExecutionTime) för anropet samt eventuellt fel (HafasError).


.PARAMETER stationSearch 

Argumentet stationSearch kan ta emot en sträng med följande värden:

 * Site-id, t.ex. 9192 för Slussen
 * Fullständigt eller del av ett hållplatsnamn, t.ex. plan, Gullmarsplan. 


.PARAMETER apiKey

En giltig API nyckel 

Läs mer om hur man får en API nyckel på http://www.trafiklab.se/kom-igang


.EXAMPLE

Letar efter site med namne 'Danderyds Sjukhus'

    Get-SLRealtidSite 'Danderyds sjukhus' 61340ebe5448c815440ecbaf1c6b515e


#>
    [CmdletBinding(HelpURI='http://www.trafiklab.se/api/sl-realtidsinfo/GetSite')]       
    param(
        
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [Alias('hållplatsnamn')]
        [ValidateNotNullorEmpty()]
        [string]$query = "Slussen", 

        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [Alias('key')]
        [ValidateNotNullorEmpty()]
        [string]$apiKey = $apiKey)

    $uri = "https://api.trafiklab.se/sl/realtid/GetSite?stationSearch=$query&key=$apiKey"

    (Invoke-RestMethod $uri).Hafas.Sites.Site
}  

function Get-SLRealtidDepartures {
<#

.SYNOPSIS

Hämta avgångar i närtid för en specifik site för tunnelbana


.DESCRIPTION

Används för att hämta avgångar i närtid för en specifik site gällande tunnelbana. För övriga trafikslag så använd metoden Get-SLDpsDepartures.

Metoden tar emot ett site-id och returnerar aktuella avgångar


.PARAM siteId

Unikt identifikationsnummer för den site som aktuella avgångar skall hämtas för, t.ex. 9192 för Slussen. Detta id fås från GetSite metoden


.PARAMETER apiKey

En giltig API nyckel 

Läs mer om hur man får en API nyckel på http://www.trafiklab.se/kom-igang

#>   
    [CmdletBinding(HelpURI='http://www.trafiklab.se/api/sl-realtidsinfo/GetDepartures')]       
    param(
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [Alias('ID')]
        [int]$siteId, 
        [Parameter(Mandatory=$true)]
        [Alias('key')]
        [string]$apiKey )
    
    process {
        $uri = "https://api.trafiklab.se/sl/realtid/GetDepartures?siteId=$siteId&key=$apiKey"
        (Invoke-RestMethod $uri).Departure

    }
     
}


function Get-SLRealtidDpsDepartures {
 <#

.SYNOPSIS

Hämta avgångar för buss, pendeltåg, Roslagsbanan, Tvärbanan och Spårvagn från det nya systemet DPS. DPS skall i framtiden ersätta det gamla realtidssystemet och därmed också metoden GetDepartures. 


.DESCRIPTION

Används för att hämta avgångar i närtid för en specifik site gällande tunnelbana. För övriga trafikslag så använd metoden Get-SLDpsDepartures.

Metoden tar emot ett site-id och returnerar aktuella avgångar


.PARAM siteId

Unikt identifikationsnummer för den site som aktuella avgångar skall hämtas för, t.ex. 9192 för Slussen. Detta id fås från GetSite metoden

.PARAM timeWindow

Hämta avgångar inom önskat tidsfönster. Där tidsfönstret är antalet minuter från och med nu. Giltiga värden är 10,30, 60, alla andra värden resulterar i ett fel. Om inget värde anges så används 30 minuter som default.


.PARAMETER apiKey

En giltig API nyckel 

Läs mer om hur man får en API nyckel på http://www.trafiklab.se/kom-igang

#>
    [CmdletBinding(HelpURI='http://www.trafiklab.se/api/sl-realtidsinfo/GetDpsDepartures')]      
    param(
        [Parameter(Mandatory=$true,       
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [Alias('ID')]
        [int]$siteId, 
        [ValidateSet(10,30,60)] 
        [int]$timeWindow = 30, 
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [Alias('key')]
        [string]$apiKey)
    
    process {
        $uri = "https://api.trafiklab.se/sl/realtid/GetDpsDepartures?siteId=$siteId&timeWindow=$timeWindow&key=$apiKey"
        (Invoke-RestMethod $uri).DPS

    }
     
}
# ps-sl

PowerShell script för att interagera med AB Storstockholms Lokaltrafik WebServices - [API Realtid][api-realtid-link].

Dessa funktioner låter dig söka realtidsinformation om avgångar från hållplatser i hela Stockholmsområdet via SLs realtids API. Mer information om API:et finns här

http://www.trafiklab.se/api/sl-realtidsinfo

För att kunna använda dessa API:er måste du ange en API-nyckel, du kan läsa mer om hur då skaffar en sådan på [Trafiklab.se][trafiklab-link].


http://www.trafiklab.se/kom-igang

[api-realtid-link]: http://www.trafiklab.se/api/sl-realtidsinfo
[trafiklab-link]: http://www.trafiklab.se/kom-igang 

# Förutsättningar

För att använda dessa script måste man ha [PowerShell 3.0][powershell-wiki] eller senare installerad. PowerShell 3.0 är standard i Windows 8 men går utmärkt att [ladda ner][powershell3-link] till tidigare versioner av Windows.

[powershell-wiki]: http://en.wikipedia.org/wiki/Windows_PowerShell
[powershell3-link]: http://www.microsoft.com/en-us/download/details.aspx?id=29939

# Hur gör man?

Om du vill testa detta, ladda ner filerna och skaffa en API nyckel. SMidigast är att sedan spara denna API nyckel i din PowerShell profil. Från enkommandorad, skriv:

	PS C:\> notepad $PROFILE

Sedan kan du lägga till följande rad i profilen:

  $apiKey = 'xyz123xyz123xyz123xyz123xyz123zy'

Gör man det är denna nyckel alltid tillgänlig men behöver inte sparas i scriptfilen. Glöm inte att ladda om profilen när du gjort detta! 

	PS C:\> . $PROFILE


Nu kan du pröva att söka efter id för en hållplats;

	PS C:\> Get-SLRealtidSite -query Slussen -apiKey $apiKey


	Number                                                      Name
	------                                                      ----
	9192                                                        Slussen (Stockholm)
	

För att se aktuella avgångar från Slussen, anropa DspDepartures metoden:


	PS C:\> Get-SLRealtidDpsDepartures -siteId 9192 -apiKey $apiKey

	xsi           : http://www.w3.org/2001/XMLSchema-instance
	xsd           : http://www.w3.org/2001/XMLSchema
	xmlns         : http://www1.sl.se/realtidws/
	LatestUpdate  : 2012-08-20T09:07:07.5045861+02:00
	ExecutionTime : 00:00:00.3749928
	Buses         : Buses
	Metros        :
	Trains        :
	Trams         : Trams


Ett XML dokument som visar att det finns bussavgångar (Buses) och lokaltåg (Trams) Vill du direkt se filka bussar som snart åker från Slussen, skriv:

	PS C:\> (Get-SLRealtidDpsDepartures -siteId 9192 -apiKey $apiKey).Buses.DpsBus


	SiteId             : 9192
	StopAreaNumber     : 10149
	TransportMode      : BLUEBUS
	StopAreaName       : Slussen
	LineNumber         : 2
	Destination        : Sofia
	TimeTabledDateTime : 2012-08-20T09:08:00
	ExpectedDateTime   : 2012-08-20T09:08:49
	DisplayTime        : 0 min

	SiteId             : 9192
	StopAreaNumber     : 10149
	TransportMode      : BUS
	StopAreaName       : Slussen
	LineNumber         : 76
	Destination        : Frihamnen
	TimeTabledDateTime : 2012-08-20T09:09:00
	ExpectedDateTime   : 2012-08-20T09:09:00
	DisplayTime        : 0 min

	SiteId             : 9192
	StopAreaNumber     : 10149
	TransportMode      : BUS
	StopAreaName       : Slussen
	LineNumber         : 53
	Destination        : Roslagstull
	TimeTabledDateTime : 2012-08-20T09:06:00
	ExpectedDateTime   : 2012-08-20T09:09:12
	DisplayTime        : 0 min

	..
	..
	..



# Kontakt 

Om du har frågor om detta script, skapa helst ett [issue][issue-link] i det här projektet.

[issue-link]: https://github.com/yooakim/ps-sl/issues


# Historik

	Datum		Version		Kommentar
	==========	=======		============================================================
	2012-08-20	0.1		Skapade koden





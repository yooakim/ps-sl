# ps-sl

PowerShell script för att interagera med AB Storstockholms Lokaltrafik via Trafiklabs API - [API Realtid][api-realtid-link].

Dessa funktioner låter dig söka realtidsinformation om avgångar från hållplatser i hela Stockholmsområdet via SLs realtids API. Mer information om API:et finns här

https://www.trafiklab.se/api/sl-realtidsinformation-3

För att kunna använda dessa API:er måste du ange en API-nyckel, du kan läsa mer om hur då skaffar en sådan på [Trafiklab.se][trafiklab-link].


http://www.trafiklab.se/kom-igang

[api-realtid-link]: https://www.trafiklab.se/api/sl-realtidsinformation-3
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

	```
	PS C:\> Get-SLSite -Key $apiKey -SearchString Slussen


	Name   : Slussen (Stockholm)
	SiteId : 9192
	Type   : Station
	X      : 18071859
	Y      : 59320283
	```

	

För att se aktuella avgångar från Slussen, anropa DspDepartures metoden:

```
	PS C:\> Get-SLRealTimeDepartures -SiteId 9192 -Key $apiKey


	LatestUpdate        : 2014-11-06T10:31:14
	DataAge             : 35
	Metros              : {@{StopAreaName=Slussen; GroupOfLine=Tunnelbanans gröna linje; DisplayTime=Nu; SafeDestinationName=Farsta strand; GroupOfLineId=1; DepartureGroupId=1; PlatformMessage=; TransportMode=METRO; LineNumber=18; De
                      stination=Farsta strand; JourneyDirection=2; SiteId=9192}, @{StopAreaName=Slussen; GroupOfLine=Tunnelbanans gröna linje; DisplayTime=4 min; SafeDestinationName=Hagsätra; GroupOfLineId=1; DepartureGroupId=1; 
                      PlatformMessage=; TransportMode=METRO; LineNumber=19; Destination=Hagsätra; JourneyDirection=2; SiteId=9192}, @{StopAreaName=Slussen; GroupOfLine=Tunnelbanans gröna linje; DisplayTime=7 min; SafeDestinationN
                      ame=Skarpnäck; GroupOfLineId=1; DepartureGroupId=1; PlatformMessage=; TransportMode=METRO; LineNumber=17; Destination=Skarpnäck; JourneyDirection=2; SiteId=9192}, @{StopAreaName=Slussen; GroupOfLine=Tunnelba
                      nans gröna linje; DisplayTime=1 min; SafeDestinationName=Hässelby strand; GroupOfLineId=1; DepartureGroupId=2; PlatformMessage=; TransportMode=METRO; LineNumber=19; Destination=Hässelby strand; JourneyDirect
                      ion=1; SiteId=9192}...}
	Buses               : {@{JourneyDirection=1; GroupOfLine=; StopAreaName=Slussen; StopAreaNumber=10149; StopPointNumber=40251; StopPointDesignation=O; TimeTabledDateTime=2014-11-06T10:32:00; ExpectedDateTime=2014-11-06T10:32:00; D
                      isplayTime=Nu; Deviations=; TransportMode=BUS; LineNumber=410; Destination=Ektorps centrum; SiteId=9192}, @{JourneyDirection=1; GroupOfLine=blåbuss; StopAreaName=Slussen; StopAreaNumber=10149; StopPointNumbe
                      r=40511; StopPointDesignation=M; TimeTabledDateTime=2014-11-06T10:32:00; ExpectedDateTime=2014-11-06T10:32:00; DisplayTime=Nu; Deviations=; TransportMode=BUS; LineNumber=471; Destination=Västra Orminge; Site
                      Id=9192}, @{JourneyDirection=1; GroupOfLine=blåbuss; StopAreaName=Slussen; StopAreaNumber=10149; StopPointNumber=10407; StopPointDesignation=; TimeTabledDateTime=2014-11-06T10:31:00; ExpectedDateTime=2014-11
                      -06T10:32:07; DisplayTime=Nu; Deviations=; TransportMode=BUS; LineNumber=3; Destination=Södersjukhuset; SiteId=9192}, @{JourneyDirection=2; GroupOfLine=blåbuss; StopAreaName=Slussen; StopAreaNumber=10149; St
                      opPointNumber=10246; StopPointDesignation=; TimeTabledDateTime=2014-11-06T10:33:00; ExpectedDateTime=2014-11-06T10:33:15; DisplayTime=1 min; Deviations=; TransportMode=BUS; LineNumber=2; Destination=Norrtull
                      ; SiteId=9192}...}
	Trains              : {}
	Trams               : {@{JourneyDirection=1; GroupOfLine=Saltsjöbanan; StopAreaName=Slussen; StopAreaNumber=7631; StopPointNumber=7631; StopPointDesignation=1; TimeTabledDateTime=2014-11-06T10:40:00; ExpectedDateTime=2014-11-06T1
                      0:40:00; DisplayTime=10:40; Deviations=; TransportMode=TRAM; LineNumber=25; Destination=Saltsjöbaden; SiteId=9192}}
	Ships               : {@{JourneyDirection=1; GroupOfLine=Waxholmsbolagets; StopAreaName=Slussen; StopAreaNumber=306; StopPointNumber=306; TimeTabledDateTime=2014-11-06T10:45:00; ExpectedDateTime=2014-11-06T10:45:00; DisplayTime=1
                      0:45; Deviations=; TransportMode=SHIP; LineNumber=51; Destination=Djurgården; SiteId=9192}}
	StopPointDeviations : {}
```
Ett JSON dokument som visar att det finns bussavgångar (Buses) lokaltåg (Trams) och tunnelbanetåg (metros) Vill du direkt se vilka bussar som snart åker från Slussen, skriv:

```
	PS C:\>(Get-SLRealTimeDepartures -SiteId 9192 -Key $apiKey).buses

	JourneyDirection     : 1
	GroupOfLine          : 
	StopAreaName         : Slussen
	StopAreaNumber       : 10149
	StopPointNumber      : 40371
	StopPointDesignation : N
	TimeTabledDateTime   : 2014-11-06T10:30:00
	ExpectedDateTime     : 2014-11-06T10:30:00
	DisplayTime          : Nu
	Deviations           : 
	TransportMode        : BUS
	LineNumber           : 402
	Destination          : Kvarnholmen
	SiteId               : 9192
	..
	..
	..
```







# Kontakt 

Om du har frågor om detta script, skapa helst ett [issue][issue-link] i det här projektet.

[issue-link]: https://github.com/yooakim/ps-sl/issues


# Historik

	Datum		Version		Kommentar
	==========	=======		============================================================
	2012-08-20	0.1		Skapade koden
	2014-11-06	0.2		Bytte till v3 av Realtids APIet





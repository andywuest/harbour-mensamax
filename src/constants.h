#ifndef CONSTANTS_H
#define CONSTANTS_H

// sailjail data
const char APP_NAME[] = "harbour-mensamax";
const char ORGANISATION[] = "de.andreas-wuest-it-consulting";

// data for rest calls
const char MIME_TYPE_JSON[] = "application/json";
const char USER_AGENT[] = "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0";

// mensamax
const char BASE_URL[] = "https://mensahaus.de/graphql/";

const char ENDPOINT_LOGIN [] = "auth/login/";

const char POST_BODY_LOGIN[] = R"(
{
  "projekt" : "%1",
  "benutzername" : "%2",
  "passwort" : "%3",
  "einrichtung" : "%4"
}
)";

const char POST_GET_BALANCE[] = R"(
{
  "operationName": "kontostand",
  "query": "query kontostand { meinKontostand { gesamtKontostandAktuell gesamtKontostandZukunft } }"
}
)";

const char POST_GET_USER_DATA[] = R"(
{
  "operationName": "meineDaten",
  "variables": {},
  "query": "query meineDaten { meineDaten {   personId   angemeldetePerson { id vorname nachname loginName persNr kundenNr mandant { beschreibung ident __typename } klasse { bezeichnung __typename } strasse hausNr plz ort __typename   }   __typename } }"
}
)";

// TODO date hardcoded
const char POST_GET_MENUS_DATA[] = R"(
{
   "operationName":"speiseplanByTag",
   "variables":{
      "startTime":"14/07/2025",
      "endTime":"20/07/2025"
   },
   "query":"query speiseplanByTag($startTime: DateTime!, $endTime: DateTime!) { meinSpeiseplan(von: $startTime, bis: $endTime) {   datum   ausgabeort { id bezeichnung __typename   }   essensschicht { bezeichnung __typename   }   message   menues { id meinPreis bewertungDurchschnitt datum meinSpeiseplanShow reihenfolge fristen { abbestellungBeiKrankmeldungBis abbestellungBis bestellungBis __typename } menuegruppe { bezeichnung id anzeigbar vorbestellbar meineEinstellungen {   anzeigbar   vorbestellbar   __typename } __typename }               meineBestellung { anzahlAusgegeben anzahl ausgabeort {   id   __typename } __typename }              meineMaxBestellbareMenge vorspeisen { id bezeichnung beschreibung zusatzstoffeAllergene {   id   zusatzstoffAllergen { id bezeichnung __typename   }   __typename }          bewertungAnzahl bewertungDurchschnitt __typename }            hauptspeisen { id bezeichnung beschreibung zusatzstoffeAllergene {   id   zusatzstoffAllergen { id bezeichnung __typename   }   __typename }          bewertungAnzahl bewertungDurchschnitt __typename }          nachspeisen { id bezeichnung beschreibung zusatzstoffeAllergene {   id   zusatzstoffAllergen { id bezeichnung __typename   }   __typename }  bewertungAnzahl bewertungDurchschnitt __typename } __typename   }   __typename }\n}"
}
)";


#endif // CONSTANTS_H

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

#endif // CONSTANTS_H

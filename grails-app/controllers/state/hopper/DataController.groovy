package state.hopper

import grails.converters.JSON
import java.util.concurrent.ConcurrentHashMap

/**
 * A controller for providing the data.
 * That is: all countries, their properties and values and the svg map.
 * Besides the countries are cached in local in-memory cache and this
 * controller has an action to clear this cache to update the countries.
 */
class DataController {

    /**
     * Provider of properties (name, uri) and countries (name, uri)
     */
    def countryService
    /**
     * Cache for all countries and its property values.
     */
    ConcurrentHashMap<String, List<Country>> countryCache
    /**
     * Random seed. Is used for a random time between failed queries.
     */
    Random random

    def grailsApplication

    /**
     * Action that provide the svg map of the game with content type 'image/svg+xml'.
     * @return the map is sent back to the http request as 'image/svg+xml'.
     */
    def map() {
        def applicationContext = grailsApplication.mainContext
        String basePath = applicationContext.getResource("/").getFile().toString()
        String sep = System.getProperty("file.separator")
        String fileContents = new File("${basePath}${sep}images${sep}maps${sep}optimized.svg").text
        render(text: fileContents, contentType: "image/svg+xml", encoding: "UTF-8")
    }

    /**
     * Action that provides all countries with property values for five given properties as JSON.
     * It may build up a cache, if not present, for faster access for incoming request in the future.
     * @param p1 - id of 1st property
     * @param p2 - id of 2nd property
     * @param p3 - id of 3rd property
     * @param p4 - id of 4th property
     * @param p5 - id of 5th property
     * @return a JSON representation of a list of countries
     * so that each country has only the properties and values for the given property ids.
     */
    List<Country> cachedCountries(int p1, int p2, int p3, int p4, int p5){
        def propIds = [p1, p2, p3, p4, p5]

        // copy prepared country list and cut out properties which are not in the game
        List<Country> copy = []
        buildCountryCache().each {country ->
            //copy country to not change the cache
            Country c = new Country(country)
            if(!country.name.startsWith("!")) {
                c.properties = []
                country.properties.each {p ->
                    if(propIds.contains(p["id"])) {
                        c.properties << p
                    }
                }
            }
            copy << c
        }
        render copy as JSON
    }

    /**
     * An action to clear the country cache. Use this to update all countries with current values.
     * @return success message is posted.
     */
    def cache() {
        if(!countryCache) {
            countryCache = new ConcurrentHashMap<String, List<Country>>()
        }
        countryCache.clear()
        render "Cleared country cache."
    }

    /**
     * Creates a list of all countries with all property values and cache them.
     * Use cache() to clear this cache.
     * For each active country a query for each data provider is created, sent and evaluated
     * to fill all property values for all active countries.
     *
     * @return a list of all countries such that the active countries have all property values.
     * @throws RuntimeException - this method tries to query a data provider again,
     * if there was any Exception (Timeout i.e.). To prevent an endless loop, a RuntimeException
     * is thrown after several tries.
     */
    private List<Country> buildCountryCache() throws RuntimeException {
        // check cache and create it, if necessary
        if(countryCache) {
            def cc = countryCache.get("countries")
            if(cc) {
                // used cached list if available
                return cc
            }
        } else {
            countryCache = new ConcurrentHashMap<String, List<Country>>()
        }
        if(!random) {
            random = new Random()
        }
        // get countries with name and uri for querying
        def countries = countryService.getCountries()
        // get properties (dbpedia/factbook) with name and uri for querying
        def dProps = countryService.getDBPProperties()
        def fProps = countryService.getFBProperties()

        println("prepare queries ...")
        def countryList = []
        for(Country c : countries) {
            def country = new Country(c)
            // just use active countries. See Country javadoc for explanations
            if (!country.name.startsWith("!")) {
                def result
                def dQuery = getPropertyQuery(country.db, dProps)
                println("query " + country.db + " (dbpedia) ...")
                def i = 10
                while (true) {
                    try {
                        if (i <= 0) {
                            throw new RuntimeException("Failed to query dbpedia with query '" + dQuery + "'")
                        }
                        result = queryDBPedia(dQuery)
                        break
                    } catch (Exception e) {
                        println("querying " + country.db + " failed (dbpedia), retry ...")
                        sleep(50 * random.nextInt(10))
                        i--
                    }
                }
                println("query for " + country.db + " successful (dbpedia), evaluating ...")
                evaluateQuery(country, result, dProps)
                def fQuery = getPropertyQuery(country.fb, fProps)
                println("query " + country.db + " (factbook) ...")
                while (true) {
                    try {
                        if (i <= 0) {
                            throw new RuntimeException("Failed to query factbook with query '" + fQuery + "'")
                        }
                        result = queryFactbook(fQuery)
                        break
                    } catch (Exception e) {
                        println("querying " + country.db + " failed (factbook), retry ...")
                        sleep(50 * random.nextInt(10))
                        i--
                    }
                }
                println("query for " + country.db + " successful (factbook), evaluating ...")
                evaluateQuery(country, result, fProps)
                println("finished " + country.db)
                countryList << country
            }
        }
        println("finished querying countries")
        countryCache.put("countries", countryList)
        return countryList
    }

    /**
     * Helper method for parsing the query results of property query for any data provider.
     * For every property in props it stores the parsed result value in the country as a map.
     * This map contains 'id' and 'name' as String and 'value' as a Number.
     * @param country - the country container in which the property values are written
     * @param result - the query result of the data provider as a JSON object in String representation.
     * @param props - list of properties to extract from the results and write them in the country.
     * @IllegalArgumentException - if a value of a property could not be parsed to a number,
     * this method interprets the value as a String and tries to extract the first number it finds.
     * If there is no such first number or the string is even empty an IllegalArgumentException is thrown.
     * An IllegalArgumentException is also thrown if there no values at all in the results.
     * This could be the case, if at least one property value was not available for the country
     * and therefore the SPARQL query had no bindings at all.
     */
    private static void evaluateQuery(Country country, String result, List<Property> props) throws IllegalArgumentException{
        def json = JSON.parse(result)
        if(!json.results.bindings || json.results.bindings.isEmpty()) {
            throw new IllegalArgumentException("SPARQL: No values for country: " + country.name + " with result bindings: " + json.results.bindings);
        }

        def bindings = json.results.bindings[0]
        if(!country.properties) {
            country.properties = []
        }
        // for each property get the value and build a property map
        props.each { p ->
            def m = [:]
            m["id"] = p.propertyId
            m["name"] = p.name

            def val = bindings["p" + p.propertyId].value
            if (!val.isNumber()) {
                // find first occurrence of a number in the value, if its not a number
                val = val.find(/[0-9]+/)
                if (!val || !val.isNumber()) {
                    throw new IllegalArgumentException("Property doesn't contain not a number. Country='" +
                            country.name + "', property='" + p.uri + "', result='" +
                            bindings["p" + p.propertyId] + "'.")
                }
            }
            // write back the property map in the country
            m["value"] = val
            country.properties << m
        }
    }

    /**
     * Creates a property query for country.
     * Each property in the given list is included in the query (non optional) and
     * its id is used as a query variable (beginning with a 'p').
     * The property URIs are fully included, the country URIs are in prefix notation
     * and require a query prefix. This prefix is not included.
     * @param countryURI - the URI of a country in prefix notation
     * @param props - a list of all properties to query.
     * In fact only each URI and id is used.
     * @return a String representation of a SPAQRL query
     */
    private static String getPropertyQuery(countryURI, List<Property> props) {
        def query = "select * where {\n"
        props.each { p ->
            query += "${countryURI} <"
            if(p.provider == Property.PROVIDER_FACTBOOK) {
                query += Property.FACTBOOK_PROPERTY_PREFIX
            }
            query += "${p.uri}> ?p${p.propertyId} .\n"
        }
        return query + "}"
    }

    /**
     * A method that queries dbpedia with a given query in JSON format.
     * @param query - the SPARQL query as a String
     * @return - the results. A JSON object in String representation
     */
    private static String queryDBPedia(String query) {
        query = URLEncoder.encode(query, "UTF-8")
        def urlStr= "http://dbpedia.org/sparql?&default-graph-uri=http%3A%2F%2Fdbpedia.org&should-sponge=&query=$query&format=application%2Fsparql-results%2Bjson"
        def stream = new URL(urlStr).openStream()
        def text = stream.getText("UTF-8")
        stream.close()
        return text
    }

    /**
     * A method that queries the cia world factbook with a given query in JSON format.
     * @param query - the SPARQL query as a String
     * @return - the results. A JSON object in String representation
     */
    private static String queryFactbook(String query) {
        query = URLEncoder.encode("prefix db: <http://wifo5-04.informatik.uni-mannheim.de/factbook/resource/> "+query, "UTF-8")
        def urlStr= "http://wifo5-04.informatik.uni-mannheim.de/factbook/sparql?output=json&query=$query"
        def stream = new URL(urlStr).openStream()
        def text = stream.getText("UTF-8")
        stream.close()
        return text
    }

/*
// the following methods are for property scanning only, not used in actual application!

    private def attributeTestQuery(String prefix, String prop) {
        def dbUris = []
        countryService.getCountries().each {c ->
            if(c.db) {
                dbUris << c.db
            }
        }
        def query = "select distinct ?c ?p where {"
        dbUris.each {uri ->
            query += """
            |{${uri} a [] .
            | filter not exists {${uri} ${prefix}:${prop} ?prop } .

            | bind(${uri} as ?c)} union
            |""".stripMargin()
        }
        return query.substring(0, query.length()-7) + "}"
    }

    def test() {
        def prop = "populationTotal"
        def q = attributeTestQuery("dbpedia-owl", prop)
        println(q)
    }

    def attributeCount() {

        def dbUris = []
        countryService.getCountries().each {c ->
            if(c.fb) {
                dbUris << c.fb
            }
        }

        CopyOnWriteArrayList<ArrayList<String>> allProps = new CopyOnWriteArrayList<ArrayList<String>>()
        def tasks = []
        dbUris.each {uri ->
            def t = task {
                def i = 10;
                while(true) {
                    try {
                        if(i==0) break;
                        def props = queryCountry(uri)
                        allProps << props
                        break
                    } catch (Exception) {
                        println("failed: "+uri)

                        i--;
                        sleep(250)
                    }
                }
            }
            tasks << t
        }
        waitAll(tasks)
        println("querying done")

        def propMap = [:]
        allProps.each {props ->
            props.each { p ->
                def val = propMap[p]
                if(!val) {
                    val = new Integer(0)
                }
                val++
                propMap[p] = val
            }
        }

        println(propMap)
        render propMap.toString()
    }

    private def queryCountry(def uri) {

        def propQuery = attrQuery(uri)
        //println(propQuery)
        def text = queryFactbook(propQuery)
        //println(text)
        String[] splits = text.split("\"")
        def props = []
        splits.each { s ->
            if(s.startsWith("http")) {
                props << s
            }
        }
        return props
    }

    private String attrQuery(def uri) {
        String query = "prefix db: <http://wifo5-04.informatik.uni-mannheim.de/factbook/resource/> select distinct ?prop where {"
        query += "${uri} ?prop []."
        query += "}"
        return query
    }

    */
}

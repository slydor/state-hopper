package state.hopper

/**
 * Grails service for setting up and provide all countries and properties.
 */

class CountryService {

    // create all beans, load instances
    def country01
    def country02
    def country03
    def country04
    def country05
    def country06
    def country07
    def country08
    def country09
    def country10
    def country11
    def country12
    def country13
    def country14
    def country15
    def country16
    def country17
    def country18
    def country19
    def country20
    def country21
    def country22
    def country23
    def country24
    def country25
    def country26
    def country27
    def country28
    def country29
    def country30
    def country31
    def country32
    def country33
    def country34
    def country35
    def country36
    def country37
    def country38
    def country39
    def country40
    def country41
    def country42
    def country43
    def country44
    def country45
    def country46
    def country47
    def country48
    def country49
    def country50
    def country51
    def country52
    def country53
    def country54
    def country55
    def country56
    def country57
    def country58
    def country59
    def country60
    def country61

    def dbpediaProp01
    def dbpediaProp02
    def dbpediaProp03

    def factbookProp01
    def factbookProp02
    def factbookProp03
    def factbookProp04
    def factbookProp05
    def factbookProp06
    def factbookProp07
    def factbookProp08
    def factbookProp09
    def factbookProp10
    /**
     * Returns a list of all countries.
     * @return
     */
    def getCountries(){
        def countries = [country01, country02, country03, country04, country05, country06, country07, country08,
                         country09, country10, country11, country12, country13, country14, country15, country16,
                         country17, country18, country19, country20, country21, country22, country23, country24,
                         country25, country26, country27, country28, country29, country30, country31, country32,
                         country33, country34, country35, country36, country37, country38, country39, country40,
                         country41, country42, country43, country44, country45, country46, country47, country48,
                         country49, country50, country51, country52, country53, country54, country55, country56,
                         country57, country58, country59, country60, country61]
        return countries
    }

    /**
     * Returns a list of all properties of dbpedia.
     * @return
     */
    List<Property> getDBPProperties() {
        def props = [dbpediaProp01, dbpediaProp02, dbpediaProp03 ]
        return props
    }

    /**
     * Returns a list of all properties of factbook.
     * @return
     */
    List<Property> getFBProperties() {
        def props = [factbookProp01, factbookProp02, factbookProp03, factbookProp04, factbookProp05, factbookProp06,
                     factbookProp07, factbookProp08, factbookProp09, factbookProp10 ]
        return props
    }
}

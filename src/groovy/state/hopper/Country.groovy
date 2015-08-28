package state.hopper
/**
 * Container for a country. The name is the official country name.
 * It may be active or non active. See JavaDoc for 'name'.
 * The code is the countries ISO 3166-1 alpha-2 code.
 * See https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
 *
 * All countries are created by grails with injected beans defined in grails-app/conf/spring/resources.groovy
 */
class Country {
    /**
     * Official name of the country. This String might start with an '!'.
     * If so, this country is handled as non active. For non active countries
     * no properties are queried and they are not part of the game.
     */
    String name
    /**
     * Might be handy for some countries with long names, i.e. UK.
     */
    String shortName
    /**
     * ISO 3166-1 alpha-2 code.
     */
    String code
    /**
     * List of ids of svg path elements of this country in the svg map.
     */
    List<String> mapIds
    /**
     * Dbpedia URI for this country to use in sparql endpoint.
     */
    String db
    /**
     * World Factbook URI for this country to use in sparql endpoint.
     */
    String fb
    /**
     * List of codes of all neighbor countries. Neighbors of sea-bordered countries are chosen by will.
     */
    List<String> neighbors;
    /**
     * List of properties with its values for this country.
     * Each map is filled with key-value-pairs of keys "id", "name" and "value" by the querying mechanism.
     */
    List<Map> properties

    /**
     * Default constructor. Does nothing.
     */
    public Country() {
    }

    /**
     * Copy constructor. It creates a real copy from the given country with all fields, but the lists.
     * mapIds, neighbors and properties are always created. If these fields of c are null, they will be set to [].
     * @param c - the country to copy
     */
    public Country(Country c) {
        this.name = c.name
        this.shortName = c.shortName
        this.code = c.code
        this.mapIds = []
        c.mapIds.each {id ->
            this.mapIds << id
        }
        this.db = c.db
        this.fb = c.fb
        this.neighbors = []
        c.neighbors.each {nb ->
            this.neighbors << nb
        }
        this.properties = []
        c.properties.each {p ->
            this.properties << p
        }
    }

    /**
     * Generated method for debugging purpose only.
     * @return the String representation of this class.
     */
    @Override
    public String toString() {
        return "Country{" +
                "name='" + name + '\'' +
                ", shortName='" + shortName + '\'' +
                ", code='" + code + '\'' +
                ", mapIds=" + mapIds +
                ", db='" + db + '\'' +
                ", fb='" + fb + '\'' +
                ", neighbors=" + neighbors +
                ", properties=" + properties +
                '}';
    }
}
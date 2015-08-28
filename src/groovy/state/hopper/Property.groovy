package state.hopper

/**
 * Container class for a property. Each property has an unique id,
 * a name and an URI for querying. The value is not stored in this container, see class Country.
 *
 * A property could has its origin in a data provider such as dbpedia or the cia world factbook.
 * Its important to assign every property a provider to get the query built correct.
 *
 * All properties are created by grails with injected beans defined in grails-app/conf/spring/resources.groovy
 */
class Property {

    /**
     * The prefix which is needed for each property query for factbook.
     */
    public static String FACTBOOK_PROPERTY_PREFIX = "http://wifo5-04.informatik.uni-mannheim.de/factbook/ns#"
    /**
     * If provider is set to this, it states that this property needs to be queried in dbpedia.
     */
    public static int PROVIDER_DBPEDIA = 0
    /**
     * If provider is set to this, it states that this property needs to be queried in factbook.
     */
    public static int PROVIDER_FACTBOOK = 1

    /**
     * Id for this property. Needs to unique in whole application.
     */
    int propertyId
    /**
     * Provider id, i.e. dbpedia: PROVIDER_DBPEDIA
     */
    int provider
    /**
     * URI for this property which is used for querying.
     */
    String uri
    /**
     * Name of this property. Is used for displaying this property in menu and game.
     */
    String name
    /**
     * A optional link to some website.
     * If set, a button is created in the menu with this link to explain the meaning of this property to the user.
     * If set it requires desc also to be set.
     */
    String explain
    /**
     * A optional short description of this property.
     * If desc and explain are set, this text is shown in a tooltip above the button mentioned in explain javadoc.
     */
    String desc

    /**
     * Generated method for debugging purpose only.
     * @return the String representation of this class.
     */
    @Override
    public String toString() {
        return "Property{" +
                "propertyId=" + propertyId +
                ", provider=" + provider +
                ", uri='" + uri + '\'' +
                ", name='" + name + '\'' +
                ", explain='" + explain + '\'' +
                ", desc='" + desc + '\'' +
                '}';
    }
}
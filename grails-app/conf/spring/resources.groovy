import state.hopper.Country
import state.hopper.Property

beans = {
    country01(Country) {
        name = "!Andorra"
        code = "ad"
        mapIds = ["ad"]
    }
    country02(Country) {
        name = "Albania"
        code = "al"
        mapIds = ["al"]
        db = "dbpedia:Albania"
        fb = "db:Albania"
        neighbors = ["it", "rs", "mk", "gr"]
    }
    country03(Country) {
        name = "!Armenia"
        code = "am"
        mapIds = ["am"]
    }
    country04(Country) {
        name = "Austria"
        code = "at"
        mapIds = ["at"]
        db = "dbpedia:Austria"
        fb = "db:Austria"
        neighbors = ["de", "cz", "sk", "hu", "si", "it", "ch"]
    }
    country05(Country) {
        name = "!Azerbaijan"
        code = "az"
        mapIds = ["az"]
    }
    country06(Country) {
        name = "Bosnia and Herzegovina"
        code = "ba"
        mapIds = ["ba"]
        db = "dbpedia:Bosnia_and_Herzegovina"
        fb = "db:Bosnia_and_Herzegovina"
        neighbors = ["hr", "rs"]
    }
    country07(Country) {
        name = "Belgium"
        code = "be"
        mapIds = ["be"]
        db = "dbpedia:Belgium"
        fb = "db:Belgium"
        neighbors = ["fr", "gb", "nl", "lu", "de"]
    }
    country08(Country) {
        name = "Bulgaria"
        code = "bg"
        mapIds = ["bg"]
        db = "dbpedia:Bulgaria"
        fb = "db:Bulgaria"
        neighbors = ["rs", "ro", "mk", "gr"]
    }
    country09(Country) {
        name = "Belarus"
        code = "by"
        mapIds = ["by"]
        db = "dbpedia:Belarus"
        fb = "db:Belarus"
        neighbors = ["pl", "lv", "ua"]
    }
    country10(Country) {
        name = "Switzerland"
        code = "ch"
        mapIds = ["ch"]
        db = "dbpedia:Switzerland"
        fb = "db:Switzerland"
        neighbors = ["fr", "de", "at", "it"]
    }
    country11(Country) {
        name = "Cyprus"
        code = "cy"
        mapIds = ["cy"]
        db = "dbpedia:Cyprus"
        fb = "db:Cyprus"
        neighbors = ["gr"]
    }
    country12(Country) {
        name = "Czech Republic"
        code = "cz"
        mapIds = ["cz"]
        db = "dbpedia:Czech_Republic"
        fb = "db:Czech_Republic"
        neighbors = ["de", "pl", "sk", "at"]
    }
    country13(Country) {
        name = "Germany"
        code = "de"
        mapIds = ["de"]
        db = "dbpedia:Germany"
        fb = "db:Germany"
        neighbors = ["dk", "pl", "cz", "at", "ch", "fr", "lu", "be", "nl"]
    }
    country14(Country) {
        name = "Denmark"
        code = "dk"
        mapIds = ["dk"]
        db = "dbpedia:Denmark"
        fb = "db:Denmark"
        neighbors = ["se", "de"]

    }
    country15(Country) {
        name = "!Algeria"
        code = "dz"
        mapIds = ["dz"]
    }
    country16(Country) {
        name = "Estonia"
        code = "ee"
        mapIds = ["ee"]
        db = "dbpedia:Estonia"
        fb = "db:Estonia"
        neighbors = ["fi", "se", "lv"]
    }
    country17(Country) {
        name = "Spain"
        code = "es"
        mapIds = ["es"]
        db = "dbpedia:Spain"
        fb = "db:Spain"
        neighbors = ["pt", "fr"]
    }
    country18(Country) {
        name = "Finland"
        code = "fi"
        mapIds = ["fi"]
        db = "dbpedia:Finland"
        fb = "db:Finland"
        neighbors = ["se", "ee"]
    }
    country19(Country) {
        name = "France"
        code = "fr"
        mapIds = ["fr"]
        db = "dbpedia:France"
        fb = "db:France"
        neighbors = ["ie", "gb", "be", "lu", "de", "ch", "it", "es"]
    }
    country20(Country) {
        name = "United Kingdom of Great Britain and Northern Ireland"
        shortName = "United Kingdom"
        code = "gb"
        mapIds = ["gb"]
        db = "dbpedia:United_Kingdom"
        fb = "db:United_Kingdom"
        neighbors = ["is", "ie", "fr", "be", "nl"]
    }
    country21(Country) {
        name = "!Georgia"
        code = "ge"
        mapIds = ["ge"]
    }
    country22(Country) {
        name = "!Greenland"
        code = "gl"
        mapIds = ["gl"]
    }
    country23(Country) {
        name = "Greece"
        code = "gr"
        mapIds = ["gr"]
        db = "dbpedia:Greece"
        fb = "db:Greece"
        neighbors = ["it", "cy", "al", "mk", "bg"]
    }
    country24(Country) {
        name = "Croatia"
        code = "hr"
        mapIds = ["hr"]
        db = "dbpedia:Croatia"
        fb = "db:Croatia"
        neighbors = ["it", "si", "hu", "rs", "ba"]
    }
    country25(Country) {
        name = "Hungary"
        code = "hu"
        mapIds = ["hu"]
        db = "dbpedia:Hungary"
        fb = "db:Hungary"
        neighbors = ["at", "sk", "ro", "hr", "si", "rs", "ua"]
    }
    country26(Country) {
        name = "Ireland"
        code = "ie"
        mapIds = ["ie"]
        db = "dbpedia:Republic_of_Ireland"
        fb = "db:Ireland"
        neighbors = ["gb", "is", "fr"]
    }
    country27(Country) {
        name = "!Israel"
        code = "il"
        mapIds = ["il"]
    }
    country28(Country) {
        name = "!Iraq"
        code = "iq"
        mapIds = ["iq"]
    }
    country29(Country) {
        name = "!Islamic Republic of Iran"
        code = "ir"
        mapIds = ["ir"]
    }
    country30(Country) {
        name = "Iceland"
        code = "is"
        mapIds = ["is"]
        db = "dbpedia:Iceland"
        fb = "db:Iceland"
        neighbors = ["ie", "gb"]
    }
    country31(Country) {
        name = "Italy"
        code = "it"
        mapIds = ["it"]
        db = "dbpedia:Italy"
        fb = "db:Italy"
        neighbors = ["fr", "ch", "at", "si", "hr", "al", "gr"]
    }
    country32(Country) {
        name = "!Jordan"
        code = "jo"
        mapIds = ["jo"]
    }
    country33(Country) {
        name = "!Kazakhstan"
        code = "kz"
        mapIds = ["kz"]
    }
    country34(Country) {
        name = "!Lebanon"
        code = "lb"
        mapIds = ["lb"]
    }
    country35(Country) {
        name = "!Liechtenstein"
        code = "li"
        mapIds = ["li"]
    }
    country36(Country) {
        name = "!Lithuania" //turned off due to bad data: area land/water has value "NA sq km"
        code = "lt"
        mapIds = ["lt"]
        /*db = "dbpedia:Lithuania"
        fb = "db:Lithuania"*/
        /*neighbors = ["se", "lv", "by", "pl"]*/
    }
    country37(Country) {
        name = "Luxembourg"
        code = "lu"
        mapIds = ["lu"]
        db = "dbpedia:Luxembourg"
        fb = "db:Luxembourg"
        neighbors = ["fr", "be", "de"]
    }
    country38(Country) {
        name = "Latvia"
        code = "lv"
        mapIds = ["lv"]
        db = "dbpedia:Latvia"
        fb = "db:Latvia"
        neighbors = ["se", "ee", "by"]
    }
    country39(Country) {
        name = "!Morocco "
        code = "ma"
        mapIds = ["ma"]
    }
    country40(Country) {
        name = "!Monaco"
        code = "mc"
        mapIds = ["mc"]
    }
    country41(Country) {
        name = "Republic of Moldova"
        shortName = "Moldova"
        code = "md"
        mapIds = ["md"]
        db = "dbpedia:Moldova"
        fb = "db:Moldova"
        neighbors = ["ro", "ua"]
    }
    country42(Country) {
        name = "!Montenegro" // turned off due to lack of data -> gini is missing
        code = "me"
        mapIds = ["me"]
        /*db = "dbpedia:Montenegro"*/
        /*fb = "db:Montenegro"*/
        /*neighbors = ["it", "rs", "ba","al"]*/
    }
    country43(Country) {
        name = "The former Yugoslav Republic of Macedonia"
        shortName = "Macedonia"
        code = "mk"
        mapIds = ["mk"]
        db = "dbpedia:Republic_of_Macedonia"
        fb = "db:Macedonia"
        neighbors = ["rs","al","gr","bg"]
    }
    country44(Country) {
        name = "!Malta"
        code = "mt"
        mapIds = ["mt"]
    }
    country45(Country) {
        name = "Netherlands"
        code = "nl"
        mapIds = ["nl"]
        db = "dbpedia:Netherlands"
        fb = "db:Netherlands"
        neighbors = ["gb", "be", "de"]
    }
    country46(Country) {
        name = "!Norway" // all data is lost in dbpedia, why???
        code = "no"
        mapIds = ["no"]
        /*db = "dbpedia:Norway"*/
        /*fb = "db:Norway"*/
        /*neighbors = ["fi", "is", "gb", "dk", "se"]*/
    }
    country47(Country) {
        name = "Poland"
        code = "pl"
        mapIds = ["pl"]
        db = "dbpedia:Poland"
        fb = "db:Poland"
        neighbors = ["de", "se", "by", "ua", "sk", "cz"/*, "lt"*/]
    }
    country48(Country) {
        name = "Portugal"
        code = "pt"
        mapIds = ["pt"]
        db = "dbpedia:Portugal"
        fb = "db:Portugal"
        neighbors = ["es"]
    }
    country49(Country) {
        name = "Romania"
        code = "ro"
        mapIds = ["ro"]
        db = "dbpedia:Romania"
        fb = "db:Romania"
        neighbors = ["ua","hu","rs","bg","md"]
    }
    country50(Country) {
        name = "Serbia"
        code = "rs"
        mapIds = ["rs"]
        db = "dbpedia:Serbia"
        fb = "db:Serbia"
        neighbors = ["hu", "hr", "ba",/*"me",*/"al", "mk", "bg", "ro"]
    }
    country51(Country) {
        name = "!Russian Federation"
        code = "ru"
        mapIds = ["ru-kaliningrad", "ru-main"] //grouped in group with id "ru"
    }
    country52(Country) {
        name = "!Saudia Arabia"
        code = "sa"
        mapIds = ["sa"]
    }
    country53(Country) {
        name = "Sweden"
        code = "se"
        mapIds = ["se"]
        db = "dbpedia:Sweden"
        fb = "db:Sweden"
        neighbors = ["dk", "fi", "pl", "lv", "ee"]
    }
    country54(Country) {
        name = "Slovenia"
        code = "si"
        mapIds = ["si"]
        db = "dbpedia:Slovenia"
        fb = "db:Slovenia"
        neighbors = ["it", "at", "hu", "hr"]
    }
    country55(Country) {
        name = "Slovakia"
        code = "sk"
        mapIds = ["sk"]
        db = "dbpedia:Slovakia"
        fb = "db:Slovakia"
        neighbors = ["pl","cz","at","hu","ua"]
    }
    country56(Country) {
        name = "!San Marino"
        code = "sm"
        mapIds = ["sm"]
    }
    country57(Country) {
        name = "!Syrian Arab Republic"
        code = "sy"
        mapIds = ["sy"]
    }
    country58(Country) {
        name = "!Turkmenistan"
        code = "tm"
        mapIds = ["tm"]
    }
    country59(Country) {
        name = "!Tunisia"
        code = "tn"
        mapIds = ["tn"]
    }
    country60(Country) {
        name = "!Turkey"
        code = "tr"
        mapIds = ["tr"]
    }
    country61(Country) {
        name = "Ukraine"
        code = "ua"
        mapIds = ["ua"]
        db = "dbpedia:Ukraine"
        fb = "db:Ukraine"
        neighbors = ["by","pl","sk","hu","ro","md"]
    }

    dbpediaProp01(Property) {
        propertyId = 1
        name = "GDP Nominal per Capita"
        uri = "http://dbpedia.org/property/gdpNominalPerCapita"
        explain = "https://en.wikipedia.org/wiki/Gross_domestic_product"
        desc = "From Wikipedia: \"Gross domestic product (GDP) is defined by the Organization for Economic " +
                "Co-operation and Development (OECD) as \"an aggregate measure of production equal to the sum of the " +
                "gross values added of all resident, institutional units engaged in production (plus any taxes, and " +
                "minus any subsidies, on products not included in the value of their outputs).\"\""
        provider = Property.PROVIDER_DBPEDIA
    }

    dbpediaProp02(Property) {
        propertyId = 2
        name = "Gini Coefficient"
        uri = "http://dbpedia.org/property/gini"
        explain = "https://en.wikipedia.org/wiki/Gini_coefficient"
        desc = "From Wikipedia: \"The Gini coefficient (also known as the Gini index or Gini ratio) (/dʒini/ jee-nee) is a measure of " +
                "statistical dispersion intended to represent the income distribution of a nation's residents, and " +
                "is the most commonly used measure of inequality. It was developed by the Italian statistician and " +
                "sociologist Corrado Gini and published in his 1912 paper \"Variability and Mutability\" (Italian: " +
                "Variabilità e mutabilità).\""
        provider = Property.PROVIDER_DBPEDIA
    }

    dbpediaProp03(Property) {
        propertyId = 3
        name = "HDI"
        uri = "http://dbpedia.org/property/hdi"
        explain = "https://en.wikipedia.org/wiki/Human_Development_Index"
        desc = "From Wikipedia: \"The Human Development Index (HDI) is a composite statistic of life expectancy, " +
                "education, and per capita income indicators, which is used to rank countries into four tiers of human" +
                " development.\""
        provider = Property.PROVIDER_DBPEDIA
    }

    factbookProp01(Property) {
        propertyId = 4
        name = "Airports"
        uri = "airports_total"
        explain = "#"
        desc = "Total amount of airports."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp02(Property) {
        propertyId = 5
        name = "Area"
        uri = "area_total"
        explain = "#"
        desc = "Total area."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp03(Property) {
        propertyId = 6
        name = "Area land"
        uri = "area_land"
        explain = "#"
        desc = "Area of land."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp04(Property) {
        propertyId = 7
        name = "Area water"
        uri = "area_water"
        explain = "#"
        desc = "Area of water."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp05(Property) {
        propertyId = 8
        name = "Highest point"
        uri = "elevationextremes_highestpoint"
        explain = "#"
        desc = "The hightest point in the landscape."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp06(Property) {
        propertyId = 9
        name = "Internet user"
        uri = "internetusers"
        explain = "#"
        desc = "Total amount of internet users."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp07(Property) {
        propertyId = 10
        name = "Population"
        uri = "population_total"
        explain = "#"
        desc = "Total amount of people."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp08(Property) {
        propertyId = 11
        name = "Roadways"
        uri = "roadways_total"
        explain = "#"
        desc = "Total length of roads."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp09(Property) {
        propertyId = 12
        name = "Telephone main lines"
        uri = "telephones_mainlinesinuse"
        explain = "#"
        desc = "Amount of main line telephones in use."
        provider = Property.PROVIDER_FACTBOOK
    }

    factbookProp10(Property) {
        propertyId = 13
        name = "Telephone mobile"
        uri = "telephones_mobilecellular"
        explain = "#"
        desc = "Amount of mobile cellular telephones in use."
        provider = Property.PROVIDER_FACTBOOK
    }
}

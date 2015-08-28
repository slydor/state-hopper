package state.hopper

class GameController {

    def countryService
    Random random

    /**
     * Action for the menu. Sends the view a map of all properties with each property id as key.
     * @return
     */
    def menu() {
        def props = countryService.getDBPProperties() + countryService.getFBProperties()
        props.sort({a, b ->
            a.name <=> b.name
        })
        [properties: props]
    }

    /**
     * Action for setting up the game. From the menu it receives all chosen properties and choose random five
     * properties. These five are sent to the view of the game.
     * @return
     */
    def game() {

        def parameter = [:]
        def props = []
        params.keySet().each {
            if(it.toString().startsWith("property-")){
                props << it.toString().minus("property-")
            } else if(it.equals("name") || it.equals("tutorial")){
                parameter[it] = params[it]
            }
        }

        if(props.size() < 5) {
            redirect(controller: "game", action: "menu")
            return
        }
        //setting up random seed
        if(!random) {
            random = new Random()
        }

        // draw five random properties
        def drawn = []
        for(int i = 0; i < 5; i++) {
            def pool = props.minus(drawn)
            int r = random.nextInt(pool.size())
            drawn << pool[r]
        }

        [p : drawn, userName: parameter["name"], tutorial: (parameter["tutorial"] != null)]
    }
}

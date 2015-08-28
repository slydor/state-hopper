class UrlMappings {

	static mappings = {

        "/game" (controller: "game", action: "game")
        "/menu" (controller: "game", action: "menu")
        "/charts" (controller: "game", action: "charts")

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/" (view: "/index")
        name index: "/" (view: "/index")
        "500"(view:'/error')
	}


}

import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    

    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }

        /// GET /hello/...
        builder.resource("hello", HelloController(view))

        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        builder.post("api", "createUser") { (request) -> ResponseRepresentable in
            guard let userName = request.data["username"]?.string,
                let password = request.data["password"]?.string,
                let email = request.data["email"]?.string else {
                    throw Abort.badRequest
            }
            
            let user = User(userName: userName, email: email, password: password)
            try user.save()
            
            
            return "okie!\n\nUser Info:\nName: \(user.userName)\nPassword: \(user.password)\nEmail: \(user.email)\nID: \(String(describing: user.id?.wrapped))"
        }
        //get list local users: try User.all()
        builder.get("api", "login") { (req) -> ResponseRepresentable in
            let username = req.data["username"]?.string
            let password = req.data["password"]?.string
            let dictUser = try User.all()
            for user in dictUser{
                if username == user.userName{
                    return "login success"
                }
            }
            return "login fail"
            
        }
        
        builder.get("loginPage") { (request) -> ResponseRepresentable in
            return try self.view.make("loginPage")
        }
        
        builder.group("api") { (route) in
            route.resource("loginUser", LoginController())
        }
    }
}

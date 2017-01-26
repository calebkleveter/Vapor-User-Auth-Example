import Vapor
import VaporPostgreSQL
import Fluent
import Auth

final class User {
    var id: Node?
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.id = nil
        self.username = username
        self.password = password
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        password = try node.extract("password")
    }
}

extension User: Model {
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "password": password
            ])
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users", closure: { (user) in
            user.id()
            user.string("username")
            user.string("password")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

extension User: Auth.User {}
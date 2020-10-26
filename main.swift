import Kitura
import Cocoa

let router = Router()

router.all("/PersonService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}

router.post("/testPost"){
    request, response, next in
    print("Hitting the restPost service ...")
    let body = request.body
    if let jsonObj = body?.asJSON {
        if let jDict = jsonObj as? [String : String] {
            if let fn = jDict["FirstName"] {
                print("The input First Name : \(fn)")
                if let ln = jDict["LastName"] {
                    print("The input Last Name : \(ln)")
                }
            }
        }
        
    }
    response.send("Hello! Welcome to visit the /testPost service. ")
    next()
}


router.get("PersonService/getAll"){
    request, response, next in
    let pList = PersonDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray 
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()
}

router.post("PersonService/add") {
    request, response, next in
    // JSON deserialization on Kitura server 
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let fn = jDict["firstName"],let ln = jDict["lastName"],let n = jDict["ssn"] {
            let pObj = Person(fn:fn, ln:ln, n:n)
            PersonDao().addPerson(pObj: pObj)
        }
    }
    response.send("The Person record was successfully inserted (via POST Method).")
    next()
}
router.get("/PersonService/add") {
    request, response, next in
    let fn = request.queryParameters["FirstName"]
    let ln = request.queryParameters["LastName"]
    //
    // let n = ....
    // if n != nil {
    // ... }
    if let n = request.queryParameters["SSN"] {
        let pObj = Person(fn:fn, ln:ln, n:n)
        PersonDao().addPerson(pObj: pObj)
        response.send("The Person record was successfully inserted.")
    } else {
        
    }
    next() 
}
router.post("ClaimService/add"){
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String]{
        if let idn = jDict ["id"], let tit = jDict["title"], let dat = jDict["date"], let sol = jDict["isSolved"]{
            let jObj = Claim(id:id, tit:tit, date:date, sol:sol)
            Service.addClaim(pObj: pObj)
        }
    }
}
router.get("/ClaimService/add") {
    request, response, next in
    let idn = request.queryParameters["id"]
    let tit = request.queryParameters["title"]
    let dat = request.queryParameters["date"]
    let sol = request.queryParameters["isSolved"]
    
    if let idn = request.queryParameters["id"] {
        let pObj = Claim(id: id, tit: tit, dat: dat, sol:sol)
        Service().addClaim(pObj: pObj)
        response.send("The Claim record was successfully inserted.")
    } else {
        
    }
    next()
}
Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()


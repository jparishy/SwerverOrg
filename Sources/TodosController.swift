//
//  TodosController.swift
//  Swerver
//
//  Created by Julius Parishy on 12/11/15.
//  Copyright © 2015 Julius Parishy. All rights reserved.
//

import Foundation
import Swerver

class TodosController : Controller {
    override func index(request: Request, parameters: Parameters, session: Session, transaction t: Transaction?) throws -> ControllerResponse {
        let query = try ModelQuery<Todo>(transaction: t)
        let all = try query.all()

        let todos: [JSONEncodable] = try all.map {
            model in
            return try JSONDictionaryFromModel(model)
        }

        let data = try NSJSONSerialization.swerver_dataWithJSONObject(todos, options: NSJSONWritingOptions(rawValue: 0))
        return ControllerResponse(.Ok, headers: ["Content-Type" : "application/json"], responseData: ResponseData(data))
    }
    
    override func create(request: Request, parameters: Parameters, session: Session, transaction t: Transaction?) throws -> ControllerResponse {
        let query = try ModelQuery<Todo>(transaction: t)
        
        let model: Todo = try ModelFromJSONDictionary(parameters.bridge())
        let created = try query.insert(model)

        return try ControllerResponse(Ok.JSON(created))
    }
    
    override func update(request: Request, parameters: Parameters, session: Session, transaction t: Transaction?) throws -> ControllerResponse {
        
        let query = try ModelQuery<Todo>(transaction: t)
        let model: Todo = try ModelFromJSONDictionary(parameters.bridge())
        let updated = try query.update(model)

        print(updated)
        
        return try ControllerResponse(Ok.JSON(updated))
    }
    
    override func delete(request: Request, parameters: Parameters, session: Session, transaction t: Transaction?) throws -> ControllerResponse {
   
        if let idStr = parameters["id"] as? NSString, id = Int(idStr.bridge()) {
            let query = try ModelQuery<Todo>(transaction: t)
            try query.delete(id)

            print(id)
            
            return builtin(.Ok)
        } else {
            let query = try ModelQuery<Todo>(transaction: t)
            let toDelete = try query.findWhere(["completed": true])
            
            for m in toDelete {
                try query.delete(Int(m.id))
            }
            
            return builtin(.Ok)
        }
    }
}

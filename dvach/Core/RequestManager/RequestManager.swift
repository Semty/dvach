//
//  RequestManager.swift
//  Receipt
//
//  Created by Kirill Solovyov on 24.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class RequestManager: IRequestManager {
    
    private let queue = DispatchQueue(label: "com.ruslantimchenko.requestQueue",
                                      qos: .utility,
                                      attributes: [.concurrent])
    
    // MARK: - IRequestManager
    
    func execute(_ request: BaseRequest, completion: @escaping (JSON?, Error?) -> Void) {
        let stringURL = request.baseURL
            + request.accessLevel
            + request.version
            + request.language
            + request.section
            + request.action
            + request.format
            + request.parameters.parametersString
        guard let url = URL(string: stringURL) else { return }
        
        do {
            let request = try URLRequest(url: url, method: .get, headers: request.headers)
            Alamofire.request(request).responseJSON(queue: queue) { response in
                if let data = response.data {
                    let json = JSON(data)
                    completion(json, nil)
                } else {
                    let error = NSError.defaultError(description: "EXECUTION ERROR")
                    completion(nil, error)
                }
            }
        } catch {
            fatalError("BAD EXECUTION")
        }
    }
    
    func loadModel<T: IRequest>(request: T, completion: @escaping (Result<T.Model>) -> Void) {
        execute(request) { json, _ in
            if let key = request.payloadKey,
                let json = json?.dictionary?[key],
                let model = T.Model.from(json: json) {
                completion(.success(model))
            } else if let json = json,
                let model = T.Model.from(json: json) {
                completion(.success(model))
            } else {
                completion(.failure(NSError.defaultError(description: "LOAD MODEL ERROR")))
            }
        }
    }
    
    func loadModels<T: IRequest>(request: T, completion: @escaping (Result<[T.Model]>) -> Void) {
        execute(request) { json, _ in
            if let key = request.payloadKey, let json = json?.dictionary?[key] {
                let models = json.arrayValue.compactMap(T.Model.from)
                completion(.success(models))
            } else if let json = json?.array {
                let models = json.compactMap(T.Model.from)
                completion(.success(models))
            } else {
                completion(.failure(NSError.defaultError(description: "LOAD MODELS ERROR")))
            }
        }
    }
}

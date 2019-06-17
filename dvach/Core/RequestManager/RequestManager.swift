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
    
    // MARK: - Queues
    
    private let userInteractiveQueue =
        DispatchQueue(label: "com.ruslantimchenko.userInteractiveRequestQueue",
                      qos: .userInteractive,
                      attributes: [.concurrent])
    
    private let userInitiatedQueue =
        DispatchQueue(label: "com.ruslantimchenko.userInitiatedRequestQueue",
                      qos: .userInitiated,
                      attributes: [.concurrent])
    
    private let utilityQueue =
        DispatchQueue(label: "com.ruslantimchenko.utilityRequestQueue",
                      qos: .utility,
                      attributes: [.concurrent])
    
    private let backgroundQueue =
        DispatchQueue(label: "com.ruslantimchenko.backgroundRequestQueue",
                      qos: .background,
                      attributes: [.concurrent])
    
    // MARK: - IRequestManager
    
    func execute(_ request: BaseRequest, qos: DispatchQoS,
                 completion: @escaping (JSON?, Error?) -> Void) {
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
            
            let queue: DispatchQueue
            
            switch qos {
            case .userInteractive:
                queue = userInteractiveQueue
            case .userInitiated:
                queue = userInitiatedQueue
            case .utility:
                queue = utilityQueue
            case .background:
                queue = backgroundQueue
            default:
                queue = userInitiatedQueue
            }
            
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
    
    func loadModel<T: IRequest>(request: T, qos: DispatchQoS,
                                completion: @escaping (Result<T.Model>) -> Void) {
        execute(request, qos: qos) { json, _ in
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
    
    func loadModels<T: IRequest>(request: T, qos: DispatchQoS,
                                 completion: @escaping (Result<[T.Model]>) -> Void) {
        execute(request, qos: qos) { json, _ in
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

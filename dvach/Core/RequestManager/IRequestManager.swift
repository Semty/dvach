//
//  IRequestManager.swift
//  Receipt
//
//  Created by Kirill Solovyov on 25.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol IRequestManager {
    
    /// Выполнение реквеста
    func execute(_ request: BaseRequest, qos: DispatchQoS, completion: @escaping (JSON?, Error?) -> Void)
    
    /// Загрузка модели
    func loadModel<T: IRequest>(request: T, qos: DispatchQoS, completion: @escaping (Result<T.Model>) -> Void)
    
    /// Загрузка моделей
    func loadModels<T: IRequest>(request: T, qos: DispatchQoS, completion: @escaping (Result<[T.Model]>) -> Void)
}

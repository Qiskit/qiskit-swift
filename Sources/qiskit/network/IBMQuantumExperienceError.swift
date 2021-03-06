// Copyright 2017 IBM RESEARCH. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================

import Foundation

/**
 Quantum Experience Exceptions
 */
public enum IBMQuantumExperienceError: LocalizedError, CustomStringConvertible {

    case invalidURL(url: String)
    case nullResponse(url: String)
    case invalidHTTPResponse(response: URLResponse)
    case httpError(httpStatus: Int, status: Int, code: String, msg: String)
    case resultError(status: Int, code: String, msg: String)
    case registerSizeError(msg: String)
    case nullResponseData(url: String)
    case invalidResponseData
    case invalidToken
    case missingJobId
    case missingExecutionId
    case missingStatus
    case timeout
    case missingBackend(backend: String)
    case errorBackend(backend: String)
    case errorSeed(backend: String)
    case errorSeedLength
    case missingBackends
    case badBackendError(backend: String)
    case invalidCredentials
    case userGroupError(user_group: String)
    case requestCancelled(error: Error)
    case errorLogin(message: String)
    case internalError(error: Error)

    public var errorDescription: String? {
        return self.description
    }
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return url
        case .nullResponse(let url):
            return url
        case .invalidHTTPResponse(let response):
            return response.description
        case .httpError(let httpStatus, let status, let code, let msg):
            return "Response status: \(httpStatus):\(status):\(code) \(msg)"
        case .resultError(let status, let code, let msg):
            return "Result error: \(status):\(code) \(msg)"
        case .registerSizeError(let msg):
            return msg
        case .nullResponseData(let url):
            return url
        case .invalidResponseData:
            return "Invalid response data"
        case .invalidToken:
            return "Invalid Token"
        case .missingJobId:
            return "Missing JobId"
        case .missingExecutionId:
            return "Missing ExecutionId"
        case .missingStatus:
            return "Missing Status"
        case .timeout:
            return "Timeout"
        case .missingBackend(let backend):
            return "Backend \(backend) does not exits in Quantum Experience."
        case .errorBackend(let backend):
            return "Backend \(backend) does not exits"
        case .errorSeed(let backend):
            return "No seed allowed in \(backend)"
        case .errorSeedLength:
            return "No seed allowed. Max 10 digits."
        case .missingBackends:
            return "Missing backends"
        case .badBackendError(let backend):
            return "Could not find backend '\(backend)' available."
        case .invalidCredentials:
            return "Not credentials valid"
        case .userGroupError(let user_group):
            return "User group doesnt exist \(user_group)"
        case .requestCancelled(let error):
            return "Request was cancelled: \(error.localizedDescription)"
        case .errorLogin(let message):
            return "Error during login: \(message)"
        case .internalError(let error):
            return error.localizedDescription
        }
    }
}

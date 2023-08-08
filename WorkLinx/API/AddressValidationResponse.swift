//
//  AddressValidationResponse.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-08-08.
//

import Foundation

struct AddressValidationResponse: Decodable {

    static var API_KEY = "AIzaSyCvWww2MFlGeSUjvrDx0oScitG0R73bYuw"

    struct Verdict: Decodable {
        let hasUnconfirmedComponents: Bool?
        let hasInferredComponents: Bool?
    }
    
    struct Address: Decodable {
        let formattedAddress: String
        let unconfirmedComponentTypes: [String]
    }
    
    struct Result: Decodable {
        let verdict: Verdict
        let address: Address
    }
    
    let result: Result
    
    // Validate address using API key
    static func validateAddress(address: String, completionHandler: @escaping (AddressValidationResponse?, Error?) -> Void) {
        let urlString = "https://addressvalidation.googleapis.com/v1:validateAddress?key=\(API_KEY)"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
        {
            "address": {
                "addressLines": ["\(address)"]
            }
        }
        """.data(using: .utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let errorDict = json?["error"] as? [String: Any],
                       let errorCode = errorDict["code"] as? Int,
                       let errorMessage = errorDict["message"] as? String {
                        let error = NSError(domain: "AddressValidationError", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completionHandler(nil, error)
                        return
                    }

                    if let result = json?["result"] as? [String: Any],
                       let address = result["address"] as? [String: Any],
                       let formattedAddress = address["formattedAddress"] as? String {
                       
                        let verdictDict = result["verdict"] as? [String: Any]
                        let hasUnconfirmedComponents = verdictDict?["hasUnconfirmedComponents"] as? Bool
                        let hasInferredComponents = verdictDict?["hasInferredComponents"] as? Bool

                        if let unconfirmedComponentTypes = address["unconfirmedComponentTypes"] as? [String],
                           let hasUnconfirmed = hasUnconfirmedComponents, hasUnconfirmed {
                            var errorMessage = "The address contains unconfirmed components:\n"
                            errorMessage += unconfirmedComponentTypes.joined(separator: ", ")
                            
                            // Call the completion handler with the error message
                            completionHandler(nil, NSError(domain: "AddressValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                            return
                        }

                        let response = AddressValidationResponse(result:
                            AddressValidationResponse.Result(
                                verdict: AddressValidationResponse.Verdict(
                                    hasUnconfirmedComponents: hasUnconfirmedComponents,
                                    hasInferredComponents: hasInferredComponents),
                                
                                address: AddressValidationResponse.Address(
                                    formattedAddress: formattedAddress,
                                    unconfirmedComponentTypes: []
                                )
                            )
                        )
                        
                        completionHandler(response, nil)
                    } else {
                        let error = NSError(domain: "AddressValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                        completionHandler(nil, error)
                    }
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
}

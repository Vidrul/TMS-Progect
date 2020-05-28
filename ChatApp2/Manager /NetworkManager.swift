import Foundation

enum NetworkError: Error {
    case defauldError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func performRequst(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    error == nil else {
                        completion(Result.failure(NetworkError.defauldError))
                        return
                }
                completion(Result.success(data))
            }
        }
        task.resume()
    }
    
    
    

}

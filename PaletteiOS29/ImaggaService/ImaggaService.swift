//
//  ImaggaService.swift
//  PaletteiOS29
//
//  Created by Darin Armstrong on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class ImaggaService{
    
    //MARK: - Properties
    static let shared = ImaggaService()
    private init() {}
    
    static let baseURLPath = "http://api.imagga.com/v2"
    //TODO: - Input API Key
    static let authenticationToken = "Basic YWNjXzYxODAyY2JiMzVmODAyYzpjNDM1NDA0N2YxYWY1ODFkNTA5NjM1YjMzYWNlYTAyOQ=="
    
    func fetchColorsFor(imagePath: String, attempts: Int =  0, completion: @escaping ([UIColor]?) -> Void){
        guard let url = URL(string: ImaggaService.baseURLPath)?.appendingPathComponent("colors") else { completion(nil) ; return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "image_url", value: imagePath)]
        guard let finalUrl = components?.url else { completion(nil) ; return }
        var request = URLRequest(url: finalUrl)
        request.addValue(ImaggaService.authenticationToken, forHTTPHeaderField: "Authorization")
        print(request.url?.absoluteString ?? "Nope")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                return
            }
            guard let data = data else {completion(nil) ; return}
            do{
                let decoder = JSONDecoder()
                let imaggaColorResponse = try decoder.decode(ImaggaColorResponse.self, from: data)
                let imaggaColors = imaggaColorResponse.result.colors.imaggaColors
                let colors = imaggaColors.compactMap{ UIColor($0) }
                completion(colors)
            }catch {
                if attempts < 2 {
                    return self.fetchColorsFor(imagePath: imagePath, attempts: attempts + 1, completion: completion)
                }
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
            }.resume()
    }
}

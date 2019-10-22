//
//  UnsplashService.swift
//  PaletteiOS29
//
//  Created by Darin Armstrong on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation
import UIKit.UIImage

class UnsplashService {
    
    static let shared = UnsplashService()
    
    func fetchFromUnsplash(for unsplashRoute: UnsplashRoute, completion: @escaping ([UnsplashPhoto]?) -> Void){
        guard let url = unsplashRoute.fullUrl else { return }
        print(url.absoluteString)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            do {
                var unsplashPhotos: [UnsplashPhoto]!
                if unsplashRoute == .doubleRainbow {
                    let photoSearchDictionary = try JSONDecoder().decode(PhotoSearchDictionary.self, from: data)
                    unsplashPhotos = photoSearchDictionary.results
                }else {
                    unsplashPhotos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                }
                completion(unsplashPhotos)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchImage(for unsplashPhoto: UnsplashPhoto, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: unsplashPhoto.urls.small) else { completion(nil) ; return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil) ; return}
            completion(UIImage(data: data))
            }.resume()
    }
}

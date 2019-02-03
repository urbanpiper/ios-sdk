//
//  PlacesSearchDataModel.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 09/04/18.
//  Copyright © 2018 UrbanPiper Inc. All rights reserved.
//

import UIKit

@objc public protocol PlacesSearchDataModelDelegate {
    
    func refreshPlacesSearchUI(_ isRefreshing: Bool)
    func handlePlacesSearch(error: UPError?)
    
}

@objc public protocol PlacesCellDelegate {
    func configureCell(_ placeObject: Prediction?, extras: Extras?)
}

public struct PlacesSearchUserDefaultKeys {
    static let selectedPlacesDataKey: String = "SelectedPlacesDataKey"
}

open class PlacesSearchDataModel: UrbanPiperDataModel {
    
    public typealias CoordinatesFetchCompletionBlock = (PlaceDetailsResponse? ,UPError?) -> Void

    weak public var dataModelDelegate: PlacesSearchDataModelDelegate?

    public var lastSearchKeyword: String = ""

    private var keyword: String = ""

    public var placesResponse: GooglePlacesResponse? = {
        return PlacesSearchDataModel.recentSearcesResponse
        }(){
        didSet {
            tableView?.reloadData()
            collectionView?.reloadData()
        }
    }
    
    public var placesPredictionList: [Prediction]? {
        return placesResponse?.predictions
    }
    
    private static var recentSearcesResponse: GooglePlacesResponse? {
        guard let selectedPlacesData: Data = UserDefaults.standard.object(forKey: PlacesSearchUserDefaultKeys.selectedPlacesDataKey) as? Data else { return nil }
        StructuredFormatting.registerClassNameWhiteLabel()
        StructuredFormatting.registerClassNameUrbanPiperSDK()
        MatchedSubstring.registerClassNameWhiteLabel()
        MatchedSubstring.registerClassNameUrbanPiperSDK()
        Term.registerClassNameWhiteLabel()
        Term.registerClassNameUrbanPiperSDK()
        
        Prediction.registerClassName()
        
        guard let selectedPlacesArray: [Prediction] = NSKeyedUnarchiver.unarchiveObject(with: selectedPlacesData) as? [Prediction] else { return nil }
        let response: GooglePlacesResponse = GooglePlacesResponse(fromDictionary: [:])
        response.predictions = selectedPlacesArray
        return response
    }
    
    public func refreshData(_ isForcedRefresh: Bool = false) {
        fetchPlaces(for: keyword)
    }
    
    public func fetchPlaces(for keyword: String = "") {
        for task in dataTasks {
            task.value?.cancel()
        }
        cleanDataTasksArray()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        guard keyword.count > 2 else {
            lastSearchKeyword = ""
            placesResponse = PlacesSearchDataModel.recentSearcesResponse
            dataModelDelegate?.refreshPlacesSearchUI(false)
            return
        }
        
        perform(#selector(searchPlaces(for:)), with: keyword, afterDelay: 1.0)
    }
    
    @objc private func searchPlaces(for keyword: String) {
        dataModelDelegate?.refreshPlacesSearchUI(true)
        lastSearchKeyword = keyword
        let dataTask: URLSessionDataTask = APIManager.shared.fetchPlaces(for: keyword,
                                                            completion: { [weak self] (data) in
                                                                defer {
                                                                    self?.dataModelDelegate?.refreshPlacesSearchUI(false)
                                                                }
                                                                guard let response = data else { return }
                                                                self?.placesResponse = response
            }, failure: { [weak self] (upError) in
                defer {
                    self?.dataModelDelegate?.handlePlacesSearch(error: upError)
                }
                self?.lastSearchKeyword = ""
                self?.keyword = keyword
        })
        
        addDataTask(dataTask: dataTask)
    }
    
    public func fetchLocation(for prediction: Prediction, completion: @escaping CoordinatesFetchCompletionBlock) {
        store(prediction: prediction)
        let dataTask: URLSessionDataTask = APIManager.shared.fetchCoordinates(from: prediction.placeId,
                                                     completion: { (data) in
                                                        guard let response = data else {
                                                            completion(nil, nil)
                                                            return
                                                        }
                                                        completion(response, nil)
            }, failure: { (upError) in
                completion(nil, upError)
        })
        
        addDataTask(dataTask: dataTask)
    }

    private func store(prediction: Prediction) {
        var selectedPlacesArray: [Prediction]

        if let selectedPlacesData: Data = UserDefaults.standard.object(forKey: PlacesSearchUserDefaultKeys.selectedPlacesDataKey) as? Data {
            if let predictionsArray: [Prediction] = NSKeyedUnarchiver.unarchiveObject(with: selectedPlacesData) as? [Prediction] {
                selectedPlacesArray = predictionsArray
            } else {
                selectedPlacesArray = [Prediction]()
            }
        }else {
            selectedPlacesArray = [Prediction]()
        }

        selectedPlacesArray = selectedPlacesArray.filter { $0.placeId != prediction.placeId}
        selectedPlacesArray.insert(prediction, at: 0)
        
        let predictionsArrayData = NSKeyedArchiver.archivedData(withRootObject: selectedPlacesArray)
        
        UserDefaults.standard.set(predictionsArrayData, forKey: PlacesSearchUserDefaultKeys.selectedPlacesDataKey)
    }
}

//  MARK: UITableView DataSource
extension PlacesSearchDataModel {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesPredictionList?.count ?? 0
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier!, for: indexPath)
        
        if let placesCell: PlacesCellDelegate = cell as? PlacesCellDelegate {
            placesCell.configureCell(placesPredictionList?[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to PlacesCellDelegate protocol")
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }

}

//  MARK: UICollectionView DataSource

extension PlacesSearchDataModel {
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesPredictionList?.count ?? 0
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier!, for: indexPath)
        
        if let placesCell: PlacesCellDelegate = cell as? PlacesCellDelegate {
            placesCell.configureCell(placesPredictionList?[indexPath.row], extras: extras)
        } else {
            assert(false, "Cell does not conform to PlacesCellDelegate protocol")
        }
        
        return cell
    }
    
}

//  App State Management

extension PlacesSearchDataModel {
    
    @objc open override func appWillEnterForeground() {
        guard keyword.count > 0 else { return }
        refreshData(false)
    }
    
    @objc open override func appDidEnterBackground() {
    }
    
}

//  Reachability

extension PlacesSearchDataModel {
    
    @objc open override func networkIsAvailable() {
        guard keyword.count > 0 else { return }
        refreshData(false)
    }
    
}

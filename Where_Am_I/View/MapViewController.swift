//
//  MapViewController.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit
import MapKit
import SnapKit

final class MapViewController : UIViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        
        
        view.backgroundColor = .white
        navigationItem.title = "Where Am I?"
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    
}

//
//  URLSessionViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import UIKit
import SkeletonView

class URLSessionViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewmodel = URLSessionViewModel()
    
    var dataItem: [PlaceholderItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindByRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hideNavigationBar()
    }
    

    func hideNavigationBar(){
      self.navigationController?.isToolbarHidden = true
      self.navigationController?.isNavigationBarHidden = true
      self.navigationController?.navigationBar.isTranslucent = false
      self.navigationController?.isNavigationBarHidden = true
      self.hidesBottomBarWhenPushed = false
    }
    
    func bindByRx() {
        viewmodel.placeholderData
            .asObservable()
            .subscribe(onNext: { [weak self] dataItem in
                guard let self = self else { return }
                guard let dataItem = dataItem else { return }
                self.dataItem = dataItem
            }).disposed(by: disposeBag)
        
        viewmodel.loadingState.asObservable().subscribe(onNext: { [weak self] loading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch loading {
                case .loading:
                    print("loading")
                    self.tableView.showAnimatedGradientSkeleton()
                case .failed:
                    print("gagal request")
                    self.tableView.hideSkeleton()
                case .finished:
                    print("selesai request")
                    self.tableView.hideSkeleton()
                default:
                    break
                }
            }
            
        }).disposed(by: disposeBag)
        
        viewmodel.errorData.asObservable().subscribe(onNext: { [weak self] err in
            guard let self = self else { return }
            self.showCustomPopUp(PopUpModel(title: "error",
                                            description: "\(String(describing: err?.localizedDescription))",
                                            image: "ads1"))
            
        }).disposed(by: disposeBag)
        
    }
    
    func bindingByClosure() {
        viewmodel.onUpdateItem = { [weak self] dataItem in
            guard let self = self else { return }
            guard let dataItem = dataItem else { return }
            self.dataItem = dataItem
        }
        
        viewmodel.onLoading = { [weak self] loading in
            guard let self = self else { return }
            guard let loading = loading else { return }
            DispatchQueue.main.async {
                switch loading {
                case .loading:
                    print("loading")
                    self.tableView.showAnimatedGradientSkeleton()
                case .failed:
                    print("gagal request")
                    self.tableView.hideSkeleton()
                case .finished:
                    print("selesai request")
                    self.tableView.hideSkeleton()
                default:
                    break
                }
            }
        }
        
        viewmodel.onError = { [weak self] err in
            guard let self = self else { return }
            self.showCustomPopUp(PopUpModel(title: "error",
                                            description: "\(String(describing: err?.localizedDescription))",
                                            image: "ads1"))
        }
        
        viewmodel.requestData()
        
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ItemPlaceholderTableViewCell.self)
    }
    
    /*func requestData(url: URL) async throws -> Data {
     let (data, _) = try await URLSession.shared.data(from: url)
     return data
     }
     
     func fetchRequest() {
     Task {
     do {
     if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
     let result = try await requestData(url: url)
     print("data berhasil di dapat \(result)")
     
     // Decode JSON data menjadi struct Todo
     let todo = try JSONDecoder().decode([PlaceholderItem].self, from: result)
     self.dataItem = todo
     }
     } catch let e {
     print("error \(e)")
     }
     }
     }*/
    
}

extension URLSessionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ItemPlaceholderTableViewCell
        cell.configureData(item: dataItem[indexPath.row])
        return cell
    }
    
    
}

extension URLSessionViewController: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ItemPlaceholderTableViewCell"
    }
}

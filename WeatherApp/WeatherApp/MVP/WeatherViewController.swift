//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import SnapKit

final class WeatherViewController: UIViewController {
    
   private let cellID = "cell"
    
    //MARK:- UI элементы
    private lazy var table: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.delegate = self
        table.dataSource = self
        table.register(CurrentCityCell.self, forCellReuseIdentifier: cellID)
        return table
    }()
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.showsCancelButton = true
        bar.placeholder = "Найти город..."
        return bar
    }()
    
    var cities = Cities()
    private var presenter: WeatherPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherPresenter()
        
        setupUI()
        
        getWeather()
    }
    //MARK:- настройка UI элементов
    private func setupUI() {
        view.backgroundColor = .white
        title = Constants.appTitle
        [table,searchBar].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview()
        }
        
        table.snp.makeConstraints { maker in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    //MARK:- получение данных
   private func getWeather() {
        cities.startCities.forEach { city in
            presenter?.fetchData(city: city) { [weak self] weather, error in
                guard let self = self else { return }
                if error != nil {
                    self.showAlert(title: Constants.error, message: Constants.badNetwork)
                }
                guard let weather = weather else { return }
                self.cities.addWeather(for: city, weather: weather)
                self.table.isHidden = false
                self.table.reloadData()
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CurrentCityCell else { return UITableViewCell() }
        
        let city = cities.startCities[indexPath.row]
        if let weather = cities.weatherForCity[city] {
            cell.confiugre(with: city, weather: weather)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        let city = cities.startCities[indexPath.row]
        if let weather = cities.weatherForCity[city] {
            vc.configure(for: city, with: weather)
        }
        presenter?.open(vc: vc, navigation: navigationController!)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 100
        return cellHeight
    }
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    //MARK:- Поиск нового города
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = DetailViewController()
        guard let searchedCity = searchBar.text else { return }
        presenter?.fetchData(city: searchedCity, completion: { [weak self] weather, error in
            if error != nil {
                self?.showAlert(title: Constants.error, message: Constants.notFound)
            }
            guard let self = self,
                   let weather = weather else { return }
            self.cities.add(city: searchedCity)
            self.cities.addWeather(for: searchedCity, weather: weather)
            vc.configure(for: searchedCity, with: weather)
            self.table.reloadData()
            self.presenter?.open(vc: vc, navigation: self.navigationController!)
        })
    }
}


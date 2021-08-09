//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    private let cellID = "cell"
    
    //MARK: - UI элементы
    lazy var table: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.delegate = self
        table.dataSource = self
        table.keyboardDismissMode = .onDrag
        table.register(CurrentCityCell.self, forCellReuseIdentifier: cellID)
        return table
    }()
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.showsCancelButton = false
        bar.placeholder = "Найти город..."
        return bar
    }()
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .blue
        return indicator
    }()
    
    private var presenter: WeatherPresenterProtocol?
    private var isSearching: Bool {
        guard let text = searchBar.text else { return false }
        return searchBar.isFirstResponder && !text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherPresenter()
        
        setupUI()
        
        getWeather()
        
    }
    //MARK: - настройка UI элементов
    private func setupUI() {
        
        view.backgroundColor = .white
        title = Constants.appTitle.rawValue
        [table,searchBar, indicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            table.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    //MARK: - получение данных
    private func getWeather() {
        indicator.startAnimating()
        Cities.shared.startCities.forEach { city in
            presenter?.fetchData(city: city) { [weak self] weather, error in
                guard let self = self else { return }
                if error != nil {
                    self.showAlert(title: Constants.error.rawValue, message: Constants.badNetwork.rawValue)
                }
                guard let weather = weather else { return }
                Cities.shared.addWeather(for: city, weather: weather)
                self.table.isHidden = false
                self.indicator.stopAnimating()
                self.table.reloadData()
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? Cities.shared.filteredCities.count : Cities.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CurrentCityCell else { return UITableViewCell() }
        
        let city = isSearching ? Cities.shared.filteredCities[indexPath.row] : Cities.shared.startCities[indexPath.row]
        if let weather = Cities.shared.weatherForCity[city] {
            cell.confiugre(with: city, weather: weather)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        let city = isSearching ? Cities.shared.filteredCities[indexPath.row] : Cities.shared.startCities[indexPath.row]
        if let weather = Cities.shared.weatherForCity[city] {
            vc.city = city
            vc.weather = weather
        }
        presenter?.open(vc, with: navigationController!)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let text = searchBar.text else { return false }
        return !text.isEmpty ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cities.shared.remove(at: indexPath.row)
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
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        table.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    //MARK: - поиск на соответствие в массиве уже имеющихся городов
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        Cities.shared.filteredCities = Cities.shared.startCities.filter { $0.contains(text) }
        table.reloadData()
    }
    //MARK: - Поиск нового города
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        let vc = DetailViewController()
        guard let searchedCity = searchBar.text?.capitalized else { return }
        presenter?.fetchData(city: searchedCity, completion: { [weak self] weather, error in
            if error != nil {
                self?.showAlert(title: Constants.error.rawValue, message: Constants.notFound.rawValue)
            }
            guard let self = self,
                  let weather = weather else { return }
            vc.city = searchedCity
            vc.weather = weather
            self.presenter?.open(vc, with: self.navigationController!)
        })
    }
}


//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Entin on 05.08.2021.
//

import SnapKit

final class WeatherViewController: UIViewController {
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "Найти город..."
        return bar
    }()
    
    var cities = Cities()
    private let presenter = WeatherPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        //presenter.delegate = self
        setupUI()
        
        getWeather()
    }
    
    private func setupUI() {
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
    func getWeather() {
        cities.startCities.forEach { city in
            presenter.fetchData(city: city) { weather, error in
                guard let weather = weather else { return }
                self.cities.addWeather(for: city, weather: weather)
                print(weather)
                self.table.reloadData()
            }
        }
    }
}

//extension WeatherViewController: WeatherDelegate {
//
//    func getWeather(city: String, weather: Weather) {
//        presenter.fetchData { weather, error in
//
//        }
//       // presenter.cities.addWeather(for: city, weather: weather)
//    }
//
//
//
//    func showError(error: Error?) {
//
//    }
//
//
//}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = cities.startCities[indexPath.row]
        cell.textLabel?.text = cities.listOfCities[city]?.fact.condition
        return cell
    }
    
    
}

extension WeatherViewController: UISearchBarDelegate {
    
}


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
        table.register(CurrentCityCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "Найти город..."
        return bar
    }()
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(addCity(_:))
        button.image = .add
        return button
    }()
    
    var cities = Cities()
    private var presenter: WeatherPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherPresenter()
        
        view.backgroundColor = .green
        navigationItem.rightBarButtonItem = addButton
        setupUI()
        getWeather()
    }
    
    private func setupUI() {
        title = "Яндекс Погода"
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
    
    @objc private func addCity(_ sender: UIBarButtonItem) {
        guard let city = searchBar.text else { return }
        cities.add(city: city)
        getWeather()
    }
    
    func getWeather() {
        cities.startCities.forEach { city in
            presenter?.fetchData(city: city) { weather, error in
                if let error = error {
                    print(error.localizedDescription)
                    //show error alert
                }
                guard let weather = weather else { return }
                self.cities.addWeather(for: city, weather: weather)
                self.table.reloadData()
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CurrentCityCell else { return UITableViewCell() }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 100
        return cellHeight
    }
}

extension WeatherViewController: UISearchBarDelegate {
    
}


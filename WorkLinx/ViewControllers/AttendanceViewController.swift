import UIKit
import DGCharts

class AttendanceViewController: MenuBarViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Attendance")
        
        let navigationBar = CustomNavigationBar(title: "Attendance")
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userInfoView)
        
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let userIconImageView = UIImageView(image: UIImage(named: "UserIcon.png"))
        userIconImageView.contentMode = .scaleAspectFit
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userInfoView.addSubview(userIconImageView)
        
        NSLayoutConstraint.activate([
            userIconImageView.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 10),
            userIconImageView.centerXAnchor.constraint(equalTo: userInfoView.centerXAnchor),
            userIconImageView.widthAnchor.constraint(equalToConstant: 50),
            userIconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let userNameLabel = UILabel()
        userNameLabel.text = Utils.user.firstName + " " + Utils.user.lastName
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userInfoView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userIconImageView.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor)
        ])
        
        let positionLabel = UILabel()
        if let firstPosition = Utils.getPositionsData().first?.1.first {
            positionLabel.text = firstPosition
        } else {
            positionLabel.text = "Position Not Defined"
        }
        positionLabel.textAlignment = .center
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userInfoView.addSubview(positionLabel)
        
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            positionLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor),
            positionLabel.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor)
        ])
        
        let barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView)

        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 50),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barChartView.heightAnchor.constraint(equalToConstant: 500)
        ])

        let day = ["SUN", "MON", "TUE", "WED", "THU","FRI","SAT"]
        let attendanceData = [5, 3, 4, 0, 1, 3, 2]

        var barEntries: [BarChartDataEntry] = []
        for (index, value) in attendanceData.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: Double(value))
            barEntries.append(entry)
        }

        let dataSet = BarChartDataSet(entries: barEntries, label: Utils.workspace.name)
        dataSet.colors = [UIColor.lightBlue]

        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: day)
        barChartView.xAxis.labelCount = day.count
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        
        let chartTitleLabel = UILabel()
        chartTitleLabel.text = "Weekly Attendance"
        chartTitleLabel.textAlignment = .center
        chartTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        chartTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartTitleLabel)

        NSLayoutConstraint.activate([
            chartTitleLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 20),
            chartTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartTitleLabel.bottomAnchor.constraint(equalTo: barChartView.topAnchor, constant: -10)
        ])
    }
}

extension UIColor {
    static var lightBlue: UIColor {
        return UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
    }
}


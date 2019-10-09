import UIKit
import PlaygroundSupport
@testable import LithoUXComponents
@testable import FunNet
import Prelude
import MultiModelTableViewDataSource

struct Document: Codable {
    var id: Int?
    var title: String?
}

struct DocumentsResponse: Codable {
    var documents: [Document]?
}

class FunctionalItem: MultiModelTableViewDataSourceItem {
    var identifier: String = "cell"
    private let configureCell: (UITableViewCell) -> Void

    public init(_ configureCell: @escaping (UITableViewCell) -> Void) {
        self.configureCell = configureCell
    }

    open func cellIdentifier() -> String {
        return identifier
    }

    open func cellClass() -> UITableViewCell.Type {
        return UITableViewCell.self
    }

    open func configureCell(_ cell: UITableViewCell) {
        configureCell(cell)
    }
}

let json = """
{"documents":[{"id":1,"title":"Doc"}]}
"""
let jsonData = json.data(using: .utf8)
let parse: (Data) -> DocumentsResponse? = { try? THUXJsonProvider.jsonDecoder.decode(DocumentsResponse.self, from: $0) }
let unwrap: (DocumentsResponse?) -> [Document]? = { $0?.documents }
let buildConfigurator: (Document) -> (UITableViewCell) -> Void = { doc in return { $0.textLabel?.text = doc.title } }
let configuratorToItem: ((UITableViewCell) -> Void) -> MultiModelTableViewDataSourceItem = { (configurer: @escaping (UITableViewCell) -> Void) in FunctionalItem(configurer) }
let sectionsToDataSource: ([MultiModelTableViewDataSourceSection]?) -> MultiModelTableViewDataSource = { sections in
    let ds = MultiModelTableViewDataSource()
    ds.sections = sections
    return ds
}

let parseDocs = parse >>> unwrap
let buildConfigs: ([Document]) -> [(UITableViewCell) -> Void] = buildConfigurator >||> map
let configsToItems = configuratorToItem >||> map
let itemsToDataSource = MultiModelTableViewDataSourceSection.itemsToSection >>> arrayOfSingleObject >>> sectionsToDataSource
let pipeline: (Data) -> MultiModelTableViewDataSource = parseDocs >>> buildConfigs >>> configsToItems >>> itemsToDataSource

//func upper(s: String) -> String {
//    return s.uppercased()
//}
//let result = curry(map)(["hi", "hello"])(upper)

let ds = pipeline(jsonData!)

let tvc = UITableView()
tvc.dataSource = ds
ds.tableView = tvc

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true

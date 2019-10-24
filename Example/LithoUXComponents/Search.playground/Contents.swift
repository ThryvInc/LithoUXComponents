import UIKit
import PlaygroundSupport
@testable import LithoUXComponents
@testable import FunNet
import Prelude
import ReactiveSwift
import MultiModelTableViewDataSource
import LithoOperators

//Models ------------------------------------------------------------------------------------------------------
struct Emperor: Codable { var name: String? }
enum House: String, Codable, CaseIterable {
    case phoenix, dragon, lyorn, tiassa, hawk, dzur, issola, tsalmoth, vallista, jhereg, iorich, chreotha, yendi, orca, teckla, jhegaala, athyra
}
struct Reign: Codable {
    var house: House
    var emperors: [Emperor]?
}
struct Cycle: Codable {
    var ordinal: Int?
    var reigns = [Reign]()
}
let json = """
{ "ordinal": 18,
  "reigns":[{"house":"phoenix", "emperors": [{"name":"Zerika IV"}]},
            {"house":"dragon", "emperors": [{"name":"Norathar II"}]},
            {"house":"lyorn"},
            {"house":"tiassa"},
            {"house":"hawk", "emperors": [{"name":"??Paarfi I of Roundwood (the Wise)??"}]},
            {"house":"dzur"},
            {"house":"issola"},
            {"house":"tsalmoth"},
            {"house":"vallista"},
            {"house":"jhereg"},
            {"house":"iorich"},
            {"house":"chreotha"},
            {"house":"yendi"},
            {"house":"orca"},
            {"house":"teckla"},
            {"house":"jhegaala"},
            {"house":"athyra"}]
}
"""

// table view cell subclass -------------------------------------------------------------------------------------
class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//model manipulation functions -------------------------------------------------------------------------------------
let capitalizeFirstLetter: (String) -> String = { $0.prefix(1).uppercased() + $0.lowercased().dropFirst() }
let parseCycle: (Data) -> Cycle? = { try? THUXJsonProvider.jsonDecoder.decode(Cycle.self, from: $0) }
let houseToString: (House) -> String = { String(describing: $0) }
let reignToHouseString: (Reign) -> String = ^\Reign.house >>> houseToString >>> capitalizeFirstLetter


//model display functions -------------------------------------------------------------------------------------
let buildHouseConfigurator: (Reign) -> (UITableViewCell) -> Void = { reign in return { $0.textLabel?.text = reignToHouseString(reign) }}

//go from configuring functions to a table view data source ---------------------------------------------------
func configuratorToItem(configurer: @escaping (UITableViewCell) -> Void) -> MultiModelTableViewDataSourceItem { return FunctionalMultiModelTableViewDataSourceItem<DetailTableViewCell>(identifier: "cell", configurer) }
let configsToDataSource = configuratorToItem >||> map >>> itemsToSection >>> arrayOfSingleObject >>> sectionsToDataSource

//setup
let vc = THUXSearchViewController<THUXModelListViewModel<Reign>, Reign>(nibName: "THUXSearchViewController", bundle: Bundle(for: THUXSearchViewController<THUXModelListViewModel<Reign>, Reign>.self))

let call = ReactiveNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
vc.refreshableModelManager = THUXRefreshableNetworkCallManager(call)
vc.lastScreenYForAnimation = 96

//just for stubbing purposes
call.firingFunc = { $0.responder?.dataProperty.value = json.data(using: .utf8) }

let dataSignal = (call.responder?.dataSignal)!
let modelsSignal: Signal<[Reign], Never> = unwrappedModelSignal(from: dataSignal, ^\Cycle.reigns)
let onTap: () -> Void = {}

let searcher = THUXSearcher<Reign> { text, reign in
    guard let text = text, text != "" else {
        return true
    }
    return reignToHouseString(reign).prefix(text.count) == text
}
vc.searcher = searcher
vc.onSearch = { text in
    searcher.updateSearch(text: text)
}

let viewModel = THUXModelListViewModel(modelsSignal: Signal.merge(modelsSignal, searcher.filteredSignal(from: modelsSignal)), modelToItem: buildHouseConfigurator >>> configuratorToItem)
vc.viewModel = viewModel
vc.tableViewDelegate = THUXTappableTableDelegate(viewModel.dataSource)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true

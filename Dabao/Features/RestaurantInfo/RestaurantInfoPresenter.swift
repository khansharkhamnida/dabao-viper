import Foundation

@MainActor
final class RestaurantInfoPresenter: RestaurantInfoPresenterProtocol, RestaurantInfoInteractorOutputProtocol {

    weak var view: RestaurantInfoViewProtocol?
    private let interactor: RestaurantInfoInteractorInputProtocol
    private let router: RestaurantInfoRouterProtocol

    init(view: RestaurantInfoViewProtocol,
         interactor: RestaurantInfoInteractorInputProtocol,
         router: RestaurantInfoRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.loadFacts()
    }

    func didTapDone() {
        router.close()
    }

    func didLoadFacts(_ facts: RestaurantFacts) {
        // TODO 3: Tell the view the title, and the rows to show.
        // `view?` is optional: if the screen is gone, nothing happens (no crash).
        view?.showTitle(facts.name)
        view?.showRows(makeRows(from: facts))
    }

    func makeRows(from facts: RestaurantFacts) -> [InfoRowViewModel] {
        // TODO 4: Turn the facts into rows of text. The tests in
        // RestaurantInfoPresenterTests show some of the rows we expect, e.g.
        // "Status" / "Closed", and "Menu" / "6 dishes (1 sold out today)".
        // Singular vs plural: "1 dish" or "3 dishes".
        var menuText = facts.dishCount == 1 ? "1 dish" : "\(facts.dishCount) dishes"
        // Only mention sold-out dishes when there are some.
        if facts.soldOutCount > 0 {
            menuText += " (\(facts.soldOutCount) sold out today)"
        }

        // Each row is a title (left side) plus a value (right side).
        return [
            InfoRowViewModel(title: "Cuisine", value: facts.cuisine),
            // "%.1f" = one decimal place, so 4.6 stays "4.6" and 4 becomes "4.0".
            InfoRowViewModel(title: "Rating", value: "★ \(String(format: "%.1f", facts.rating))"),
            InfoRowViewModel(title: "Delivery", value: "\(facts.deliveryMinutes) min"),
            // Short if/else: true gives "Open now", false gives "Closed".
            InfoRowViewModel(title: "Status", value: facts.isOpen ? "Open now" : "Closed"),
            InfoRowViewModel(title: "Menu", value: menuText)
        ]
    }
}

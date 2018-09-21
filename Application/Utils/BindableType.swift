import Foundation

protocol BindableType {
    associatedtype ViewModel: ViewModelType

    var viewModel: ViewModel! { get }

    func bindInput() -> ViewModel.Input
    func bind(output: ViewModel.Output)
}

extension BindableType {

    func bindViewModel() {
        let input = bindInput()
        let output = viewModel.transform(input: input)
        bind(output: output)
    }
}

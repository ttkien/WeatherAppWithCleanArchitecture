import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class ViewUtils {

    public class func showLoadingIndicator(onView : UIView) -> UIView {
        let loadingView = UIView.init(frame: onView.bounds)
        loadingView.backgroundColor = onView.backgroundColor
        let activityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = loadingView.center
            loadingView.addSubview(activityIndicatorView)
            onView.addSubview(loadingView)
            loadingView.snp.updateConstraints({ (maker) in
                maker.edges.equalToSuperview()
            })

        return loadingView
    }

    public class func hideLoadingIndicator(loadingView :UIView?, animated: Bool) {
        if let loadingView = loadingView {
            let duration: TimeInterval = animated ? 0.25 : 0
            //swiftlint:disable multiple_closures_with_trailing_closure
            UIView.animate(withDuration: duration, animations: {
                loadingView.alpha = 0
            }) { (_) in
                DispatchQueue.main.async {
                    loadingView.removeFromSuperview()
                }
            }
        }
    }

    @discardableResult
    public class func showTapToRetry(onView: UIView, retryBlock:@escaping (UIView) -> Void ) -> UIView! {
        if let tapToRetryView = ViewUtils.findTapToRetryView(onView: onView) {
            return tapToRetryView
        }

        let nibName = String(describing: TapToRetryView.self)
        guard let tapToRetryView = (Bundle.main.loadNibNamed(nibName,
                                                             owner: nil,
                                                             options: nil)?.first as? TapToRetryView) else {
            return nil
        }

        onView.addSubview(tapToRetryView)
        tapToRetryView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        onView.layoutIfNeeded()

        let retryButtonTrigger = tapToRetryView.retryButton.rx.controlEvent(UIControlEvents.touchUpInside).map { _ in () }
        let tapGesutre = UITapGestureRecognizer()
        let tapTrigger = tapGesutre.rx.event.map { _ in () }
        _ = ControlEvent.merge([retryButtonTrigger, tapTrigger])
            .takeUntil(tapToRetryView.rx.deallocated)
            .subscribe(onNext: {[weak onView] (_) in

                guard let onView = onView else {
                    return
                }

                retryBlock(onView)
                removeTapToRetryView(onView: onView)

                }, onError: {[weak tapToRetryView]  (_) in
                    tapToRetryView?.removeFromSuperview()
                }, onCompleted: {[weak tapToRetryView]  in
                    tapToRetryView?.removeFromSuperview()
            })

        tapToRetryView.addGestureRecognizer(tapGesutre)

        return tapToRetryView
    }

    public class func removeTapToRetryView(onView: UIView) {
        onView.subviews.filter { (view) -> Bool in
            return view is TapToRetryView
            }.forEach { (tapToRetryView) in
                tapToRetryView.removeFromSuperview()
        }
    }

    private static func isTapToRetryViewExists(onView: UIView) -> Bool {
        return onView.subviews.filter { (view) -> Bool in
            return view is TapToRetryView
            }.isEmpty == false
    }

    private static func findTapToRetryView(onView: UIView) -> UIView? {
        return onView.subviews.filter { (view) -> Bool in
            return view is TapToRetryView
            }.first
    }
}

extension ViewUtils {

    @discardableResult
    public class func showDataNotFound(onView: UIView,
                                       mainTitle: String? = nil,
                                       subTitle: String? = nil,
                                       image: UIImage? = nil) -> UIView? {
        if let dataNotFoundView = ViewUtils.findDataNotFound(onView: onView) {
            return dataNotFoundView
        }

        let nibName = String(describing: DataNotFoundView.self)
        guard let dataNotFoundView = (Bundle.main.loadNibNamed(nibName,
                                                               owner: nil,
                                                               options: nil)?.first as? DataNotFoundView) else {
            return nil
        }

        onView.addSubview(dataNotFoundView)

        dataNotFoundView.frame.origin = CGPoint.zero
        dataNotFoundView.frame.size = onView.frame.size
        
        if let mainTitle = mainTitle {
            dataNotFoundView.showMainTitle(title: mainTitle)
        }
        
        if let subTitle = subTitle {
            dataNotFoundView.showSubTitle(title: subTitle)
        }
        
        if let image = image {
            dataNotFoundView.showIcon(image: image)
        }

        onView.layoutIfNeeded()
        return dataNotFoundView
    }

    public class func removeDataNotFoundView(onView: UIView) {
        onView.subviews.filter { (view) -> Bool in
            return view is DataNotFoundView
            }.forEach { (dataNotFoundView) in
                dataNotFoundView.removeFromSuperview()
        }
    }

    static private func isDataNotFoundViewExists(onView: UIView) -> Bool {
        return onView.subviews.filter { (view) -> Bool in
            return view is DataNotFoundView
            }.isEmpty == false
    }

    static private func findDataNotFound(onView: UIView) -> UIView? {
        return onView.subviews.filter { (view) -> Bool in
            return view is DataNotFoundView
            }.first
    }

}

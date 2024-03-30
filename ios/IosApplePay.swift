import Foundation
import PassKit
import UIKit

@objc(ApplePay)
class ApplePay: NSObject, PKPaymentAuthorizationControllerDelegate {

    var resolvePayment: RCTPromiseResolveBlock?
    var rejectPayment: RCTPromiseRejectBlock?

    @objc func makePayment(_ total: NSNumber, currencyCode: String, merchantId: String, countryCode: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      let request = PKPaymentRequest()
      request.merchantIdentifier = merchantId
      request.supportedNetworks = [.visa, .masterCard]
      request.merchantCapabilities = .capability3DS
      request.countryCode = countryCode
      request.currencyCode = currencyCode
      request.paymentSummaryItems = [
          PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: total.floatValue))
      ]

      let paymentController = PKPaymentAuthorizationController(paymentRequest: request)

      paymentController.delegate = self
      resolvePayment = resolve
      rejectPayment = reject

      paymentController.present(completion: { (presented: Bool) in
          if !presented {
                reject("PRESENT_ERROR", "Failed to present payment controller", nil)
          }
      })

    }

    @objc func canMakePayments(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments()
        resolve(canMakePayments)
    }
}


@available(iOS 10.0, *)
extension ApplePay: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        debugPrint("controller did authorize:", payment)

        let paymentData = String(data: payment.token.paymentData, encoding: .utf8)
        let paymentMethod = paymentMethodToString(payment.token.paymentMethod)
        let transactionIdentifier = payment.token.transactionIdentifier

        let paymentDetails: [String: Any?] = [
            "paymentData": paymentData,
            "paymentMethod": paymentMethod,
            "transactionIdentifier": transactionIdentifier
        ]

        resolvePayment?(paymentDetails)
        completion(PKPaymentAuthorizationStatus.success)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: {() in
            debugPrint("apple pay ui dismissed")
        })
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        debugPrint("controller did finish")
        controller.dismiss(animated: true, completion: nil)
    }

    func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        debugPrint("controller will authorize")
    }

        func paymentMethodToString(_ paymentMethod: PKPaymentMethod) -> [String: Any] {
        var result: [String: Any] = [:]

        if let displayName = paymentMethod.displayName {
            result["displayName"] = displayName
        }
        if let network = paymentMethod.network {
            result["network"] = network
        }
        let type = paymentMethodTypeToString(paymentMethod.type)
        result["type"] = type
    

        return result
    }

    func paymentMethodTypeToString(_ paymentMethodType: PKPaymentMethodType) -> String {
        let arr = ["unknown",
                   "debit",
                   "credit",
                   "prepaid",
                   "store"]
        return arr[Int(paymentMethodType.rawValue)]
    }
}

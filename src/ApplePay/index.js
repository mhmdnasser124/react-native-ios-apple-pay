import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ApplePaymentModule = NativeModules.ApplePay
  ? NativeModules.ApplePay
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const throwError = () => {
  throw new Error(`Apple Pay is for iOS only`);
};

const MockedObject = {
  setEnvironment: throwError,
  isReadyToPay: throwError,
  requestPayment: throwError,
  environments: {
    TEST: 0,
    PRODUCTION: 0,
  },
};

const ApplePayObj = Platform.OS === 'ios' ? ApplePaymentModule : MockedObject;

export async function initiateApplePayPayment(
  amount,
  currencyCode,
  merchantId,
  countryCode
) {
  const result = await ApplePayObj.makePayment(
    amount,
    currencyCode,
    merchantId,
    countryCode
  );
  return { ...result, paymentData: JSON.parse(result.paymentData) };
}

export function isApplePayAvailable() {
  return ApplePayObj.canMakePayments();
}

export const ApplePay = {
  initiateApplePayPayment,
  isApplePayAvailable,
};

export const useApplePay = () => {
  return { ...ApplePay };
};

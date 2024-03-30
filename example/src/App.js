import { Button } from 'react-native';
import React from 'react';
import { useApplePay } from 'react-native-ios-apple-pay';

const App = () => {
  const { initiateApplePayPayment, isApplePayAvailable } = useApplePay();

  const available = isApplePayAvailable();

  // Example usage:
  const handlePayment = async () => {
    const paymentResult = await initiateApplePayPayment();
    /* provide amount, currencyCode, merchantId, countryCode */
    // Handle payment result
  };

  return (
    <>
      <Button onPress={handlePayment} title="Make Payment" />
    </>
  );
};

export default App;
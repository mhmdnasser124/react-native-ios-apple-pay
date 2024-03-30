# rn-ios-apple-pay

Welcome to the easiest way to add Apple Pay to your React Native iOS app for smooth, secure payments.

## Installation

```sh
npm install rn-ios-apple-pay
```

```sh
yarn add rn-ios-apple-pay
```

## Demo

<img alt='demo-ios' src='https://i.ibb.co/GJYKkjq/apple-pay.gif' height="500" />

## Usage

```js
import React from 'react';
import { useApplePay } from 'rn-ios-apple-pay';

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
```

## Payment Result

```js

{
    "paymentData": {
        "data": "",
        "signature": "",
        "header": {
            "publicKeyHash": "",
            "ephemeralPublicKey": "",
            "transactionId": ""
        },
        "version": ""
    },
    "paymentMethod": {
        "displayName": "",
        "network": "",
        "type": ""
    },
    "transactionIdentifier": ""
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

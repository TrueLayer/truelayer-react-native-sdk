import React, { useState, useEffect } from "react";

import { StyleSheet, View, Text, Button, Linking, Alert } from 'react-native';
import TruelayerSDK from 'truelayer-react-native-sdk';
import uuid from 'react-native-uuid';
import axios from 'axios';

const useMount = func => useEffect(() => func(), []);

const config = {
  api: 'http://10.0.2.2:3000',
  paymentType: "eur", // [gbp, eur, preselected]
}

const getAPIUrl = (paymentType: string) => {
  switch(paymentType) {
    case 'gbp':
      return `${config.api}/v3/payment`;
    case 'eur':
      return `${config.api}/v3/payment/euro`;
    case 'preselected':
      return `${config.api}/v3/payment/provider`;
    default:
      return `${config.api}/v3/payment`;
  }
}

export default function App() {
  const [responseData, setResponseData] = React.useState('');

  useMount(() => {
    const getUrlAsync = async () => {
      // Get the deep link used to open the app
      const initialUrl = await Linking.getInitialURL();

      if(initialUrl)
        Alert.alert("Payment Status", `Redirect received: ${initialUrl}`, [{ text: "OK" }]);
    };

    getUrlAsync();
  });

  Linking.addEventListener('url', ({url}) => {
    if(url)
      Alert.alert("Payment Status", `Redirect received: ${url}`, [{ text: "OK" }]);
  })

  const createPayment = async () => {
    try {
      const res = await axios.post(`${getAPIUrl(config.paymentType)}`, {
        id: uuid.v4(),
      });

      const prefs = {
        preferredCountryCode: 'DE',
      };

      const paymentResult = await TruelayerSDK.startPayment(
        res.data.id,
        res.data.resource_token,
        'truelayer://react-native-example',
        prefs,
      );
      console.log(paymentResult);
      const {result, reason, step} = paymentResult.data;
      setResponseData(
        `SDK Result: ${result} Reason: ${reason} Step: ${step}`,
      );
    }
    catch(err) {
      console.error(err);
      Alert.alert("Error", err, [{ text: "OK" }]);
    }
  }

  return (
    <View style={styles.container}>
      <Button
        title={'Start Payment'}
        onPress={async () => { createPayment() }}/>
      <Text>{ responseData }</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
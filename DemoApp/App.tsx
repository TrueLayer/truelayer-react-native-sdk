import {
  Pressable,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import React from 'react';

import {Colors} from 'react-native/Libraries/NewAppScreen';

import {TrueLayerPaymentsSDKWrapper} from 'rtn-truelayer-payments-sdk/js/TrueLayerPaymentsSDKWrapper';

import {
  Environment,
  ProcessorResult,
  ProcessorResultType,
} from 'rtn-truelayer-payments-sdk/js/models/types';

import {PaymentUseCase} from 'rtn-truelayer-payments-sdk/js/models/payments/PaymentUseCase';

import uuid from 'react-native-uuid';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    flex: 1,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <View
        style={{
          flex: 1,
          justifyContent: 'center',
        }}>
        <Pressable
          style={styles.button}
          onPress={() => {
            TrueLayerPaymentsSDKWrapper.configure(Environment.Sandbox).then(
              _ => {
                console.log('Configure success');
              },
              reason => {
                console.log('Configure failed ' + reason);
              },
            );
            console.log('configureSDK button clicked');
          }}>
          <Text style={styles.text}> Start SDK </Text>
        </Pressable>
        <Pressable style={styles.button} onPress={() => processPayment()}>
          <Text style={styles.text}> Process Single Payment </Text>
        </Pressable>
        <Pressable style={styles.button} onPress={() => processMandate()}>
          <Text style={styles.text}> Process Mandate </Text>
        </Pressable>
      </View>
    </SafeAreaView>
  );
};

function processPayment() {
  getPaymentContext('payment').then(processorContext => {
    console.log(
      'id: ' +
        processorContext.id +
        ' token: ' +
        processorContext.resource_token,
    );
    TrueLayerPaymentsSDKWrapper.processPayment(
      {
        paymentId: processorContext.id,
        resourceToken: processorContext.resource_token,
        redirectUri: 'truelayer://payments_sample',
      },
      {
        preferredCountryCode: undefined,
        paymentUseCase: PaymentUseCase.Default,
      },
    ).then(result => {
      const processorRes = result as ProcessorResult;
      console.log(processorRes);
      switch (processorRes.type) {
        case ProcessorResultType.Success:
          console.log('Great success at step: ' + processorRes.step);
          break;
        case ProcessorResultType.Failure:
          console.log(
            "Oh we've failed with following reason: " + processorRes.reason,
          );
          break;
      }
    });
    console.log('processPayment button clicked');
  });
}

function processMandate() {
  getPaymentContext('mandate').then(processorContext => {
    console.log(
      'id: ' +
        processorContext.id +
        ' token: ' +
        processorContext.resource_token,
    );
    TrueLayerPaymentsSDKWrapper.processMandate(
      {
        mandateId: processorContext.id,
        resourceToken: processorContext.resource_token,
        redirectUri: 'truelayer://payments_sample',
      },
      {
        preferredCountryCode: undefined,
      },
    ).then(result => {
      const processorRes = result as ProcessorResult;
      console.log(processorRes);
      switch (processorRes.type) {
        case ProcessorResultType.Success:
          console.log('Great success at step: ' + processorRes.step);
          break;
        case ProcessorResultType.Failure:
          console.log(
            "Oh we've failed with following reason: " + processorRes.reason,
          );
          break;
      }
    });
    console.log('processMandate button clicked');
  });
}

interface SamplePaymentContext {
  id: string;
  resource_token: string;
}

/**
 * This one will fetch the token for mandate from the payments quickstart project
 * Amend the url to match your instance.
 */
async function getPaymentContext(
  type: 'mandate' | 'payment',
): Promise<SamplePaymentContext> {
  return await fetch('http://192.168.1.35:3000/v3/' + type, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id: uuid.v4(),
      amount_in_minor: '1',
      currency: 'GBP',
      payment_method: {
        statement_reference: 'some ref',
        type: 'bank_transfer',
      },
      beneficiary: {
        type: 'external_account',
        name: 'John Doe',
        reference: 'Test Ref',
        scheme_identifier: {
          type: 'sort_code_account_number',
          account_number: '12345677',
          sort_code: '123456',
        },
      },
    }),
  })
    .then(response => response.json())
    .then(json => {
      console.log(json);
      return json;
    })
    .catch(error => {
      console.error(error);
      return null;
    });
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    paddingVertical: 12,
    marginHorizontal: 32,
    marginBottom: 12,
    borderRadius: 4,
    backgroundColor: 'black',
  },
  text: {
    fontSize: 16,
    lineHeight: 21,
    fontWeight: 'bold',
    letterSpacing: 0.25,
    color: 'white',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;

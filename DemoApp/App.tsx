/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import {
  Pressable,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';

import RTNTrueLayerPaymentsSDK, {
  MandateContext,
  createProcessorPreferences,
  PaymentUseCase,
  ProcessorResult,
  ProcessorResultType,
} from 'rtn-truelayer-payments-sdk/js/NativeTrueLayerPaymentsSDK';

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
            const ret = RTNTrueLayerPaymentsSDK?.configureSDK();
            console.log(ret);
            console.log('configureSDK button clicked');
          }}>
          <Text style={styles.text}> Start SDK </Text>
        </Pressable>
        <Pressable style={styles.button}>
          <Text style={styles.text}> Process Single Payment </Text>
        </Pressable>
        <Pressable
          style={styles.button}
          onPress={() => getPaymentContext()
              .then( (processorContext) => {
              console.log('id: ' + processorContext.id + ' token: ' + processorContext.resource_token);
              const ret = RTNTrueLayerPaymentsSDK?.processMandate(
                {
                  mandateId: processorContext.id,
                  resourceToken: processorContext.resource_token,
                  redirectUri: 'truelayer://payments_sample',
                } as MandateContext,
                createProcessorPreferences(null, PaymentUseCase.Default),
              ).then(result => {
                const processorRes = result as ProcessorResult;
                console.log(processorRes);
                switch (processorRes.type) {
                  case ProcessorResultType.Success:
                    console.log('Great success at step: ' + processorRes.step);
                    break;
                  case ProcessorResultType.Failure:
                    console.log(
                      "Oh we've failed with following reaon: " +
                        processorRes.reason,
                    );
                    break;
                }
              });
              console.log(ret);
              console.log('processMandate button clicked');
            })
          }>
          <Text style={styles.text}> Process Mandate </Text>
        </Pressable>
      </View>
    </SafeAreaView>
  );
};

interface SamplePaymentContext {
  id: string,
  resource_token: string,
}

async function getPaymentContext(): Promise<SamplePaymentContext> {
  return await fetch('http://192.168.1.35:3000/v3/mandate', {
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

  // if (json != null) {
  //     const prefs = {
  //         preferredCountryCode: 'DE',
  //     };
  //     const {id, resource_token} = json;
  //     console.log('id: ' + id + ' token: ' + resource_token);
  //     const response2 = await TlPaymentSdkModule.startPayment(
  //         id,
  //         resource_token,
  //         'truelayer://payments_sample',
  //         prefs,
  //     );
  //     const {result, reason, step} = response2.data;
  //     setResponseData(
  //         'SDK result: ' + result + ' reason: ' + reason + ' step: ' + step,
  //     );
  //     console.log(responseData);
  // }
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

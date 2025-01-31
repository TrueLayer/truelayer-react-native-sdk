import { Text, View, StyleSheet } from 'react-native';
import { Image, Platform, Button, SafeAreaView,
  Linking,
  Alert } from 'react-native';
import {
  TrueLayerPaymentsSDKWrapper,
  Environment,
  ResultType,
} from 'rn-truelayer-payments-sdk';
import { log } from './utils/logger';

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Button
          title="Start SDK"
          onPress={() => {
            log('configure button clicked')

            TrueLayerPaymentsSDKWrapper.configure(
              Environment.Sandbox
            ).then(
              () => {
                log('Configure success')
              },
              reason => {
                log(
                  'Configure failed ' +
                    JSON.stringify(reason.userInfo, null, 4),
                )
              },
            )
          }}/>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1, 
    alignItems: 'center',
    justifyContent: 'center',
  },
});


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

import {
  Colors
} from 'react-native/Libraries/NewAppScreen';

import RTNTrueLayerPaymentsSDK from 'rtn-truelayer-payments-sdk/js/NativeTrueLayerPaymentsSDK';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    flex: 1
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
          justifyContent: 'center'
        }}>
        <Pressable style={styles.button}>
            <Text style={styles.text}> Start SDK </Text>
        </Pressable>
        <Pressable style={styles.button}>
            <Text style={styles.text}> Process Single Payment </Text>
        </Pressable>
        <Pressable style={styles.button} 
        onPress={()=> { 
          RTNTrueLayerPaymentsSDK?.configureSDK()
          console.log(RTNTrueLayerPaymentsSDK?.configureSDK())
          console.log("HI")
        }} >
            <Text style={styles.text}> Process Mandate </Text>
        </Pressable>
      </View>
    </SafeAreaView>
  );
};

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

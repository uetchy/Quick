import React from 'react'
import { StyleSheet, Text, View, Dimensions } from 'react-native'
import QRCode from 'react-native-qrcode'

export default class App extends React.Component {
  constructor() {
    super()
    this.content = 'test'
  }

  render() {
    const { height, width } = Dimensions.get('window')
    const qrSize = Math.min(height, width) - 40

    return (
      <View style={styles.container}>
        <QRCode value={this.content} size={qrSize} bgColor="black" fgColor="white" />
        <Text style={styles.previewText}>{this.content}</Text>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  previewText: {
    fontFamily: 'System',
    fontWeight: 'bold',
    fontSize: 16,
    marginTop: 20,
  },
})

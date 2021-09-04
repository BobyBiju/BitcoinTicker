
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:io' show Platform;
import 'dart:convert';
double bitcoinRate;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency='USD';

  DropdownButton<String> androidDropDown()
  {
    List<DropdownMenuItem<String>> dropdownItems=[];
    for(String currency in currenciesList){
      var newItem= DropdownMenuItem(
        child: Text(currency),
        value: currency,

      );
      dropdownItems.add(newItem);
    }

return DropdownButton<String>(
value: selectedCurrency,
items: dropdownItems,
onChanged: (value){
setState(() {
selectedCurrency=value;
getData(selectedCurrency);
});
}
,);
  }

  CupertinoPicker iosPicker(){

    List<Text> pickerItems=[];
    for(String currency in currenciesList)
    {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
        selectedCurrency=currenciesList[selectedIndex];
        getData(selectedCurrency);
      },
      children:
      pickerItems,

    );

  }

void getData( country) async{
    http.Response response =await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$country?apikey=B1E2AB8C-B039-4DA6-AB53-773AF24D223E'));
    String data=response.body;

    if(response.statusCode==200){
      print(data);
      setState(() {
        bitcoinRate=jsonDecode(data)['src_side_base'][0]['rate'];
        print(bitcoinRate);
      });

    }
    else{
      print(response.statusCode);
    }

}
@override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child:  Text(
                  '1 BTC = $bitcoinRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS?iosPicker():androidDropDown(),       ),
        ],
      ),
    );
  }
}
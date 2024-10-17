import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<dynamic> addresses = [];
  String selectedAddress = '';
  String selectedPayment = 'MasterCard';
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  // Fetch userId from SharedPreferences
  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId'); // Retrieve the userId
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      fetchAddresses(); // Fetch addresses after userId is available
    } else {
      // Handle case where userId is not available
      print('User ID not found in SharedPreferences');
    }
  }

  Future<void> fetchAddresses() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/address/listAddress?userId=$userId'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        if (data['data']['address'] != null) {
          setState(() {
            addresses = List.from(data['data']['address']);
          });
        } else {
          setState(() {
            addresses = []; 
          });
        }
      } else {
        print('Failed to load addresses');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Checkout'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context,'cart');
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipping Address Section
          Text(
            'Shipping To:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          addresses.isNotEmpty
              ?   Column(
                children: addresses.map((address) {
                  return RadioListTile(
                    title: Text('${address['reciever_name']}'),
                    subtitle: Text(
                      '${address['reciever_address']}\n${address['mobile_number']}',
                    ),
                    value: address['_id'], // Use a unique identifier
                    groupValue: selectedAddress,
                    onChanged: (value) {
                      setState(() {
                        selectedAddress = value.toString(); // Update the selected address
                      });
                    },
                  );
                }).toList(),
              )
              : addresses.isEmpty
                  ? CircularProgressIndicator() 
                  : Text('No addresses found. Please add one.'), 
          
          SizedBox(height: 20),
          Text(
            'Select Payment:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RadioListTile(
            title: Row(
              children: [
                Icon(Icons.account_balance_wallet),
                SizedBox(width: 10),
                Text('Wallet'),
              ],
            ),
            value: 'Wallet',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Row(
              children: [
                Icon(Icons.money),
                SizedBox(width: 10),
                Text('Cash On Delivery'),
              ],
            ),
            value: 'Cash On Delivery',
            groupValue: selectedPayment,
            onChanged: (value) {
              setState(() {
                selectedPayment = value.toString();
              });
            },
          ),
          
          SizedBox(height: 30),

          // Confirm Order Button
          Center(
            child: ElevatedButton(
              onPressed: (selectedAddress.isNotEmpty && selectedPayment.isNotEmpty)
                  ? () {
                      print('Selected Address: $selectedAddress');
                      print('Selected Payment: $selectedPayment');
                    }
                  : null, // Disable button if no selections
              child: Text('Confirm Order'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                backgroundColor: selectedAddress.isNotEmpty && selectedPayment.isNotEmpty
                    ? Colors.blue
                    : Colors.grey, // Disable button style if needed
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
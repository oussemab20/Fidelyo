import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final String cardID;

  PaymentScreen({required this.cardID});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController paymentController = TextEditingController();
  int cardValue = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCardValue();
  }

  Future<void> _fetchCardValue() async {
    try {
      // Fetch card data from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('cards')
          .doc(widget.cardID)
          .get();

      if (snapshot.exists) {
        var cardData = snapshot.data() as Map<String, dynamic>?;
        if (cardData != null && cardData.containsKey('value')) {
          setState(() {
            // Cast the value to double, then convert to int
            cardValue = (cardData['value'] as num).toInt() ?? 0;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Card data is missing the value field.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Card not found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching card data: $e';
        isLoading = false;
      });
    }
  }


  void _processPayment() async {
    int? paymentAmount = int.tryParse(paymentController.text);

    if (paymentAmount == null || paymentAmount <= 0) {
      _showError("Enter a valid amount.");
      return;
    }

    if (paymentAmount > cardValue) {
      _showError("Insufficient balance.");
      return;
    }

    // Deduct the amount and update Firestore
    int newValue = cardValue - paymentAmount;
    try {
      await FirebaseFirestore.instance
          .collection('cards')
          .doc(widget.cardID)
          .update({'value': newValue});

      setState(() {
        cardValue = newValue;
        paymentController.clear();
      });

      _showSuccess("Payment successful! New balance: \$${newValue}");
    } catch (e) {
      _showError("Error processing payment.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Screen")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCardValue, // Retry fetching data
              child: Text("Retry"),
            ),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Card ID: ${widget.cardID}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Available Balance: \$${cardValue}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: paymentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter payment amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment,
              child: Text("Make Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

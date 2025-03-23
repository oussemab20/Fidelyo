import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PaymentScreen.dart';




class QRCodeScannerPage extends StatefulWidget {
  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  bool isChecking = false;
  bool isNavigating = false;  // Flag to prevent multiple navigations

  void _onDetect(BarcodeCapture barcodeCapture) async {
    if (barcodeCapture.barcodes.isNotEmpty && !isChecking && !isNavigating) {
      setState(() => isChecking = true);

      String? cardID = barcodeCapture.barcodes.first.rawValue;
      if (cardID == null) {
        _showError("Invalid QR Code");
        setState(() => isChecking = false);  // Reset checking state
        return;
      }

      // Check if cardID exists in Firestore
      bool exists = await _checkCardExists(cardID);

      if (exists) {
        setState(() => isNavigating = true);  // Set navigating flag to true
        await Future.delayed(Duration(milliseconds: 200));  // Optional short delay
        _navigateToPayment(cardID);
      } else {
        _showError("Card not found!");
        setState(() => isChecking = false);  // Reset checking state
      }
    }
  }

  Future<bool> _checkCardExists(String cardID) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('cards').doc(cardID).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  void _navigateToPayment(String cardID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(cardID: cardID),
      ),
    ).then((_) {
      // After returning from the PaymentScreen, reset the navigation flag
      setState(() {
        isNavigating = false;
        isChecking = false;  // Reset checking state
      });
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() {
      isChecking = false;
      isNavigating = false;  // Reset navigation flag in case of an error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Code Scanner")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: _onDetect,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            isChecking
                ? CircularProgressIndicator()
                : Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black54,
              child: Text(
                "Scan a QR Code",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



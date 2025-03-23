import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidelyo/Components/logo.dart';
import 'package:fidelyo/Components/logo1.dart';
import 'package:fidelyo/notification_service.dart';
import 'package:flutter/material.dart';

class ClientDetails extends StatefulWidget {
  final String shopId;

  const ClientDetails({super.key, required this.shopId});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  List<String> userUids = [];
  Map<String, String> userNames = {}; // Store userUid -> userName map
  bool isLoading = true;

  // Fetch clients (userUids) and their names associated with the selected shop
  Future<void> getClients() async {
    try {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.shopId) // Get the specific shop by its ID
          .get();

      // Retrieve the Clients field (which is an array of userUids)
      if (shopDoc.exists) {
        var shopData = shopDoc.data() as Map<String, dynamic>;
        var clientsList = shopData['Clients'] as List<dynamic>;

        setState(() {
          userUids = clientsList.cast<String>(); // Store the userUids in a list
        });

        // Fetch each user's full name using their userUid
        for (var userUid in userUids) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userUid) // Fetch user document by their UID
              .get();

          if (userDoc.exists) {
            var userData = userDoc.data() as Map<String, dynamic>;
            setState(() {
              userNames[userUid] = userData['full_name'] ?? 'Unnamed User'; // Use full_name
            });
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shop not found")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch clients: $e")),
      );
    }
  }

  Future<void> addGiftPoints(String cardID, int value, String userUID, String shopName) async {
    try {
      DocumentReference cardRef = FirebaseFirestore.instance.collection('cards').doc(cardID);
      DocumentSnapshot cardSnapshot = await cardRef.get();

      if (cardSnapshot.exists) {
        int currentPoints = cardSnapshot['points'] ?? 0;
        int updatedPoints = currentPoints + value;

        await cardRef.update({'points': updatedPoints});

        // Send notification to user
        await NotificationService.notifyUser(
          userUID: userUID,
          shopName: shopName,
          message: "You received $value points from $shopName!",
        );

        print("Points updated and notification sent!");
      } else {
        print("Card not found");
      }
    } catch (e) {
      print("Error updating points: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    getClients(); // Fetch the clients (userUids) when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clients",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.purple, // Purple text color
          ),
        ),
        centerTitle:true,
        backgroundColor: Colors.white, // Replace with your desired hex color value
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userUids.isEmpty
          ? const Center(child: Text("No clients found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          CustomLogo1(),
          SizedBox(height: 30,),
          Column(
            children:

            userUids.map((userUid) {
              String userName = userNames[userUid] ?? 'Loading...';
              return GestureDetector(
                onTap: () async {
                  try {
                    // Query the cards collection to find the card for this shop and user
                    QuerySnapshot cardSnapshot = await FirebaseFirestore.instance
                        .collection('cards')
                        .where('shopUID', isEqualTo: widget.shopId)
                        .where('userUID', isEqualTo: userUid)
                        .get();

                    if (cardSnapshot.docs.isNotEmpty) {
                      var cardData = cardSnapshot.docs.first.data() as Map<String, dynamic>;

                      // Extract the card values and points
                      String values = cardData['values'] ?? "0";
                      int points = cardData['points'] ?? 0;

                      // Show the bottom sheet with the card details
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Values Box
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9A33E8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Values",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        values,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Points Box
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9A33E8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Points",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "$points",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Send Gift Button
                                ElevatedButton(
                                  onPressed: () async {
                                    // Dismiss the keyboard (if it's visible)
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    // Show a dialog to ask for the number of points
                                    showDialog<int>(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController pointsController = TextEditingController();

                                        return AlertDialog(
                                          title: const Text("Enter Points to Gift"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Gift Box Container
                                              Container(
                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: Colors.orange, width: 2),
                                                ),
                                                child: const Icon(
                                                  Icons.card_giftcard,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              // TextField to input points
                                              TextField(
                                                controller: pointsController,
                                                keyboardType: TextInputType.number,
                                                autofocus: true,
                                                decoration: const InputDecoration(
                                                  hintText: "Enter points",
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Close the dialog
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Try to parse the entered value as an integer
                                                int pointsToGift = int.tryParse(pointsController.text) ?? 0;

                                                if (pointsToGift > 0) {
                                                  try {
                                                    // Get the card ID before sending points
                                                    QuerySnapshot cardSnapshot = await FirebaseFirestore.instance
                                                        .collection('cards')
                                                        .where('shopUID', isEqualTo: widget.shopId)
                                                        .where('userUID', isEqualTo: userUid)
                                                        .get();

                                                    if (cardSnapshot.docs.isNotEmpty) {
                                                      String cardID = cardSnapshot.docs.first.id;

                                                      // Call addGiftPoints method to update points
                                                      await addGiftPoints(cardID, pointsToGift, userUid, widget.shopId);

                                                      // Show confirmation message
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("Gift of $pointsToGift points sent to $userName!")),
                                                      );
                                                    } else {
                                                      // If no card found
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("No card found for $userName in this shop.")),
                                                      );
                                                    }

                                                    // Close the dialog
                                                    Navigator.pop(context);
                                                  } catch (e) {
                                                    // Handle errors
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("Failed to send gift: $e")),
                                                    );
                                                  }
                                                } else {
                                                  // Show error if points are invalid
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Please enter a valid number of points!")),
                                                  );
                                                }
                                              },
                                              child: const Text("Send Gift"),
                                            ),
                                          ],
                                        );

                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4E0189),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "Send Gift",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      // If no card is found for the shop and user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No card found for $userName in this shop.")),
                      );
                    }
                  } catch (e) {
                    // Handle errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to fetch card details: $e")),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF240C36),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],)
      ),
    );
  }
}
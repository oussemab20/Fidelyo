import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'EditStore.dart';


class Updatestore extends StatefulWidget {
  const Updatestore({super.key});

  @override
  State<Updatestore> createState() => _UpdatestoreState();
}

class _UpdatestoreState extends State<Updatestore> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  // Fetch data from Firestore
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('shops').get();
      setState(() {
        data = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch data: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Store",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.purple, // Purple text color
          ),
        ),
        centerTitle:true,
        backgroundColor: Colors.white, // Replace with your desired hex color value
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? const Center(child: Text("No shops found"))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two images per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 4, // Adjust aspect ratio for image and text
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final shop = data[index].data() as Map<String, dynamic>;
            final shopImage = shop['shopImage'] ?? '';
            final shopName = shop['name'] ?? 'Unnamed Shop';
            final shopId = data[index].id; // Get the shop's ID

            return GestureDetector(
              onTap: () {
                // Navigate to the EditStore page and pass the shop data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditStore(storeId: shopId),

                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  shopImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      shopImage,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.store, size: 120),
                  const SizedBox(height: 8.0),
                  Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

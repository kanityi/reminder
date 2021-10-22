import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reminder/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => QrImage(
                data:
                    '${_controller.itemName.value},${_controller.itemDescription.value}',
                size: 200,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Item Name",
              ),
              keyboardType: TextInputType.text,
              controller: _controller.itemNameInputController,
              onChanged: (value) => _controller.itemName.value = value,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Item Description",
              ),
              keyboardType: TextInputType.text,
              controller: _controller.itemDescriptionController,
              onChanged: (value) => _controller.itemDescription.value = value,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _controller.saveAndShareQRCode("Data"),
              child: Text("Save QR code"),
            ),
          ],
        ),
      ),
    );
  }
}

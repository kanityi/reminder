import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class HomeController extends GetxController {
  final itemNameInputController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemName = ''.obs;
  final itemDescription = ''.obs;

  String scannedQrCode = '';
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> saveAndShareQRCode(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    if (qrValidationResult.isValid) {
      final painter = QrPainter.withQr(
        qr: qrValidationResult.qrCode!,
        color: Colors.white,
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
        emptyColor: Colors.purple[700],
        eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
      );

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '$tempPath/$ts.png';

      final picData =
          await painter.toImageData(1560, format: ImageByteFormat.png);
      await writeToFile(picData!, path);

      await Share.shareFiles([path],
          mimeTypes: ["image/png"],
          subject: 'My QR code',
          text: 'Please scan me');

      final success = await GallerySaver.saveImage(path);
      print('info ${success}');
    }
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> scanQRCode() async {
    try {
      scannedQrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (scannedQrCode != '-1') {
        Get.snackbar(
          'Results ',
          'QR Code ${scannedQrCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.white,
        );
        return;
      }
    } on PlatformException {
      printError(info: 'Error', logFunction: () => 'Error occured');
    }
  }
}

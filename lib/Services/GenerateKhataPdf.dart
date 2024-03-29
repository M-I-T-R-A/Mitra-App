import 'dart:convert';
import 'dart:io';

import 'package:Mitra/Models/Grocery.dart';
import 'package:Mitra/Models/Khata.dart';
import 'package:Mitra/Models/Store.dart';
import 'package:Mitra/Services/StoreDetails.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

getAllKhata() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  
  final url = (server+"shop/sell/customers/"+ id.toString());
  print(url);
  Response response = await get(Uri.encodeFull(url), headers: {"Content-Type": "application/json"});
  print(response.body);
  
  List<Khata> khata = (json.decode(response.body) as List).map((i) => Khata.fromJson(i)).toList();
  
  return khata;
}

generateKhata(Map<String, dynamic> data) async{
  String path = await createPDF(data); 

  final File file = File(path);
  
  String firebasePath = await uploadFile(file, path);
  
  //post request
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  
  List<dynamic> soldItems = new List();
  for(int i =0 ; i< data["products"].length; i++){
    soldItems.add({
        "category": data["products"][i].category,
        "name": data["products"][i].name,
        "pricePerUnit": data["products"][i].pricePerUnit,
        "quantity": data["quantity"][i],
        "unit": data["products"][i].unit
    });
  }

  final khata = {
    "customerId": id,
    "invoiceImageUrl": firebasePath,
    "amountPaid": data['customerAmount'],
    "shopCustomer": {
      "name": data["customerName"],
      "phoneNumber": data["customerMobile"].toString()
    },
    "soldItems": soldItems
  };
  print(khata);
  final url = (server+"shop/sell");
  print(url);
  Response response = await post(Uri.encodeFull(url), body: json.encode(khata), headers: {"Content-Type": "application/json"});
  print(response.body);
  
  return response.statusCode == 200 ? path : null;
}

Future<String> createPDF(Map<String, dynamic> data) async {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid(data["products"],data["quantity"]);
  //Draw the header section by creating text element
  final PdfLayoutResult result = drawHeader(page, pageSize, grid, data["customerName"], data["customerMobile"].toString());
  //Draw grid
  drawGrid(page, grid, result);
  //Add invoice footer
  await drawFooter(page, pageSize);
  //Save and launch the document
  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();
  //Save and launch file.
  final Directory directory = await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String date = format.format(DateTime.now());
  final File file = File('$path/invoice_'+data["customerMobile"].toString()+'_'+date+'.pdf');
  await file.writeAsBytes(bytes);

  return file.path;
}

PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid, String customerName, String customerMobile) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  page.graphics.drawString(
      'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
 
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)));
 
  page.graphics.drawString('Rs. ' + getTotalAmount(grid).toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle));
 
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
  //Draw string
  page.graphics.drawString('Amount', contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data format and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final String invoiceNumber = 'Invoice Number: $timestamp\r\n\r\nDate: ' +
      format.format(DateTime.now());
  final Size contentSize = contentFont.measureString(invoiceNumber);
  String address =
      'Bill To: \r\n\r\n$customerName, \r\n\r\nPhone Number: $customerMobile';
 
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));
 
  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120,
          pageSize.width - (contentSize.width + 30), pageSize.height - 120));
}

//Create PDF grid and return
PdfGrid getGrid(List<dynamic> product, List<int> quantity) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Product Id';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';
  for(int i = 0; i<product.length; i++){
    addProducts((i+1).toString(), product[i].name, product[i].pricePerUnit, quantity[i], product[i].pricePerUnit*quantity[i], grid);
  }
  //Apply the grid built-in style.
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}
 
//Create row for the grid.
void addProducts(String productId, String productName, double price,
    int quantity, double total, PdfGrid grid) {
  PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
  Rect totalPriceCellBounds;
  Rect quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));
 
  //Draw grand total.
  page.graphics.drawString('Grand Total',
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          quantityCellBounds.left,
          result.bounds.bottom + 10,
          quantityCellBounds.width,
          quantityCellBounds.height));
  page.graphics.drawString("Rs." + getTotalAmount(grid).toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          totalPriceCellBounds.left,
          result.bounds.bottom + 10,
          totalPriceCellBounds.width,
          totalPriceCellBounds.height));
}

Future<void> drawFooter(PdfPage page, Size pageSize) async{
  //get Store Info
  Store store = await getStoreDetails();
  String storeName = store.shopName;
  String storeMobile = store.phoneNumber;
  String storeAddress = store.shopAddress.firstLine + ", " + store.shopAddress.secondLine + ', '+ store.shopAddress.city;
  
  final PdfPen linePen =
      PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));
 
  String footerContent =
      '$storeName, \r\n\r$storeMobile \r\n\r$storeAddress\r\n\r\nAny Questions? mitra@tvs-credit.com';
 
  //Added 30 as a margin for the layout.
  page.graphics.drawString(
      footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Get the total amount.
double getTotalAmount(PdfGrid grid) {
  double total = 0;
  for (int i = 0; i < grid.rows.count; i++) {
    final String value = grid.rows[i].cells[grid.columns.count - 1].value;
    total += double.parse(value);
  }
  return total;
}
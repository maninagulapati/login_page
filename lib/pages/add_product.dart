import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => __AddProductPageState();
}

class __AddProductPageState extends State<AddProductPage> {

  
  final ImagePicker picker=ImagePicker();
  Uint8List? _imageData;
  String? base64Image;
  
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _sizesController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile= await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      final bytes = await pickedFile.readAsBytes();
      setState((){
        _imageData=bytes;
        base64Image=base64Encode(bytes);
      });
    }
    else{
      print("No image selected");
    }
  }

  Future<void> _uploadProduct() async{
    if(_imageData==null || _titleController.text.isEmpty|| _priceController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Please fill all fields and select an image'),),
      );
      return;
    }

  try{
    //Convert image to base64 string 
    // String base64Image= base64Encode(_imageData);
    var sizes = _sizesController.text.split(',').map((size) => size.trim()).toList();


    final response=await http.post(
      Uri.parse('http://localhost:3000/api/products/addproduct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'company': _companyController.text,
          'image': base64Image,
          'sizes':sizes,
        }),
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Product added successfully')),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Error: ${response.body}')),
      );
    }
  }
  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Text('Error while uploading product: $e'),),
    );
  }

  } 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Product Title'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _companyController,
              decoration: InputDecoration(labelText: 'Product Company'),
            ),
            TextField(
              controller: _sizesController,
              decoration: InputDecoration(labelText: 'Product Sizes (comma separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            _imageData != null ? Image.memory(_imageData!,height: 200,) : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
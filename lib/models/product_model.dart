// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../minor_screens/edit_products.dart';
import '../minor_screens/product_details.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    required this.products,
    super.key,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    const TextStyle appTextStyle = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.red);
    const TextStyle webTextStyle = TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.red);
    const textStyle = kIsWeb ? webTextStyle : appTextStyle;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  proList: widget.products,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    constraints:
                    const BoxConstraints(minHeight: 100, maxHeight: 250),
                    child: Image(
                      image: NetworkImage(widget.products['proimages'][0]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.products['proname'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          widget.products['sid'] ==
                              FirebaseAuth.instance.currentUser!.uid
                              ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProduct(
                                        items: widget.products,
                                      )));
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.red,
                          )
                              : const SizedBox(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Rs ', style: textStyle),
                          Text(
                            widget.products['price'].toStringAsFixed(2),
                            style: onSale != 0
                                ? const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w600)
                                : textStyle,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          onSale != 0
                              ? Text(
                            ((1 - (onSale / 100)) *
                                widget.products['price'])
                                .toStringAsFixed(2),
                            style: textStyle,
                          )
                              : const Text(''),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          onSale != 0
              ? Positioned(
            top: 30,
            left: 0,
            child: Container(
              height: 25,
              width: 80,
              decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Center(
                child: Text('Save ${onSale.toString()} %'),
              ),
            ),
          )
              : Container(
            color: Colors.transparent,
          )
        ]),
      ),
    );
  }
}
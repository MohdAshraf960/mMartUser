import 'dart:convert';
// import 'dart:developer';

import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  CartRepo({@required this.sharedPreferences});

  List<CartModel> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST);
    }
    List<CartModel> cartList = [];
    carts.forEach(
      (cart) => cartList.add(
        CartModel.fromJson(
          jsonDecode(cart),
        ),
      ),
    );
    addDuplicates(cartList).then((value) => cartList = value).catchError((_) {
      debugPrint("$_");
    });

    return cartList;
  }

  Future<void> addToCartList(List<CartModel> cartProductList) async {
    List<String> carts = [];

    List<CartModel> newCart = await addDuplicates(cartProductList);
    newCart.forEach((cartModel) {
      carts.add(jsonEncode(cartModel));
    });

    await sharedPreferences.setStringList(AppConstants.CART_LIST, carts);
  }

  Future<List<CartModel>> addDuplicates(List<CartModel> cartList) {
    for (int i = 0; i < cartList.length; i++) {
      for (int j = i + 1; j < cartList.length; j++) {
        if (cartList[i].item.id == cartList[j].item.id) {
          cartList[i].quantity += cartList[j].quantity;
          cartList.removeAt(j);
          j--;
        }
      }
    }

    return Future.value(cartList);
  }
}

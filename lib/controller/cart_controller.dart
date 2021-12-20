import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }

  void addToCart(CartModel cartModel, int index) {
    print('caaaaaaaarrrrrrrryttttttttt');
    var product_id = cartModel.product.id;
    var increment_quantity_position;
    List<bool> tempList = [];
    if (_cartList.length == 0) {
    } else {
      for (int i = 0; i < _cartList.length; i++) {
        if (_cartList[i].product.id == product_id) {
          tempList.add(true);
          increment_quantity_position = i;
        } else {
          tempList.add(false);
        }
        print(tempList);
      }
    }
    if (index != null) {
      print('iiiiffffffffff:${index}');
      _amount = _amount -
          (_cartList[index].discountedPrice * _cartList[index].quantity);

      _cartList.replaceRange(index, index + 1, [cartModel]);
    } else if (tempList.contains(true)) {
      print('blabla');
      _cartList[increment_quantity_position].quantity =
          _cartList[increment_quantity_position].quantity + cartModel.quantity;

      // print('iiiiffffffffff:${index}');
      // _cartList.add(cartModel);
      // print(_cartList);
    } else {
      _cartList.add(cartModel);
      print(_cartList.toString());
    }
    _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    _amount = _amount -
        (_cartList[index].discountedPrice * _cartList[index].quantity);
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    update();
  }

  bool isExistInCart(CartModel cartModel, bool isUpdate, int cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == cartModel.product.id &&
          (_cartList[index].variation.length > 0
              ? _cartList[index].variation[0].type ==
                  cartModel.variation[0].type
              : true)) {
        if ((isUpdate && index == cartIndex)) {
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for (CartModel cartModel in _cartList) {
      if (cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    _amount = cartModel.discountedPrice * cartModel.quantity;
    cartRepo.addToCartList(_cartList);
    update();
  }
}

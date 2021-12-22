import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double charge;
  final bool isFree;
  DeliveryOptionButton(
      {@required this.value,
      @required this.title,
      @required this.charge,
      @required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return InkWell(
          onTap: () => (value == 'take_away')
              ? orderController.setOrderType(value)
              : () {},
          child: Container(
            color: (value == 'delivery')
                ? Colors.grey.withOpacity(0.5)
                : Colors.transparent,
            child: Row(
              children: [
                Radio(
                  value: value,
                  toggleable: false,
                  groupValue: orderController.orderType,
                  // groupValue: 'take_away',
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (String value) => (value == 'take_away')
                      ? orderController.setOrderType(value)
                      : () {},
                  // onChanged: (String value) => {},
                  activeColor: Theme.of(context).primaryColor,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(title, style: robotoRegular),
                SizedBox(width: 5),
                Text(
                  '(${(value == 'take_away' || isFree) ? 'free'.tr : PriceConverter.convertPrice(charge)})',
                  style: robotoMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

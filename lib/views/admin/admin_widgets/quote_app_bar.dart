import 'package:flutter/material.dart';
import 'package:motivational/providers/admin/admin_quote_provider.dart';
import 'package:motivational/utils/my_colors.dart';
import 'package:motivational/views/admin/admin_widgets/bottom_sheet.dart';
import 'package:motivational/views/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';

class QuoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController textEditingController;
  const QuoteAppBar({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      leading: const Padding(
        padding: EdgeInsets.all(12.0),
        child: CustomBackButton(),
      ),
      title: const Text(
        "Quotes",
        style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
      ),
      actions: [
        GestureDetector(
          onTap: () => onTap(context),
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: MyColors.blackTypeColor,
              child: Icon(
                Icons.add,
                size: 15,
                color: MyColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // onTap(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Consumer<AdminQuoteProvider>(
  //         builder: (context, value, child) => AdminBottomSheet(
  //           fucntion: () async {
  //             await value.createQuote(
  //                 quote: textEditingController.text.trim());
  //             textEditingController.clear();
  //           },
  //           firstTitle: "Add",
  //           secondTitle: "Quote",
  //           controller: textEditingController,
  //           hintText: "Your Quote",
  //           buttonText: "Add",
  //           loader: value.createQuoteLoader,
  //         ),
  //       );
  //     },
  //   );
  // }


  onTap(BuildContext context) {
                textEditingController.clear();
    
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer<AdminQuoteProvider>(
            builder: (context, value, child) => AdminBottomSheet(
              fucntion: () async {
                await value.createQuote(
                    quote: textEditingController.text.trim());
                textEditingController.clear();
              },
              firstTitle: "Add",
              secondTitle: "Quote",
              controller: textEditingController,
              hintText: "Your Quote",
              buttonText: "Add",
              loader: value.createQuoteLoader,
            ),
          );
        },
      );
    },
  );
}


  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}

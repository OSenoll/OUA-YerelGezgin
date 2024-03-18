import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Custom Snack Bar Class
class CustomSnackBarContent extends StatelessWidget {
  const CustomSnackBarContent({
    super.key,
    required this.errorText,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black, width: 3)),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.components_notification.tr(),
                        style: const TextStyle(
                            fontSize: 25, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const Spacer(),
                      Text(
                        errorText,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 73, 73, 73),
                            fontSize: 18,
                            fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

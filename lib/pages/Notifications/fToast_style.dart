
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/enums.dart';

Map<int, Color> columnColors = {0: Colors.green, 1: Colors.red};

showToast(
  FToast fToast,
  String msg,
  NotificationStatus status,
) {
  fToast.showToast(
    child: Container(
      // width: 200,
      decoration: BoxDecoration(
          color: status.index==0?Colors.green[100]:Colors.red[100],
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 10,
            height: 80,
            decoration: BoxDecoration(
                color: columnColors[status.index],
                borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                status == NotificationStatus.failure ? Icon(
                    Icons.error,
                    color: Colors.red[800],) : Icon(
                    Icons.check_circle,
                    color: Colors.green[800],),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          status == NotificationStatus.success ? 'Success' : 'Error',
                          style: const TextStyle(fontSize: 16, color: Colors.black)
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(msg),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 3),
  );
}

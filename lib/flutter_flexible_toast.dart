import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER }

enum ICON {
  CLOSE,
  ERROR,
  INFO,
  SUCCESS,
  WARNING,
  ALARM,
  LOCATION,
  DND,
  LOADING
}

class FlutterFlexibleToast {
  static const MethodChannel _channel = MethodChannel('flutter_flexible_toast');

  static Future<bool?> cancel() async {
    var res = await _channel.invokeMethod('cancel');
    return res;
  }

  static Future<bool?> showToast({
    required String message,
    Toast? toastLength,
    int? timeInSeconds,
    double? fontSize,
    ToastGravity? toastGravity,
    Color? backgroundColor,
    Color? textColor,
    ICON? icon,
    int? radius,
    int? elevation,
    int? imageSize,
  }) async {
    var toast = 'short';
    if (toastLength == Toast.LENGTH_LONG) {
      toast = 'long';
    }
    var gravityToast = 'bottom';
    if (toastGravity == ToastGravity.TOP) {
      gravityToast = 'top';
    } else if (toastGravity == ToastGravity.CENTER) {
      gravityToast = 'center';
    } else {
      gravityToast = 'bottom';
    }

    String? images;
    if (icon == ICON.CLOSE) {
      images = 'close';
    } else if (icon == ICON.ERROR) {
      images = 'error';
    } else if (icon == ICON.INFO) {
      images = 'info';
    } else if (icon == ICON.SUCCESS) {
      images = 'success';
    } else if (icon == ICON.WARNING) {
      images = 'warning';
    } else if (icon == ICON.ALARM) {
      images = 'alarm';
    } else if (icon == ICON.LOCATION) {
      images = 'location';
    } else if (icon == ICON.DND) {
      images = 'dnd';
    } else if (icon == ICON.LOADING) {
      images = 'loading';
    } else {
      images = null;
    }

    backgroundColor ??= Colors.black;
    textColor ??= Colors.white;

    imageSize ??= 25;

    /**
     * mapped input here with method channel for native changes.
     */
    final parameters = <String, dynamic>{
      'message': message,
      'length': toast,
      'time': timeInSeconds ?? 1,
      'gravity': gravityToast,
      'icon': images,
      'bgcolor': backgroundColor.value,
      'textcolor': textColor.value,
      'fontSize': fontSize ?? 16.0,
      'radius': radius ?? 5,
      'elevation': elevation ?? 5,
      'imageSize': imageSize,
    };

    var res = await _channel.invokeMethod('showToast', parameters);
    return res;
  }
}

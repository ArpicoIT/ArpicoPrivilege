import 'package:flutter/material.dart';

enum RewardsTier { bronze, silver, gold, platinum }

enum InitializationState {
  waiting(0),
  failed(1001),
  notFound(404),
  noContent(204),
  timeout(408),
  connectionError(1009),
  internalServerError(500),
  success(200);

  final int code;

  const InitializationState(this.code);
}

enum ProductTypes {
  all("", "All", null),
  deals("DEALS", "Deals", Icons.flash_on),
  topRated("TOPRATED", "Top Rated", Icons.star),
  newArrivals("RECENT", "New Arrivals", Icons.new_label_rounded);

  final String key;
  final String label;
  final IconData? iconData;

  const ProductTypes(this.key, this.label, this.iconData);
}

enum PromotionTypes {
  all("", "All", null),
  ongoing("ACT", "Ongoing", Icons.play_circle),
  upcoming("UPC", "Upcoming", Icons.schedule),
  expired("EXP", "Expired", Icons.history);

  final String key;
  final String label;
  final IconData? iconData;

  const PromotionTypes(this.key, this.label, this.iconData);
}

// waiting:
//
// Error Code: 0
//
// Explanation: This is the default state, meaning the process is still ongoing, and no error has occurred.
//
// error:
//
// Error Code: 1001
//
// Explanation: A general error that can occur during initialization, typically representing an unknown failure.
//
// pageNotFound:
//
// Error Code: 404
//
// Explanation: The requested page was not found on the server, often used for routing issues.
//
// noData:
//
// Error Code: 204
//
// Explanation: No content is available or returned from the server (e.g., empty data).
//
// timeout:
//
// Error Code: 408
//
// Explanation: The request timed out, meaning the server didn't respond in time.
//
// connectionError:
//
// Error Code: 1009
//
// Explanation: There was a network connection error, typically due to being offline or unable to reach the server.
//
// serverError:
//
// Error Code: 500
//
// Explanation: A general server-side error occurred, indicating that the server could not handle the request.
//
// success:
//
// Error Code: 200
//
// Explanation: Everything was successful, the process completed without issues.
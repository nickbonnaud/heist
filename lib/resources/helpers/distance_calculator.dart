import 'package:meta/meta.dart';
import 'dart:math' as math;

class DistanceCalculator {

  static String getDistance({@required double lat1, @required double lng1, @required double lat2, @required double lng2}) {
    const r = 3958.756;
    final double dLat = _deg2Rad(deg: lat2 - lat1);
    final double dLng = _deg2Rad(deg: lng2 - lng1);

    final double a = math.sin(dLat/2) * math.sin(dLat/2) + math.cos(_deg2Rad(deg: lat1)) * math.cos(_deg2Rad(deg: lat2)) * math.sin(dLng/2) * math.sin(dLng/2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
    final double d = r * c;
    return d.toStringAsFixed(2);
  }

  static double _deg2Rad({@required double deg}) {
    return deg * (math.pi / 180);
  }
} 
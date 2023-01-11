import 'dart:math';

class MyAPI{
  //การคิดค่าบริการจัดส่ง
  int calculateTransport(double distance) {
    int transport;
    if (distance < 1.0) {
      transport = 30;
      return transport;
    } else {
      transport = 30 + (distance - 1).round() * 10;
      return transport;
    }
  }
//การคิดระยะห่างระหว่างจุดสองจุด
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295; // Math.PI (ค่าพาย)/180
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));//asin เป็นค่ามุมกลับของค่า sin

    return distance;
  }

  MyAPI(){}
}
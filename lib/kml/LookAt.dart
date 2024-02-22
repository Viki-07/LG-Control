// ignore_for_file: unnecessary_this
//positions the camera in relation to object that is being viewed
class LookAt {
  double lng;
  double lat;
  String range;
  String tilt;
  String heading;

  LookAt(this.lng, this.lat, this.range, this.tilt, this.heading);

  generateTag() {
    return '''
       <LookAt>
        <longitude>${this.lng}</longitude>
        <latitude>${this.lat}</latitude>
        <range>${this.range}</range>
        <tilt>${this.tilt}</tilt>
        <heading>${this.heading}</heading>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    ''';
  }
}

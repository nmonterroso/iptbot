part of iptservice;

class IptData {
  static final RegExp _sizeRegex = new RegExp(r'([0-9\.]+) (MB|GB)$');
  static const double KB_TO_GB = 1.074e+9;
  static const double KB_TO_MB = 1.049e+6;
  
  String _title;
  String _link;
  String _date;
  double _size;
  
  void set date(String date) {
    _date = date;
  }
  
  void set size(String size) {
    Match m = _sizeRegex.firstMatch(size);
    
    if (m == null) {
      throw "unable to parse size: ${size}";  
    }
    
    double base = double.parse(m[1]); // in bytes
    double multiplier;
    
    switch (m[2].toLowerCase()) {
      case 'mb':
        multiplier = KB_TO_MB;
        break;
      case 'gb':
        multiplier = KB_TO_GB;
        break;
    }
    
    _size = base*multiplier;
  }
}
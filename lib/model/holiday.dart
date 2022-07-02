class Holiday {
  final DateTime day;
  final String name;
  final bool allStates;
  final bool bw;
  final bool by;
  final bool be;
  final bool bb;
  final bool hb;
  final bool hh;
  final bool he;
  final bool mv;
  final bool ni;
  final bool nw;
  final bool rp;
  final bool sl;
  final bool sn;
  final bool st;
  final bool sh;
  final bool th;

  Holiday({
    required this.day,
    required this.name,
    this.allStates = false,
    this.bw = false,
    this.by = false,
    this.be = false,
    this.bb = false,
    this.hb = false,
    this.hh = false,
    this.he = false,
    this.mv = false,
    this.ni = false,
    this.nw = false,
    this.rp = false,
    this.sl = false,
    this.sn = false,
    this.st = false,
    this.sh = false,
    this.th = false,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      day: DateTime.parse(json['date'] ?? '200-03-04'),
      name: json['fname'] ?? 'Feiertag',
      allStates: json['all_states'] == '1',
      bw: json['bw'] == '1',
      by: json['by'] == '1',
      be: json['be'] == '1',
      bb: json['bb'] == '1',
      hb: json['hb'] == '1',
      hh: json['hh'] == '1',
      he: json['he'] == '1',
      mv: json['mv'] == '1',
      ni: json['ni'] == '1',
      nw: json['nw'] == '1',
      rp: json['rp'] == '1',
      sl: json['sl'] == '1',
      sn: json['sn'] == '1',
      st: json['st'] == '1',
      sh: json['sh'] == '1',
      th: json['th'] == '1',
    );
  }

  bool isValid(String identifier) {
    switch (identifier) {
      case 'none':
        return false;
      case 'allStates':
        return allStates;
      case 'bw':
        return bw;
      case 'by':
        return by;
      case 'be':
        return be;
      case 'bb':
        return bb;
      case 'hb':
        return hb;
      case 'hh':
        return hh;
      case 'he':
        return he;
      case 'mv':
        return mv;
      case 'ni':
        return ni;
      case 'nw':
        return nw;
      case 'rp':
        return rp;
      case 'sl':
        return sl;
      case 'sn':
        return sn;
      case 'st':
        return st;
      case 'sh':
        return sh;
      case 'th':
        return th;
      default:
        return false;
    }
  }
}

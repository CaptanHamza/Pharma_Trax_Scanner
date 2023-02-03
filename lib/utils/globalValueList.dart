 List<Map<String, dynamic>> map = const [
    {'identifer': "00", 'title': "SSCC", 'length': 18},
    {'identifer': "01", 'title': "GTIN", 'length': 14},
    {'identifer': "02", 'title': "CONTENT", 'length': 14},
    {
      'identifer': "10",
      'title': "BATCH/LOT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {'identifer': "11", 'title': "PROD DATE", 'length': 6},
    {'identifer': "12", 'title': "DUE DATE", 'length': 6},
    {'identifer': "13", 'title': "PACK DATE", 'length': 6},
    {'identifer': "15", 'title': "BEST BY", 'length': 6},
    {'identifer': "16", 'title': "SELL BY", 'length': 6},
    {'identifer': "17", 'title': "EXPIRY", 'length': 6},
    {'identifer': "20", 'title': "VARIANT", 'length': 2},
    {
      'identifer': "21",
      'title': "SERIAL",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "22",
      'title': "CPV",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "240",
      'title': "ADDITIONAL ID",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "241",
      'title': "CUST. PART NO.",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "242",
      'title': "MTO VARIANT",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "243",
      'title': "PCN",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "250",
      'title': "SECONDARY SERIAL",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "251",
      'title': "REF. TO SOURCE",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "253",
      'title': "GDTI",
      "minimumLength": 13,
      "maximumLength": 30
    },
    {
      'identifer': "254",
      'title': "GLN EXTENSION COMPONENT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "255",
      'title': "GCN",
      "minimumLength": 13,
      "maximumLength": 25
    },
    {
      'identifer': "30",
      'title': "VAR. COUNT",
      "minimumLength": 1,
      "maximumLength": 8
    },
    {'identifer': "310n", 'title': "NET WEIGHT (kg)", 'length': 6},
    {'identifer': "311n", 'title': "LENGTH (m)", 'length': 6},
    {'identifer': "312n", 'title': "WIDTH (m)", 'length': 6},
    {'identifer': "313n", 'title': "HEIGHT (m)", 'length': 6},
    {'identifer': "314n", 'title': "AREA (m2)", 'length': 6},
    {'identifer': "315n", 'title': "NET VOLUME (l)", 'length': 6},
    {'identifer': "316n", 'title': "NET VOLUME (m3)", 'length': 6},
    {'identifer': "320n", 'title': "NET WEIGHT (lb)", 'length': 6},
    {'identifer': "321n", 'title': "LENGTH (i)", 'length': 6},
    {'identifer': "322n", 'title': "LENGTH (f)", 'length': 6},
    {'identifer': "323n", 'title': "LENGTH (y)", 'length': 6},
    {'identifer': "324n", 'title': "WIDTH (i)", 'length': 6},
    {'identifer': "325n", 'title': "WIDTH (f)", 'length': 6},
    {'identifer': "326n", 'title': "WIDTH (y)", 'length': 6},
    {'identifer': "327n", 'title': "HEIGHT (i)", 'length': 6},
    {'identifer': "328n", 'title': "HEIGHT (f)", 'length': 6},
    {'identifer': "329n", 'title': "HEIGHT (y)", 'length': 6},
    {'identifer': "330n", 'title': " GROSS WEIGHT (kg)", 'length': 6},
    {'identifer': "331n", 'title': "LENGTH (m), log", 'length': 6},
    {'identifer': "332n", 'title': "WIDTH (m), log", 'length': 6},
    {'identifer': "333n", 'title': "HEIGHT (m), log", 'length': 6},
    {'identifer': "334n", 'title': "AREA (m2), log", 'length': 6},
    {'identifer': "335n", 'title': "VOLUME (l), log", 'length': 6},
    {'identifer': "336n", 'title': "VOLUME (m3), log", 'length': 6},
    {'identifer': "337n", 'title': "KG PER m²", 'length': 6},
    {'identifer': "340n", 'title': "GROSS WEIGHT (lb)", 'length': 6},
    {'identifer': "341n", 'title': "LENGTH (i), log", 'length': 6},
    {'identifer': "342n", 'title': "LENGTH (f), log", 'length': 6},
    {'identifer': "343n", 'title': "LENGTH (y), log", 'length': 6},
    {'identifer': "344n", 'title': "WIDTH (i), log", 'length': 6},
    {'identifer': "345n", 'title': "WIDTH (f), log", 'length': 6},
    {'identifer': "346n", 'title': "WIDTH (y), log", 'length': 6},
    {'identifer': "347n", 'title': "HEIGHT (i), log", 'length': 6},
    {'identifer': "348n", 'title': "HEIGHT (f), log", 'length': 6},
    {'identifer': "349n", 'title': "HEIGHT (y), log", 'length': 6},
    {'identifer': "350n", 'title': "AREA (i2)", 'length': 6},
    {'identifer': "351n", 'title': "AREA (f2)", 'length': 6},
    {'identifer': "352n", 'title': "AREA (y2)", 'length': 6},
    {'identifer': "353n", 'title': "AREA (i2), log", 'length': 6},
    {'identifer': "354n", 'title': "AREA (f2), log", 'length': 6},
    {'identifer': "355n", 'title': "AREA (y2), log", 'length': 6},
    {'identifer': "356n", 'title': "NET WEIGHT (t)", 'length': 6},
    {'identifer': "357n", 'title': "NET VOLUME (oz)", 'length': 6},
    {'identifer': "360n", 'title': "NET VOLUME (q)", 'length': 6},
    {'identifer': "361n", 'title': "NET VOLUME (g)", 'length': 6},
    {'identifer': "362n", 'title': "VOLUME (q), log", 'length': 6},
    {'identifer': "363n", 'title': "VOLUME (g), log", 'length': 6},
    {'identifer': "364n", 'title': "VOLUME (i3)", 'length': 6},
    {'identifer': "365n", 'title': "VOLUME (f3)", 'length': 6},
    {'identifer': "366n", 'title': "VOLUME (y3)", 'length': 6},
    {'identifer': "367n", 'title': "VOLUME (i3), log", 'length': 6},
    {'identifer': "368n", 'title': "VOLUME (f3), log", 'length': 6},
    {'identifer': "369n", 'title': "VOLUME (y3), log", 'length': 6},
    {
      'identifer': "37",
      'title': "COUNT",
      "minimumLength": 1,
      "maximumLength": 8
    },
    {
      'identifer': "390n",
      'title': "AMOUNT",
      "minimumLength": 1,
      "maximumLength": 15
    },
    {
      'identifer': "391n",
      'title': "AMOUNT",
      "minimumLength": 3,
      "maximumLength": 18
    },
    {
      'identifer': "392n",
      'title': "PRICE",
      "minimumLength": 1,
      "maximumLength": 15
    },
    {
      'identifer': "393n",
      'title': "PRICE",
      "minimumLength": 3,
      "maximumLength": 18
    },
    {
      'identifer': "394n",
      'title': "PRCNT OFF",
      'length': 4,
      "requiredFNC1": true
    },
    {
      'identifer': "400",
      'title': "ORDER NUMBER",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "401",
      'title': "GINC",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {'identifer': "402", 'title': "GSIN", 'length': 17, "requiredFNC1": true},
    {
      'identifer': "403",
      'title': "ROUTE",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {'identifer': "410", 'title': "SHIP TO LOC", 'length': 13},
    {'identifer': "411", 'title': "BILL TO", 'length': 13},
    {'identifer': "412", 'title': "PURCHASE FROM", 'length': 13},
    {'identifer': "413", 'title': "SHIP FOR LOC", 'length': 13},
    {'identifer': "414", 'title': "LOC No", 'length': 13},
    {'identifer': "415", 'title': "PAY TO", 'length': 13},
    {'identifer': "416", 'title': "PROD/SERV LOC", 'length': 13},
    {
      'identifer': "420",
      'title': "SHIP TO POST",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "421",
      'title': "SHIP TO POST",
      "minimumLength": 3,
      "maximumLength": 12
    },
    {'identifer': "422", 'title': "ORIGIN", 'length': 3, "requiredFNC1": true},
    {
      'identifer': "423",
      'title': "COUNTRY - INITIAL PROCESS.",
      "minimumLength": 3,
      "maximumLength": 15
    },
    {
      'identifer': "424",
      'title': "COUNTRY - PROCESS.",
      'length': 3,
      "requiredFNC1": true
    },
    {
      'identifer': "425",
      'title': "COUNTRY - DISASSEMBLY",
      "minimumLength": 3,
      "maximumLength": 15
    },
    {
      'identifer': "426",
      'title': "COUNTRY – FULL PROCESS",
      'length': 3,
      "requiredFNC1": true
    },
    {
      'identifer': "427",
      'title': "ORIGIN SUBDIVISION",
      "minimumLength": 1,
      "maximumLength": 3
    },
    {'identifer': "7001", 'title': "NSN", 'length': 13, "requiredFNC1": true},
    {
      'identifer': "7002",
      'title': "MEAT CUT",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "7003",
      'title': "EXPIRY TIME",
      'length': 10,
      "requiredFNC1": true
    },
    {
      'identifer': "7004",
      'title': "ACTIVE POTENCY",
      "minimumLength": 1,
      "maximumLength": 4
    },
    {
      'identifer': "7005",
      'title': "CATCH AREA",
      "minimumLength": 1,
      "maximumLength": 12
    },
    {
      'identifer': "7006",
      'title': "FIRST FREEZE DATE",
      'length': 6,
      "requiredFNC1": true
    },
    {
      'identifer': "7007",
      'title': "HARVEST DATE",
      "minimumLength": 6,
      "maximumLength": 12
    },
    {
      'identifer': "7008",
      'title': "AQUATIC SPECIES",
      "minimumLength": 1,
      "maximumLength": 3
    },
    {
      'identifer': "7009",
      'title': "FISHING GEAR TYPE",
      "minimumLength": 1,
      "maximumLength": 10
    },
    {
      'identifer': "7010",
      'title': "PROD METHOD",
      "minimumLength": 1,
      "maximumLength": 2
    },
    {
      'identifer': "7020",
      'title': "REFURB LOT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7021",
      'title': "FUNC STAT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7022",
      'title': "REV STAT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7023",
      'title': "GIAI – ASSEMBLY",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "703s",
      'title': "PROCESSOR # s",
      "minimumLength": 3,
      "maximumLength": 30
    },
    {
      'identifer': "710",
      'title': "NHRN PZN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "711",
      'title': "NHRN CIP",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "712",
      'title': "NHRN CN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "713",
      'title': "NHRN DRN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "714",
      'title': "NHRN AIM",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "...",
      'title': "NHRN xxx",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8001",
      'title': "DIMENSIONS",
      'length': 14,
      "requiredFNC1": true
    },
    {
      'identifer': "8002",
      'title': "CMT No",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8003",
      'title': "GRAI",
      "minimumLength": 14,
      "maximumLength": 30
    },
    {
      'identifer': "8004",
      'title': "GIAI",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8005",
      'title': "PRICE PER UNIT",
      'length': 6,
      "requiredFNC1": true
    },
    {
      'identifer': "8006",
      'title': "ITIP or GCTIN",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8007",
      'title': "IBAN",
      "minimumLength": 1,
      "maximumLength": 34
    },
    {
      'identifer': "8008",
      'title': "PROD TIME",
      "minimumLength": 8,
      "maximumLength": 12
    },
    {
      'identifer': "8010",
      'title': "CPID",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8011",
      'title': "CPID SERIAL",
      "minimumLength": 1,
      "maximumLength": 12
    },
    {
      'identifer': "8012",
      'title': "VERSION",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8013",
      'title': "GMN or BUDI-DI",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8017",
      'title': "GSRN - PROVIDER",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8018",
      'title': "GSRN - RECIPIENT",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8019",
      'title': "SRIN",
      "minimumLength": 1,
      "maximumLength": 10
    },
    {
      'identifer': "8020",
      'title': "REF No",
      "minimumLength": 1,
      "maximumLength": 25
    },
    {
      'identifer': "8110",
      'title': "-",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {'identifer': "8111", 'title': "POINTS", 'length': 4, "requiredFNC1": true},
    {
      'identifer': "8112",
      'title': "-",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {
      'identifer': "8200",
      'title': "PRODUCT URL",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {
      'identifer': "90",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "91",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "92",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "93",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "94",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "95",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "96",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "97",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "98",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "99",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
  ];

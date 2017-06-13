; sistema API divisas
; comandos actuales
; !divisas
; !divisa USD -> convierte a euro
; !divisa nombre USD -> dice nombre de la divisa


; reconvertir a
; !divisas
; !divisa EUR
; !divisa EUR nombre
; !divisa EUR USD : convierte
; !divisa EUR ayer/anteayer/fecha : devuelve rate pasado

alias getdivisas {
  set -l %dtoken $rand(1,500)
  set %dtarget $+ - $+ %dtoken $1
  sockopen getdivisas $+ %dtoken localhost 80
}
on *:sockopen:getdivisas*: {
  getamp_echo Extrayendo lista de divisas
  sockwrite -nt $sockname GET /myrobot/forex/index.php?opcion=listrates HTTP/1.1
  sockwrite -nt $sockname Host: $+(localhost,$crlf,$crlf)

}
on *:sockread:getdivisas*: {
  var %divtoken = $replace($sockname,getdivisas,-)
  set -l %divnickquerecibe $($+(%,dtarget,$eval(%divtoken)),2)
  if ( $sockerr ) {
    mybot PRIVMSG %divnickquerecibe :Error, no se pudo conectar
    sockclose $sockname
  }
  else {
    sockread %getdivisas
    tokenize 32 %getdivisas
    getamp_echo %getdivisas
    if ( $1 == LAS_DIVISAS_SON ) { 
      mybot PRIVMSG %divnickquerecibe :Lista de divisas:
      mybot PRIVMSG %divnickquerecibe : $+ $2-
      unset $+(%,dtarget,$eval(%divtoken))
      unset %divnickquerecibe
      unset %divtoken
    }
  }
  unset %getdivisas
}

alias cambiodivisa {
  ; $1 = divisa
  ; $2 = target
  set -l %dtoken $rand(1,500)
  set %dtarget $+ - $+ %dtoken $2
  set %ddivisa $+ - $+ %dtoken $1
  sockopen cambiodivisas $+ %dtoken localhost 80
}
on *:sockopen:cambiodivisas*: {
  getamp_echo Haciendo cambio de divisa
  set -l %eltoken $replace($sockname,cambiodivisas,-)
  set -l %ladivisa $($+(%,ddivisa,$eval(%eltoken)),2)
  sockwrite -nt $sockname GET $+(/myrobot/forex/index.php?opcion=valor&divisa=,%ladivisa) HTTP/1.1
  sockwrite -nt $sockname Host: $+(localhost,$crlf,$crlf)

}
on *:sockread:cambiodivisas*: {
  set -l %dtoken $replace($sockname,cambiodivisas,-)
  set -l %dnickquerecibe $($+(%,dtarget,$eval(%dtoken)),2)
  if ($sockerr) {
    mybot PRIVMSG %dnickquerecibe :Error de conexion
    sockclose $sockname
  }
  else {
    sockread %dgetdivisas
    tokenize 32 %dgetdivisas
    if ( $1 == DIVISA_A_EURO ) {
      mybot PRIVMSG %dnickquerecibe : $+ $upper($($+(%,ddivisa,$eval(%dtoken)),2)) equivale a $2 â‚¬
      unset $+(%,dtarget,$eval(%dtoken))
      unset $+(%,ddivisa,$eval(%dtoken))
      unset %dgetdivisas
      sockclose $sockname
    }
  }
}
; currencies
;
alias divisa_nombre {
  if ( $1 == AUD ) { return Dólar australiano }
  elseif ( $1 == BGN ) { }
  elseif ( $1 == BRL ) { }
  elseif ( $1 == CAD ) { }
  elseif ( $1 == CHF ) { }
  elseif ( $1 == CNY ) { }
  elseif ( $1 == CZK ) { }
  elseif ( $1 == DKK ) { }
  elseif ( $1 == GBP ) { }
  elseif ( $1 == HKD ) { }
  elseif ( $1 == HRK ) { }
  elseif ( $1 == HUF ) { }
  elseif ( $1 == IDR ) { }
  elseif ( $1 == ILS ) { }
  elseif ( $1 == INR ) { }
  elseif ( $1 == JPY ) { }
  elseif ( $1 == KRW ) { }
  elseif ( $1 == MXN ) { }
  elseif ( $1 == MYR ) { }
  elseif ( $1 == NOK ) { }
  elseif ( $1 == NZD ) { }
  elseif ( $1 == PHP ) { }
  elseif ( $1 == PLN ) { }
  elseif ( $1 == RON ) { }
  elseif ( $1 == RUB ) { }
  elseif ( $1 == SEK ) { }
  elseif ( $1 == SGD ) { }
  elseif ( $1 == THB ) { }
  elseif ( $1 == TRY ) { }
  elseif ( $1 == USD ) { }
  elseif ( $1 == ZAR) { }
}
/* {
  "AED": "United Arab Emirates Dirham",
  "AFN": "Afghan Afghani",
  "ALL": "Albanian Lek",
  "AMD": "Armenian Dram",
  "ANG": "Netherlands Antillean Guilder",
  "AOA": "Angolan Kwanza",
  "ARS": "Argentine Peso",
  "AUD": "Australian Dollar",
  "AWG": "Aruban Florin",
  "AZN": "Azerbaijani Manat",
  "BAM": "Bosnia-Herzegovina Convertible Mark",
  "BBD": "Barbadian Dollar",
  "BDT": "Bangladeshi Taka",
  "BGN": "Bulgarian Lev",
  "BHD": "Bahraini Dinar",
  "BIF": "Burundian Franc",
  "BMD": "Bermudan Dollar",
  "BND": "Brunei Dollar",
  "BOB": "Bolivian Boliviano",
  "BRL": "Brazilian Real",
  "BSD": "Bahamian Dollar",
  "BTC": "Bitcoin",
  "BTN": "Bhutanese Ngultrum",
  "BWP": "Botswanan Pula",
  "BYN": "Belarusian Ruble",
  "BZD": "Belize Dollar",
  "CAD": "Canadian Dollar",
  "CDF": "Congolese Franc",
  "CHF": "Swiss Franc",
  "CLF": "Chilean Unit of Account (UF)",
  "CLP": "Chilean Peso",
  "CNH": "Chinese Yuan (Offshore)",
  "CNY": "Chinese Yuan",
  "COP": "Colombian Peso",
  "CRC": "Costa Rican Colón",
  "CUC": "Cuban Convertible Peso",
  "CUP": "Cuban Peso",
  "CVE": "Cape Verdean Escudo",
  "CZK": "Czech Republic Koruna",
  "DJF": "Djiboutian Franc",
  "DKK": "Danish Krone",
  "DOP": "Dominican Peso",
  "DZD": "Algerian Dinar",
  "EGP": "Egyptian Pound",
  "ERN": "Eritrean Nakfa",
  "ETB": "Ethiopian Birr",
  "EUR": "Euro",
  "FJD": "Fijian Dollar",
  "FKP": "Falkland Islands Pound",
  "GBP": "British Pound Sterling",
  "GEL": "Georgian Lari",
  "GGP": "Guernsey Pound",
  "GHS": "Ghanaian Cedi",
  "GIP": "Gibraltar Pound",
  "GMD": "Gambian Dalasi",
  "GNF": "Guinean Franc",
  "GTQ": "Guatemalan Quetzal",
  "GYD": "Guyanaese Dollar",
  "HKD": "Hong Kong Dollar",
  "HNL": "Honduran Lempira",
  "HRK": "Croatian Kuna",
  "HTG": "Haitian Gourde",
  "HUF": "Hungarian Forint",
  "IDR": "Indonesian Rupiah",
  "ILS": "Israeli New Sheqel",
  "IMP": "Manx pound",
  "INR": "Indian Rupee",
  "IQD": "Iraqi Dinar",
  "IRR": "Iranian Rial",
  "ISK": "Icelandic Króna",
  "JEP": "Jersey Pound",
  "JMD": "Jamaican Dollar",
  "JOD": "Jordanian Dinar",
  "JPY": "Japanese Yen",
  "KES": "Kenyan Shilling",
  "KGS": "Kyrgystani Som",
  "KHR": "Cambodian Riel",
  "KMF": "Comorian Franc",
  "KPW": "North Korean Won",
  "KRW": "South Korean Won",
  "KWD": "Kuwaiti Dinar",
  "KYD": "Cayman Islands Dollar",
  "KZT": "Kazakhstani Tenge",
  "LAK": "Laotian Kip",
  "LBP": "Lebanese Pound",
  "LKR": "Sri Lankan Rupee",
  "LRD": "Liberian Dollar",
  "LSL": "Lesotho Loti",
  "LYD": "Libyan Dinar",
  "MAD": "Moroccan Dirham",
  "MDL": "Moldovan Leu",
  "MGA": "Malagasy Ariary",
  "MKD": "Macedonian Denar",
  "MMK": "Myanma Kyat",
  "MNT": "Mongolian Tugrik",
  "MOP": "Macanese Pataca",
  "MRO": "Mauritanian Ouguiya",
  "MUR": "Mauritian Rupee",
  "MVR": "Maldivian Rufiyaa",
  "MWK": "Malawian Kwacha",
  "MXN": "Mexican Peso",
  "MYR": "Malaysian Ringgit",
  "MZN": "Mozambican Metical",
  "NAD": "Namibian Dollar",
  "NGN": "Nigerian Naira",
  "NIO": "Nicaraguan Córdoba",
  "NOK": "Norwegian Krone",
  "NPR": "Nepalese Rupee",
  "NZD": "New Zealand Dollar",
  "OMR": "Omani Rial",
  "PAB": "Panamanian Balboa",
  "PEN": "Peruvian Nuevo Sol",
  "PGK": "Papua New Guinean Kina",
  "PHP": "Philippine Peso",
  "PKR": "Pakistani Rupee",
  "PLN": "Polish Zloty",
  "PYG": "Paraguayan Guarani",
  "QAR": "Qatari Rial",
  "RON": "Romanian Leu",
  "RSD": "Serbian Dinar",
  "RUB": "Russian Ruble",
  "RWF": "Rwandan Franc",
  "SAR": "Saudi Riyal",
  "SBD": "Solomon Islands Dollar",
  "SCR": "Seychellois Rupee",
  "SDG": "Sudanese Pound",
  "SEK": "Swedish Krona",
  "SGD": "Singapore Dollar",
  "SHP": "Saint Helena Pound",
  "SLL": "Sierra Leonean Leone",
  "SOS": "Somali Shilling",
  "SRD": "Surinamese Dollar",
  "SSP": "South Sudanese Pound",
  "STD": "São Tomé and Príncipe Dobra",
  "SVC": "Salvadoran Colón",
  "SYP": "Syrian Pound",
  "SZL": "Swazi Lilangeni",
  "THB": "Thai Baht",
  "TJS": "Tajikistani Somoni",
  "TMT": "Turkmenistani Manat",
  "TND": "Tunisian Dinar",
  "TOP": "Tongan Pa'anga",
  "TRY": "Turkish Lira",
  "TTD": "Trinidad and Tobago Dollar",
  "TWD": "New Taiwan Dollar",
  "TZS": "Tanzanian Shilling",
  "UAH": "Ukrainian Hryvnia",
  "UGX": "Ugandan Shilling",
  "USD": "United States Dollar",
  "UYU": "Uruguayan Peso",
  "UZS": "Uzbekistan Som",
  "VEF": "Venezuelan Bolívar Fuerte",
  "VND": "Vietnamese Dong",
  "VUV": "Vanuatu Vatu",
  "WST": "Samoan Tala",
  "XAF": "CFA Franc BEAC",
  "XAG": "Silver Ounce",
  "XAU": "Gold Ounce",
  "XCD": "East Caribbean Dollar",
  "XDR": "Special Drawing Rights",
  "XOF": "CFA Franc BCEAO",
  "XPD": "Palladium Ounce",
  "XPF": "CFP Franc",
  "XPT": "Platinum Ounce",
  "YER": "Yemeni Rial",
  "ZAR": "South African Rand",
  "ZMW": "Zambian Kwacha",
  "ZWL": "Zimbabwean Dollar"
}
*/


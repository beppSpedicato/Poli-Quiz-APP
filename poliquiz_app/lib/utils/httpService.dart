import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Classe che permette di fare richieste get e post verso degli endpoint.
///
/// Costanti:
/// - OK: è andato tutto a buon fine
/// - DOMAIN_NOT_RESOLVED: la richiesta non è stata fatta inquanto il dominio non può essere risolto
/// - GENERIC_API_ERROR: l'api non ha tornato 200
class HttpService {
  late String baseurl;

  static const int OK = 0;
  static const int DOMAIN_NOT_RESOLVED = 1;
  static const int GENERIC_API_ERROR = 2;
  static const int API_RESPONSE_FORMAT_ERROR = 3;

  /// Costruttore
  ///
  /// Parametri:
  /// - baseurl: String contenente l'url comune a tutte le risorse
  ///    Es: `'https://example.org'`
  HttpService(String baseurl) {
    this.baseurl = Uri.encodeFull(baseurl);
  }

  /// Funzione per inviare una richiesta get.
  ///
  /// Parametri:
  /// - url: Stringa della risorsa da raggiungere
  ///    Es: `'/data'`
  ///
  /// Ritorna:
  /// - ok: bool che permette di capire se la chiamata è andata a buon fine
  /// - code int che indica uno specifico errore (solo se ok: false)
  /// - err? dynamic che contiene eventuale errore (solo se ok: false)
  /// - data? dynamic contenente eventuali dati (solo se ok: true)
  Future<Map<String, dynamic>> get(String url) async {
    debugPrint("GET: " + Uri.parse(this.baseurl + url).toString());

    url = Uri.encodeFull(url);

    http.Response res;
    try {
      res = await http.get(Uri.parse(this.baseurl + url));
    } catch (e) {
      return {'ok': false, 'err': e, 'code': DOMAIN_NOT_RESOLVED};
    }

    if (res.statusCode == 200) {
      try {
        return {'ok': true, 'data': jsonDecode(res.body), 'code': OK};
      } catch (e) {
        return {'ok': false, 'err': e, 'code': API_RESPONSE_FORMAT_ERROR};
      }
    }

    return {'ok': false, 'code': GENERIC_API_ERROR};
  }
}
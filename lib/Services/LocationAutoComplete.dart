import 'dart:convert';
import 'package:http/http.dart' as http;

class AutoComplete {
  static Future<List> getSuggestions(String query) async {
    var url = "https://api.tomtom.com/search/2/search/"+query+".json?limit=5&countrySet=IN&key=D9T3HvijBqZXoLVYE3ClkLlWw7WGuF1k";
    final response = await http.get(url);
    List list = new List();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      list =  data['results'] as List;
    }  
    return list;
  }
} 
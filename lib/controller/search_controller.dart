import 'dart:convert';
import "package:get/get.dart";
import "package:http/http.dart" as http;
import 'package:des_plugin/des_plugin.dart';

class SearchController extends GetxController {
  String result = "";
  String kUrl = "", rawkUrl;
  List searchedList = [];
  String key = "38346591";

  Future fetchSongsList(searchQuery) async {
    String searchUrl =
        "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&query=" +
            searchQuery +
            "&__call=autocomplete.get";
    var responseJson = await http
        .get(Uri.parse(searchUrl), headers: {"Accept": "application/json"});
    var responseEdited = (responseJson.body).split("-->");
    var getMain = json.decode(responseEdited[1]);
    print(getMain);
    searchedList = getMain["songs"]["data"];

    for (int i = 0; i < searchedList.length; i++) {
      searchedList[i]['title'] = searchedList[i]['title']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\"");

      searchedList[i]['more_info']['singers'] = searchedList[i]['more_info']
              ['singers']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\"");
    }
    update();
  }

  Future songDetails(String id) async {
    var url =
        "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&__call=song.getDetails&pids=" +
            id;
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var responseEdited = (response.body).split("-->");
    var result = json.decode(responseEdited[1]);

    kUrl = await DesPlugin.decrypt(
        key, result[id]["more_info"]["encrypted_media_url"]);

    return kUrl;
  }
}

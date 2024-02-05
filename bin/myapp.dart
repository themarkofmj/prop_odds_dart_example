import 'package:myapp/myapp.dart' as myapp;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String baseUrl = 'api.prop-odds.com';
String apiKey = lBKQEnPNHYbC2QGyQCom2WT1qixLo3VW0t6aFi4
	


Future<Map<String, dynamic>> getRequest(Uri url) async {
	var response = await http.get(url);
	if (response.statusCode == 200) {
		return convert.jsonDecode(response.body) as Map<String, dynamic>;
	}
	print('Request failed with status: ${response.statusCode}.');
	return {};
}


Future<Map<String, dynamic>> getNbaGames() async {
	var now = new DateTime.now();
	var formatter = new DateFormat('yyyy-MM-dd');
	var queryParams = {
		'date': formatter.format(now),
		'tz': 'America/New_York',
		'api_key': apiKey,
	};
	var url = Uri.https(baseUrl, '/beta/games/nba', queryParams);
	return await getRequest(url);
}


Future<Map<String, dynamic>> getGameInfo(String gameId) async {
	var queryParams = {
		'api_key': apiKey,
	};
	var url = Uri.https(baseUrl, '/beta/game/' + gameId, queryParams);
	return await getRequest(url);
}


Future<Map<String, dynamic>> getMarkets(String gameId) async {
	var queryParams = {
		'api_key': apiKey,
	};
	var url = Uri.https(baseUrl, '/beta/markets/' + gameId, queryParams);
	return await getRequest(url);
}


Future<Map<String, dynamic>> getMostRecentOdds(String gameId, String market) async {
	var queryParams = {
		'api_key': apiKey,
	};
	var url = Uri.https(baseUrl, '/beta/odds/' + gameId + '/' + market, queryParams);
	return await getRequest(url);
}


Future<void> main(List<String> arguments) async {
	var games = await getNbaGames();
	if (games['games'].length == 0) {
		print('No games scheduled for today.');
		return;
	}

	var firstGame = games['games'][0];
	var gameId = firstGame['game_id'];
	// print(firstGame);
	var gameInfo = await getGameInfo(gameId);
	// print(gameInfo);
	
	var markets = await getMarkets(gameId);
	// print(markets);
	if (markets['markets'].length == 0) {
		print('No markets found.');
		return;
	}

	var firstMarket = markets['markets'][0];
	// print(firstMarket);
	var odds = await getMostRecentOdds(gameId, firstMarket['name']);
	print(odds);
}



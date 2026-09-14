// ignore_for_file: avoid_print
import 'package:ppplayer/core/db/app_database.dart';

void main() async {
  final db = AppDatabase(null);
  print('Running query 1...');
  try {
    await db.getRecentlyPlayed(limit: 5);
  } catch (e) {
    print('Query 1 threw: $e');
  }

  print('Running query 2...');
  try {
    await (db.select(db.catalogCacheEntries)).getSingleOrNull();
  } catch (e) {
    print('Query 2 threw: $e');
  }
}

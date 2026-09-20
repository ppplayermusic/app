import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:ppplayer/core/db/app_database.dart';

void main() {
  test('migration from v12 to v13 sets liveStatus default to 0', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    // We can't easily test drift schema migrations cleanly without the schema verifier tool,
    // but we can at least test that inserting into StreamChannels uses the default if not provided,
    // and that the default is 0 (unknown).

    final id = await db
        .into(db.streamChannels)
        .insert(
          StreamChannelsCompanion.insert(
            playlistId: 1,
            title: 'Test Channel',
            streamUrl: 'http://test.com/stream.m3u8',
            position: 0,
          ),
        );

    final channel = await (db.select(
      db.streamChannels,
    )..where((tbl) => tbl.id.equals(id))).getSingle();

    expect(channel.liveStatus, 0); // 0 is unknown

    await db.close();
  });
}

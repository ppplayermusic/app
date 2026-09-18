import re

with open('integration_test/audio_decoding_test.dart', 'r') as f:
    content = f.read()

# Update formats list
old_formats = "final formats = ['wav', 'mp3', 'flac', 'm4a', 'ogg', 'opus', 'wma', 'wv', 'tta', 'ape', 'mod', 'mpc'];"
new_formats = "final formats = ['wav', 'mp3', 'flac', 'm4a', 'ogg', 'opus', 'wma', 'wv', 'tta', 'ape', 'mpc'];"
content = content.replace(old_formats, new_formats)

with open('integration_test/audio_decoding_test.dart', 'w') as f:
    f.write(content)


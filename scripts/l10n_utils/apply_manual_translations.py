import json
import os

translations = {
    'en': ['All', 'Playlists', 'Artists', 'Albums', 'Stations', 'Local Music', 'Create Playlist', 'Radio Stations', 'Discover Music', 'Import Local Music', 'Import Audio Files', 'Import Folder'],
    'ar': ['الكل', 'قوائم التشغيل', 'الفنانون', 'الألبومات', 'المحطات', 'موسيقى محلية', 'إنشاء قائمة تشغيل', 'محطات الراديو', 'اكتشاف الموسيقى', 'استيراد موسيقى محلية', 'استيراد ملفات صوتية', 'استيراد مجلد'],
    'bn': ['সব', 'প্লেলিস্ট', 'শিল্পীরা', 'অ্যালবাম', 'স্টেশন', 'স্থানীয় সঙ্গীত', 'প্লেলিস্ট তৈরি করুন', 'রেডিও স্টেশন', 'সঙ্গীত আবিষ্কার করুন', 'স্থানীয় সঙ্গীত আমদানি করুন', 'অডিও ফাইল আমদানি করুন', 'ফোল্ডার আমদানি করুন'],
    'cs': ['Vše', 'Playlisty', 'Umělci', 'Alba', 'Stanice', 'Místní hudba', 'Vytvořit playlist', 'Rádiové stanice', 'Objevovat hudbu', 'Importovat místní hudbu', 'Importovat zvukové soubory', 'Importovat složku'],
    'da': ['Alt', 'Playlister', 'Kunstnere', 'Album', 'Stationer', 'Lokal musik', 'Opret playliste', 'Radiostationer', 'Opdag musik', 'Importer lokal musik', 'Importer lydfiler', 'Importer mappe'],
    'de': ['Alle', 'Playlists', 'Künstler', 'Alben', 'Sender', 'Lokale Musik', 'Playlist erstellen', 'Radiosender', 'Musik entdecken', 'Lokale Musik importieren', 'Audiodateien importieren', 'Ordner importieren'],
    'es': ['Todo', 'Listas', 'Artistas', 'Álbumes', 'Estaciones', 'Música local', 'Crear lista', 'Estaciones de radio', 'Descubrir música', 'Importar música local', 'Importar archivos', 'Importar carpeta'],
    'et': ['Kõik', 'Esitusloendid', 'Artistid', 'Albumid', 'Jaamad', 'Kohalik muusika', 'Loo esitusloend', 'Raadiojaamad', 'Avasta muusikat', 'Impordi kohalik muusika', 'Impordi helifailid', 'Impordi kaust'],
    'fa': ['همه', 'پلی‌لیست‌ها', 'هنرمندان', 'آلبوم‌ها', 'ایستگاه‌ها', 'موسیقی محلی', 'ایجاد پلی‌لیست', 'ایستگاه‌های رادیویی', 'کشف موسیقی', 'وارد کردن موسیقی محلی', 'وارد کردن فایل‌های صوتی', 'وارد کردن پوشه'],
    'fil': ['Lahat', 'Mga Playlist', 'Mga Artista', 'Mga Album', 'Mga Istasyon', 'Lokal na Musika', 'Gumawa ng Playlist', 'Mga Istasyon ng Radyo', 'Tuklasin ang Musika', 'I-import ang Lokal na Musika', 'I-import ang Mga Audio File', 'I-import ang Folder'],
    'fr': ['Tout', 'Playlists', 'Artistes', 'Albums', 'Stations', 'Musique locale', 'Créer une playlist', 'Stations de radio', 'Découvrir la musique', 'Importer de la musique locale', 'Importer des fichiers audio', 'Importer un dossier'],
    'gn': ['Opaite', 'Tysýi', 'Mba\'epuapohára', 'Mba\'epu\'aty', 'Ñe\'ẽasãiha', 'Mba\'epu ñande mba\'e', 'Apo tysýi', 'Ñe\'ẽasãiha', 'Juhu mba\'epu', 'Gueru mba\'epu', 'Gueru ñe\'ẽryru', 'Gueru ñongatuha'],
    'hi': ['सभी', 'प्लेलिस्ट', 'कलाकार', 'एल्बम', 'स्टेशन', 'स्थानीय संगीत', 'प्लेलिस्ट बनाएं', 'रेडियो स्टेशन', 'संगीत खोजें', 'स्थानीय संगीत आयात करें', 'ऑडियो फ़ाइलें आयात करें', 'फ़ोल्डर आयात करें'],
    'hr': ['Sve', 'Popisi za reprodukciju', 'Izvođači', 'Albumi', 'Postaje', 'Lokalna glazba', 'Stvori popis za reprodukciju', 'Radiopostaje', 'Otkrij glazbu', 'Uvezi lokalnu glazbu', 'Uvezi audio datoteke', 'Uvezi mapu'],
    'hu': ['Összes', 'Lejátszási listák', 'Előadók', 'Albumok', 'Állomások', 'Helyi zene', 'Lejátszási lista létrehozása', 'Rádióállomások', 'Zene felfedezése', 'Helyi zene importálása', 'Audiofájlok importálása', 'Mappa importálása'],
    'id': ['Semua', 'Daftar Putar', 'Artis', 'Album', 'Stasiun', 'Musik Lokal', 'Buat Daftar Putar', 'Stasiun Radio', 'Temukan Musik', 'Impor Musik Lokal', 'Impor File Audio', 'Impor Folder'],
    'it': ['Tutto', 'Playlist', 'Artisti', 'Album', 'Stazioni', 'Musica locale', 'Crea playlist', 'Stazioni radio', 'Scopri musica', 'Importa musica locale', 'Importa file audio', 'Importa cartella'],
    'ja': ['すべて', 'プレイリスト', 'アーティスト', 'アルバム', 'ステーション', 'ローカルの音楽', 'プレイリストを作成', 'ラジオステーション', '音楽を見つける', 'ローカル音楽をインポート', 'オーディオファイルをインポート', 'フォルダをインポート'],
    'ka': ['ყველა', 'დასაკრავი სიები', 'შემსრულებლები', 'ალბომები', 'სადგურები', 'ლოკალური მუსიკა', 'დასაკრავი სიის შექმნა', 'რადიოსადგურები', 'აღმოაჩინე მუსიკა', 'ლოკალური მუსიკის იმპორტი', 'აუდიო ფაილების იმპორტი', 'საქაღალდის იმპორტი'],
    'kk': ['Барлығы', 'Ойнату тізімдері', 'Әртістер', 'Альбомдар', 'Станциялар', 'Жергілікті музыка', 'Ойнату тізімін жасау', 'Радиостанциялар', 'Музыканы табу', 'Жергілікті музыканы импорттау', 'Аудио файлдарды импорттау', 'Қалтаны импорттау'],
    'ko': ['모두', '플레이리스트', '아티스트', '앨범', '스테이션', '로컬 음악', '플레이리스트 만들기', '라디오 스테이션', '음악 찾기', '로컬 음악 가져오기', '오디오 파일 가져오기', '폴더 가져오기'],
    'lv': ['Viss', 'Atskaņošanas saraksti', 'Mākslinieki', 'Albumi', 'Stacijas', 'Vietējā mūzika', 'Izveidot atskaņošanas sarakstu', 'Radiostacijas', 'Atklāt mūziku', 'Importēt vietējo mūziku', 'Importēt audio failus', 'Importēt mapi'],
    'ms': ['Semua', 'Senarai Main', 'Artis', 'Album', 'Stesen', 'Muzik Tempatan', 'Cipta Senarai Main', 'Stesen Radio', 'Temui Muzik', 'Import Muzik Tempatan', 'Import Fail Audio', 'Import Folder'],
    'my': ['အားလုံး', 'အစီအစဉ်များ', 'အနုပညာရှင်များ', 'အယ်လ်ဘမ်များ', 'စခန်းများ', 'ပြည်တွင်းတေးဂီတ', 'အစီအစဉ်ဖန်တီးရန်', 'ရေဒီယိုစခန်းများ', 'တေးဂီတရှာဖွေရန်', 'ပြည်တွင်းတေးဂီတသွင်းရန်', 'အသံဖိုင်များသွင်းရန်', 'ဖိုင်တွဲသွင်းရန်'],
    'pcm': ['All', 'Playlists', 'Artists', 'Albums', 'Stations', 'Local Music', 'Create Playlist', 'Radio Stations', 'Discover Music', 'Import Local Music', 'Import Audio Files', 'Import Folder'],
    'pl': ['Wszystko', 'Playlisty', 'Artyści', 'Albumy', 'Stacje', 'Lokalna muzyka', 'Utwórz playlistę', 'Stacje radiowe', 'Odkrywaj muzykę', 'Importuj lokalną muzykę', 'Importuj pliki audio', 'Importuj folder'],
    'pt': ['Tudo', 'Playlists', 'Artistas', 'Álbuns', 'Estações', 'Música Local', 'Criar Playlist', 'Estações de Rádio', 'Descobrir Música', 'Importar Música Local', 'Importar Arquivos de Áudio', 'Importar Pasta'],
    'ru': ['Все', 'Плейлисты', 'Артисты', 'Альбомы', 'Станции', 'Локальная музыка', 'Создать плейлист', 'Радиостанции', 'Искать музыку', 'Импорт локальной музыки', 'Импорт аудиофайлов', 'Импорт папки'],
    'sv': ['Allt', 'Spellistor', 'Artister', 'Album', 'Stationer', 'Lokal musik', 'Skapa spellista', 'Radiostationer', 'Upptäck musik', 'Importera lokal musik', 'Importera ljudfiler', 'Importera mapp'],
    'uz': ['Barchasi', 'Pley-listlar', 'Ijrochilar', 'Albomlar', 'Stansiyalar', 'Mahalliy musiqa', 'Pley-list yaratish', 'Radio stansiyalar', 'Musiqa kashf etish', 'Mahalliy musiqani import qilish', 'Audio fayllarni import qilish', 'Jildni import qilish'],
    'zh': ['全部', '播放列表', '艺术家', '专辑', '电台', '本地音乐', '创建播放列表', '广播电台', '发现音乐', '导入本地音乐', '导入音频文件', '导入文件夹']
}

keys = [
    'filterAll', 'filterPlaylists', 'filterArtists', 'filterAlbums', 'filterStations', 
    'localMusicCard', 'createPlaylistButton', 'radioStations', 'discoverMusic', 
    'importLocalMusic', 'importAudioFiles', 'importFolder'
]

for code, values in translations.items():
    file_path = f'lib/l10n/app_{code}.arb'
    if not os.path.exists(file_path):
        continue
        
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    for i, key in enumerate(keys):
        data[key] = values[i]
        data[f"@{key}"] = {}
        
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f"Updated {file_path}")

print("Manual translations applied successfully!")

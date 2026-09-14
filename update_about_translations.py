import json
import os
import glob

translations = {
    'en': {'aboutDescription': 'A free, open-source music player.', 'versionInfo': 'Version {version} (Build {build})', 'createdBy': 'Created by Lucas Coelho', 'website': 'Website', 'github': 'GitHub', 'releaseNotes': 'Release notes', 'support': 'Support', 'license': 'License', 'acknowledgments': 'Acknowledgments', 'close': 'Close'},
    'pt': {'aboutDescription': 'Um reprodutor de música gratuito e de código aberto.', 'versionInfo': 'Versão {version} (Build {build})', 'createdBy': 'Criado por Lucas Coelho', 'website': 'Site', 'github': 'GitHub', 'releaseNotes': 'Notas de lançamento', 'support': 'Suporte', 'license': 'Licença', 'acknowledgments': 'Agradecimentos', 'close': 'Fechar'},
    'es': {'aboutDescription': 'Un reproductor de música gratuito y de código abierto.', 'versionInfo': 'Versión {version} (Build {build})', 'createdBy': 'Creado por Lucas Coelho', 'website': 'Sitio web', 'github': 'GitHub', 'releaseNotes': 'Notas de la versión', 'support': 'Soporte', 'license': 'Licencia', 'acknowledgments': 'Agradecimientos', 'close': 'Cerrar'},
    'de': {'aboutDescription': 'Ein kostenloser Open-Source-Musikplayer.', 'versionInfo': 'Version {version} (Build {build})', 'createdBy': 'Erstellt von Lucas Coelho', 'website': 'Webseite', 'github': 'GitHub', 'releaseNotes': 'Versionshinweise', 'support': 'Support', 'license': 'Lizenz', 'acknowledgments': 'Danksagungen', 'close': 'Schließen'},
    'it': {'aboutDescription': 'Un riproduttore musicale gratuito e open-source.', 'versionInfo': 'Versione {version} (Build {build})', 'createdBy': 'Creato da Lucas Coelho', 'website': 'Sito web', 'github': 'GitHub', 'releaseNotes': 'Note di rilascio', 'support': 'Supporto', 'license': 'Licenza', 'acknowledgments': 'Ringraziamenti', 'close': 'Chiudi'},
    'fr': {'aboutDescription': 'Un lecteur de musique gratuit et open-source.', 'versionInfo': 'Version {version} (Build {build})', 'createdBy': 'Créé par Lucas Coelho', 'website': 'Site web', 'github': 'GitHub', 'releaseNotes': 'Notes de version', 'support': 'Assistance', 'license': 'Licence', 'acknowledgments': 'Remerciements', 'close': 'Fermer'},
    'ru': {'aboutDescription': 'Бесплатный музыкальный плеер с открытым исходным кодом.', 'versionInfo': 'Версия {version} (Сборка {build})', 'createdBy': 'Создано Lucas Coelho', 'website': 'Веб-сайт', 'github': 'GitHub', 'releaseNotes': 'Примечания к выпуску', 'support': 'Поддержка', 'license': 'Лицензия', 'acknowledgments': 'Благодарности', 'close': 'Закрыть'},
    'zh': {'aboutDescription': '一个免费的开源音乐播放器。', 'versionInfo': '版本 {version} (Build {build})', 'createdBy': '由 Lucas Coelho 创建', 'website': '网站', 'github': 'GitHub', 'releaseNotes': '发行说明', 'support': '支持', 'license': '许可协议', 'acknowledgments': '鸣谢', 'close': '关闭'},
    'ja': {'aboutDescription': '無料のオープンソース音楽プレーヤー。', 'versionInfo': 'バージョン {version} (ビルド {build})', 'createdBy': 'Lucas Coelho による作成', 'website': 'ウェブサイト', 'github': 'GitHub', 'releaseNotes': 'リリースノート', 'support': 'サポート', 'license': 'ライセンス', 'acknowledgments': '謝辞', 'close': '閉じる'},
    'ko': {'aboutDescription': '무료 오픈 소스 음악 플레이어입니다.', 'versionInfo': '버전 {version} (빌드 {build})', 'createdBy': 'Lucas Coelho 제작', 'website': '웹사이트', 'github': 'GitHub', 'releaseNotes': '릴리스 노트', 'support': '지원', 'license': '라이선스', 'acknowledgments': '감사', 'close': '닫기'},
    'hi': {'aboutDescription': 'एक मुफ़्त, ओपन-सोर्स म्यूज़िक प्लेयर।', 'versionInfo': 'संस्करण {version} (बिल्ड {build})', 'createdBy': 'Lucas Coelho द्वारा निर्मित', 'website': 'वेबसाइट', 'github': 'GitHub', 'releaseNotes': 'रिलीज़ नोट्स', 'support': 'समर्थन', 'license': 'लाइसेंस', 'acknowledgments': 'आभार', 'close': 'बंद करें'},
    'ar': {'aboutDescription': 'مشغل موسيقى مجاني ومفتوح المصدر.', 'versionInfo': 'الإصدار {version} (النسخة {build})', 'createdBy': 'تم الإنشاء بواسطة Lucas Coelho', 'website': 'الموقع الإلكتروني', 'github': 'GitHub', 'releaseNotes': 'ملاحظات الإصدار', 'support': 'الدعم', 'license': 'الترخيص', 'acknowledgments': 'شكر وتقدير', 'close': 'إغلاق'},
    'id': {'aboutDescription': 'Pemutar musik sumber terbuka dan gratis.', 'versionInfo': 'Versi {version} (Build {build})', 'createdBy': 'Dibuat oleh Lucas Coelho', 'website': 'Situs Web', 'github': 'GitHub', 'releaseNotes': 'Catatan rilis', 'support': 'Dukungan', 'license': 'Lisensi', 'acknowledgments': 'Penghargaan', 'close': 'Tutup'},
    'tr': {'aboutDescription': 'Ücretsiz, açık kaynaklı bir müzik çalar.', 'versionInfo': 'Sürüm {version} (Yapı {build})', 'createdBy': 'Lucas Coelho tarafından oluşturuldu', 'website': 'Web sitesi', 'github': 'GitHub', 'releaseNotes': 'Sürüm notları', 'support': 'Destek', 'license': 'Lisans', 'acknowledgments': 'Teşekkürler', 'close': 'Kapat'},
    'nl': {'aboutDescription': 'Een gratis, open-source muziekspeler.', 'versionInfo': 'Versie {version} (Build {build})', 'createdBy': 'Gemaakt door Lucas Coelho', 'website': 'Website', 'github': 'GitHub', 'releaseNotes': 'Release-opmerkingen', 'support': 'Ondersteuning', 'license': 'Licentie', 'acknowledgments': 'Dankbetuigingen', 'close': 'Sluiten'},
    'pl': {'aboutDescription': 'Darmowy odtwarzacz muzyki o otwartym kodzie źródłowym.', 'versionInfo': 'Wersja {version} (Kompilacja {build})', 'createdBy': 'Stworzone przez Lucas Coelho', 'website': 'Strona internetowa', 'github': 'GitHub', 'releaseNotes': 'Informacje o wydaniu', 'support': 'Wsparcie', 'license': 'Licencja', 'acknowledgments': 'Podziękowania', 'close': 'Zamknij'},
    'sv': {'aboutDescription': 'En gratis musikspelare med öppen källkod.', 'versionInfo': 'Version {version} (Bygge {build})', 'createdBy': 'Skapad av Lucas Coelho', 'website': 'Webbplats', 'github': 'GitHub', 'releaseNotes': 'Versionsfakta', 'support': 'Support', 'license': 'Licens', 'acknowledgments': 'Erkännanden', 'close': 'Stäng'},
    'da': {'aboutDescription': 'En gratis open source musikafspiller.', 'versionInfo': 'Version {version} (Build {build})', 'createdBy': 'Oprettet af Lucas Coelho', 'website': 'Hjemmeside', 'github': 'GitHub', 'releaseNotes': 'Udgivelsesnoter', 'support': 'Support', 'license': 'Licens', 'acknowledgments': 'Anerkendelser', 'close': 'Luk'},
    'cs': {'aboutDescription': 'Bezplatný hudební přehrávač s otevřeným zdrojovým kódem.', 'versionInfo': 'Verze {version} (Sestavení {build})', 'createdBy': 'Vytvořil Lucas Coelho', 'website': 'Webová stránka', 'github': 'GitHub', 'releaseNotes': 'Poznámky k vydání', 'support': 'Podpora', 'license': 'Licence', 'acknowledgments': 'Poděkování', 'close': 'Zavřít'},
    'hu': {'aboutDescription': 'Egy ingyenes, nyílt forráskódú zenelejátszó.', 'versionInfo': 'Verzió {version} (Build {build})', 'createdBy': 'Készítette: Lucas Coelho', 'website': 'Weboldal', 'github': 'GitHub', 'releaseNotes': 'Kiadási megjegyzések', 'support': 'Támogatás', 'license': 'Licenc', 'acknowledgments': 'Köszönetnyilvánítás', 'close': 'Bezárás'},
    'fil': {'aboutDescription': 'Isang libre at open-source na music player.', 'versionInfo': 'Bersyon {version} (Build {build})', 'createdBy': 'Nilikha ni Lucas Coelho', 'website': 'Website', 'github': 'GitHub', 'releaseNotes': 'Mga tala sa pag-release', 'support': 'Suporta', 'license': 'Lisensya', 'acknowledgments': 'Mga Pasasalamat', 'close': 'Isara'},
    'ms': {'aboutDescription': 'Pemain muzik sumber terbuka percuma.', 'versionInfo': 'Versi {version} (Binaan {build})', 'createdBy': 'Dicipta oleh Lucas Coelho', 'website': 'Laman Web', 'github': 'GitHub', 'releaseNotes': 'Nota keluaran', 'support': 'Sokongan', 'license': 'Lesen', 'acknowledgments': 'Penghargaan', 'close': 'Tutup'},
    'hr': {'aboutDescription': 'Besplatni glazbeni player otvorenog koda.', 'versionInfo': 'Verzija {version} (Međuverzija {build})', 'createdBy': 'Autor: Lucas Coelho', 'website': 'Web stranica', 'github': 'GitHub', 'releaseNotes': 'Napomene o izdanju', 'support': 'Podrška', 'license': 'Licenca', 'acknowledgments': 'Zahvale', 'close': 'Zatvori'},
    'et': {'aboutDescription': 'Tasuta avatud lähtekoodiga muusikapleier.', 'versionInfo': 'Versioon {version} (Järk {build})', 'createdBy': 'Loodud Lucas Coelho poolt', 'website': 'Veebileht', 'github': 'GitHub', 'releaseNotes': 'Väljalaskemärkmed', 'support': 'Tugi', 'license': 'Litsents', 'acknowledgments': 'Tunnustused', 'close': 'Sulge'},
    'fa': {'aboutDescription': 'یک پخش‌کننده موسیقی رایگان و منبع‌باز.', 'versionInfo': 'نسخه {version} (ساخت {build})', 'createdBy': 'ایجاد شده توسط Lucas Coelho', 'website': 'وب‌سایت', 'github': 'GitHub', 'releaseNotes': 'یادداشت‌های انتشار', 'support': 'پشتیبانی', 'license': 'مجوز', 'acknowledgments': 'قدردانی‌ها', 'close': 'بستن'},
    'lv': {'aboutDescription': 'Bezmaksas atvērtā pirmkoda mūzikas atskaņotājs.', 'versionInfo': 'Versija {version} (Būvējums {build})', 'createdBy': 'Izveidoja Lucas Coelho', 'website': 'Tīmekļa vietne', 'github': 'GitHub', 'releaseNotes': 'Izlaiduma piezīmes', 'support': 'Atbalsts', 'license': 'Licence', 'acknowledgments': 'Pateicības', 'close': 'Aizvērt'},
    'my': {'aboutDescription': 'အခမဲ့ပွင့်လင်းအရင်းအမြစ်တေးဂီတဖွင့်စက်။', 'versionInfo': 'ဗားရှင်း {version} (တည်ဆောက်မှု {build})', 'createdBy': 'Lucas Coelho ဖန်တီးသည်', 'website': 'ဝဘ်ဆိုက်', 'github': 'GitHub', 'releaseNotes': 'ထွက်ရှိမှုမှတ်စုများ', 'support': 'ပံ့ပိုးမှု', 'license': 'လိုင်စင်', 'acknowledgments': 'ကျေးဇူးတင်လွှာ', 'close': 'ပိတ်မည်'},
    'uz': {'aboutDescription': 'Bepul va ochiq kodli musiqa pleyeri.', 'versionInfo': 'Versiya {version} (Yig\'ilish {build})', 'createdBy': 'Lucas Coelho tomonidan yaratilgan', 'website': 'Veb-sayt', 'github': 'GitHub', 'releaseNotes': 'Reliz qaydlari', 'support': 'Qo\'llab-quvvatlash', 'license': 'Litsenziya', 'acknowledgments': 'Minnatdorchilik', 'close': 'Yopish'},
    'kk': {'aboutDescription': 'Тегін және ашық бастапқы кодты музыкалық ойнатқыш.', 'versionInfo': 'Нұсқасы {version} (Құрастыру {build})', 'createdBy': 'Lucas Coelho жасаған', 'website': 'Веб-сайт', 'github': 'GitHub', 'releaseNotes': 'Шығарылым жазбалары', 'support': 'Қолдау', 'license': 'Лицензия', 'acknowledgments': 'Алғыстар', 'close': 'Жабу'},
    'gn': {'aboutDescription': 'Peteĩ purahéi ñembopuha ojehepyme\'ẽ\'ỹva ha ojehechaukáva.', 'versionInfo': 'Mba\'e {version} (Mba\'e {build})', 'createdBy': 'Lucas Coelho ojapo', 'website': 'Web', 'github': 'GitHub', 'releaseNotes': 'Marandu sãsõ', 'support': 'Pytyvõ', 'license': 'Liséñsia', 'acknowledgments': 'Aguyje', 'close': 'Mboty'},
    'pcm': {'aboutDescription': 'A free open-source music player.', 'versionInfo': 'Version {version} (Build {build})', 'createdBy': 'Created by Lucas Coelho', 'website': 'Website', 'github': 'GitHub', 'releaseNotes': 'Release notes', 'support': 'Support', 'license': 'License', 'acknowledgments': 'Acknowledgments', 'close': 'Close'},
    'ka': {'aboutDescription': 'უფასო, ღია კოდის მუსიკალური პლეერი.', 'versionInfo': 'ვერსია {version} (შენება {build})', 'createdBy': 'შექმნა Lucas Coelho-მ', 'website': 'ვებსაიტი', 'github': 'GitHub', 'releaseNotes': 'გამოშვების შენიშვნები', 'support': 'მხარდაჭერა', 'license': 'ლიცენზია', 'acknowledgments': 'მადლობები', 'close': 'დახურვა'},
    'bn': {'aboutDescription': 'একটি বিনামূল্যের ওপেন-সোর্স মিউজিক প্লেয়ার।', 'versionInfo': 'সংস্করণ {version} (বিল্ড {build})', 'createdBy': 'Lucas Coelho দ্বারা তৈরি', 'website': 'ওয়েবসাইট', 'github': 'GitHub', 'releaseNotes': 'রিলিজ নোট', 'support': 'সমর্থন', 'license': 'লাইসেন্স', 'acknowledgments': 'স্বীকৃতি', 'close': 'বন্ধ করুন'}
}

# The metadata for ARB file so that placeholders work
meta = {
    "@versionInfo": {
        "placeholders": {
            "version": {},
            "build": {}
        }
    },
    "@copyright": {
        "placeholders": {
            "year": {}
        }
    }
}

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    lang_code = filename.replace('app_', '').replace('.arb', '')
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    t = translations.get(lang_code)
    if not t:
        print(f"Warning: no translation found for {lang_code}, using english")
        t = translations['en']
        
    for k, v in t.items():
        data[k] = v
        
    # Also add copyright manually for all
    data['copyright'] = '© {year} PPPlayer contributors'
        
    # merge meta
    for k, v in meta.items():
        data[k] = v
        
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Injected about dialog strings into all .arb files.")

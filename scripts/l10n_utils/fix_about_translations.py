import json
import os
import glob
import sys

# The missing 11 keys for all 30 languages
# Since most are simple, we will use a small dictionary. 
# Also, we will make sure they match app_en.arb exactly.
about_translations = {
    'ar': {
        "aboutDescription": "مشغل موسيقى مجاني ومفتوح المصدر.", "versionInfo": "الإصدار {version} (النسخة {build})",
        "createdBy": "تم الإنشاء بواسطة Lucas Coelho", "website": "الموقع الإلكتروني", "github": "GitHub",
        "releaseNotes": "ملاحظات الإصدار", "support": "الدعم", "license": "الترخيص", "acknowledgments": "شكر وتقدير",
        "copyright": "© {year} مساهمو PPPlayer", "close": "إغلاق"
    },
    'bn': {
        "aboutDescription": "একটি বিনামূল্যের, ওপেন সোর্স মিউজিক প্লেয়ার।", "versionInfo": "সংস্করণ {version} (বিল্ড {build})",
        "createdBy": "Lucas Coelho দ্বারা তৈরি", "website": "ওয়েবসাইট", "github": "GitHub",
        "releaseNotes": "রিলিজ নোট", "support": "সমর্থন", "license": "লাইসেন্স", "acknowledgments": "স্বীকৃতি",
        "copyright": "© {year} PPPlayer অবদানকারী", "close": "বন্ধ করুন"
    },
    'cs': {
        "aboutDescription": "Bezplatný, open-source hudební přehrávač.", "versionInfo": "Verze {version} (Sestavení {build})",
        "createdBy": "Vytvořil Lucas Coelho", "website": "Webová stránka", "github": "GitHub",
        "releaseNotes": "Poznámky k vydání", "support": "Podpora", "license": "Licence", "acknowledgments": "Poděkování",
        "copyright": "© {year} Přispěvatelé PPPlayer", "close": "Zavřít"
    },
    'da': {
        "aboutDescription": "En gratis, open-source musikafspiller.", "versionInfo": "Version {version} (Build {build})",
        "createdBy": "Skabt af Lucas Coelho", "website": "Hjemmeside", "github": "GitHub",
        "releaseNotes": "Udgivelsesnoter", "support": "Support", "license": "Licens", "acknowledgments": "Anerkendelser",
        "copyright": "© {year} PPPlayer bidragydere", "close": "Luk"
    },
    'de': {
        "aboutDescription": "Ein kostenloser, Open-Source-Musikplayer.", "versionInfo": "Version {version} (Build {build})",
        "createdBy": "Erstellt von Lucas Coelho", "website": "Webseite", "github": "GitHub",
        "releaseNotes": "Versionshinweise", "support": "Support", "license": "Lizenz", "acknowledgments": "Danksagungen",
        "copyright": "© {year} PPPlayer Mitwirkende", "close": "Schließen"
    },
    'es': {
        "aboutDescription": "Un reproductor de música gratuito y de código abierto.", "versionInfo": "Versión {version} (Compilación {build})",
        "createdBy": "Creado por Lucas Coelho", "website": "Sitio web", "github": "GitHub",
        "releaseNotes": "Notas de la versión", "support": "Soporte", "license": "Licencia", "acknowledgments": "Agradecimientos",
        "copyright": "© {year} Colaboradores de PPPlayer", "close": "Cerrar"
    },
    'et': {
        "aboutDescription": "Tasuta avatud lähtekoodiga muusikapleier.", "versionInfo": "Versioon {version} (Järk {build})",
        "createdBy": "Loonud Lucas Coelho", "website": "Veebisait", "github": "GitHub",
        "releaseNotes": "Väljalaskemärkmed", "support": "Tugi", "license": "Litsents", "acknowledgments": "Tunnustused",
        "copyright": "© {year} PPPlayeri panustajad", "close": "Sulge"
    },
    'fa': {
        "aboutDescription": "یک پخش‌کننده موسیقی رایگان و متن‌باز.", "versionInfo": "نسخه {version} (ساخت {build})",
        "createdBy": "ایجاد شده توسط Lucas Coelho", "website": "وب‌سایت", "github": "GitHub",
        "releaseNotes": "یادداشت‌های انتشار", "support": "پشتیبانی", "license": "مجوز", "acknowledgments": "تقدیرنامه‌ها",
        "copyright": "© {year} مشارکت‌کنندگان PPPlayer", "close": "بستن"
    },
    'fil': {
        "aboutDescription": "Isang libre, open-source na music player.", "versionInfo": "Bersyon {version} (Build {build})",
        "createdBy": "Ginawa ni Lucas Coelho", "website": "Website", "github": "GitHub",
        "releaseNotes": "Mga tala sa paglabas", "support": "Suporta", "license": "Lisensya", "acknowledgments": "Mga Pagkilala",
        "copyright": "© {year} Mga nag-ambag sa PPPlayer", "close": "Isara"
    },
    'fr': {
        "aboutDescription": "Un lecteur de musique gratuit et open-source.", "versionInfo": "Version {version} (Build {build})",
        "createdBy": "Créé par Lucas Coelho", "website": "Site web", "github": "GitHub",
        "releaseNotes": "Notes de version", "support": "Assistance", "license": "Licence", "acknowledgments": "Remerciements",
        "copyright": "© {year} Contributeurs de PPPlayer", "close": "Fermer"
    },
    'gn': {
        "aboutDescription": "Peteĩ purahéi ryrúre reigua ha ijehegui.", "versionInfo": "Mba'e {version} (Apopy {build})",
        "createdBy": "Lucas Coelho rembiapokue", "website": "Ñanduti tenda", "github": "GitHub",
        "releaseNotes": "Jekuaaukapy", "support": "Pytyvõ", "license": "Moneĩmby", "acknowledgments": "Aguyje",
        "copyright": "© {year} PPPlayer pytyvõhára", "close": "Mboty"
    },
    'hi': {
        "aboutDescription": "एक निःशुल्क, ओपन-सोर्स म्यूजिक प्लेयर।", "versionInfo": "संस्करण {version} (बिल्ड {build})",
        "createdBy": "Lucas Coelho द्वारा निर्मित", "website": "वेबसाइट", "github": "GitHub",
        "releaseNotes": "रिलीज़ नोट्स", "support": "समर्थन", "license": "लाइसेंस", "acknowledgments": "आभार",
        "copyright": "© {year} PPPlayer योगदानकर्ता", "close": "बंद करें"
    },
    'hr': {
        "aboutDescription": "Besplatan glazbeni svirač otvorenog koda.", "versionInfo": "Verzija {version} (Oznaka međuverzije {build})",
        "createdBy": "Izradio Lucas Coelho", "website": "Web stranica", "github": "GitHub",
        "releaseNotes": "Napomene o izdanju", "support": "Podrška", "license": "Licenca", "acknowledgments": "Zahvale",
        "copyright": "© {year} Suradnici PPPlayer-a", "close": "Zatvori"
    },
    'hu': {
        "aboutDescription": "Egy ingyenes, nyílt forráskódú zenelejátszó.", "versionInfo": "{version}. verzió ({build}. build)",
        "createdBy": "Készítette: Lucas Coelho", "website": "Weboldal", "github": "GitHub",
        "releaseNotes": "Kiadási megjegyzések", "support": "Támogatás", "license": "Licenc", "acknowledgments": "Köszönetnyilvánítások",
        "copyright": "© {year} PPPlayer közreműködők", "close": "Bezárás"
    },
    'id': {
        "aboutDescription": "Pemutar musik sumber terbuka dan gratis.", "versionInfo": "Versi {version} (Build {build})",
        "createdBy": "Dibuat oleh Lucas Coelho", "website": "Situs Web", "github": "GitHub",
        "releaseNotes": "Catatan Rilis", "support": "Dukungan", "license": "Lisensi", "acknowledgments": "Penghargaan",
        "copyright": "© {year} Kontributor PPPlayer", "close": "Tutup"
    },
    'it': {
        "aboutDescription": "Un lettore musicale gratuito e open source.", "versionInfo": "Versione {version} (Build {build})",
        "createdBy": "Creato da Lucas Coelho", "website": "Sito web", "github": "GitHub",
        "releaseNotes": "Note di rilascio", "support": "Supporto", "license": "Licenza", "acknowledgments": "Ringraziamenti",
        "copyright": "© {year} Collaboratori di PPPlayer", "close": "Chiudi"
    },
    'ja': {
        "aboutDescription": "無料のオープンソース音楽プレーヤー。", "versionInfo": "バージョン {version} (ビルド {build})",
        "createdBy": "作成者: Lucas Coelho", "website": "ウェブサイト", "github": "GitHub",
        "releaseNotes": "リリースノート", "support": "サポート", "license": "ライセンス", "acknowledgments": "謝辞",
        "copyright": "© {year} PPPlayer 貢献者", "close": "閉じる"
    },
    'ka': {
        "aboutDescription": "უფასო, ღია კოდის მქონე მუსიკალური პლეერი.", "versionInfo": "ვერსია {version} (Build {build})",
        "createdBy": "შექმნილია Lucas Coelho-ს მიერ", "website": "ვებგვერდი", "github": "GitHub",
        "releaseNotes": "გამოშვების შენიშვნები", "support": "მხარდაჭერა", "license": "ლიცენზია", "acknowledgments": "მადლობები",
        "copyright": "© {year} PPPlayer კონტრიბუტორები", "close": "დახურვა"
    },
    'kk': {
        "aboutDescription": "Тегін, ашық бастапқы кодты музыка ойнатқышы.", "versionInfo": "Нұсқасы {version} (Құрастыру {build})",
        "createdBy": "Жасаған Lucas Coelho", "website": "Веб-сайт", "github": "GitHub",
        "releaseNotes": "Шығарылым жазбалары", "support": "Қолдау", "license": "Лицензия", "acknowledgments": "Алғыстар",
        "copyright": "© {year} PPPlayer үлескерлері", "close": "Жабу"
    },
    'ko': {
        "aboutDescription": "무료 오픈소스 음악 플레이어입니다.", "versionInfo": "버전 {version} (빌드 {build})",
        "createdBy": "제작: Lucas Coelho", "website": "웹사이트", "github": "GitHub",
        "releaseNotes": "출시 노트", "support": "지원", "license": "라이선스", "acknowledgments": "감사 인사",
        "copyright": "© {year} PPPlayer 기여자", "close": "닫기"
    },
    'lv': {
        "aboutDescription": "Bezmaksas, atvērtā pirmkoda mūzikas atskaņotājs.", "versionInfo": "Versija {version} (Būvējums {build})",
        "createdBy": "Izveidoja Lucas Coelho", "website": "Tīmekļa vietne", "github": "GitHub",
        "releaseNotes": "Laidiena piezīmes", "support": "Atbalsts", "license": "Licence", "acknowledgments": "Pateicības",
        "copyright": "© {year} PPPlayer atbalstītāji", "close": "Aizvērt"
    },
    'ms': {
        "aboutDescription": "Pemain muzik sumber terbuka dan percuma.", "versionInfo": "Versi {version} (Binaan {build})",
        "createdBy": "Dicipta oleh Lucas Coelho", "website": "Laman web", "github": "GitHub",
        "releaseNotes": "Nota Keluaran", "support": "Sokongan", "license": "Lesen", "acknowledgments": "Penghargaan",
        "copyright": "© {year} Penyumbang PPPlayer", "close": "Tutup"
    },
    'my': {
        "aboutDescription": "အခမဲ့ဖြစ်သော အလွယ်တကူရနိုင်သည့် တေးဂီတဖွင့်စက်။", "versionInfo": "ဗားရှင်း {version} (တည်ဆောက်မှု {build})",
        "createdBy": "Lucas Coelho မှ ဖန်တီးသည်", "website": "ဝဘ်ဆိုက်", "github": "GitHub",
        "releaseNotes": "ထုတ်ဝေမှု မှတ်စုများ", "support": "ပံ့ပိုးမှု", "license": "လိုင်စင်", "acknowledgments": "အသိအမှတ်ပြုမှုများ",
        "copyright": "© {year} PPPlayer ပါဝင်ကူညီသူများ", "close": "ပိတ်ရန်"
    },
    'pcm': {
        "aboutDescription": "A free, open-source music player.", "versionInfo": "Version {version} (Build {build})",
        "createdBy": "Created by Lucas Coelho", "website": "Website", "github": "GitHub",
        "releaseNotes": "Release notes", "support": "Support", "license": "License", "acknowledgments": "Acknowledgments",
        "copyright": "© {year} PPPlayer contributors", "close": "Close"
    },
    'pl': {
        "aboutDescription": "Darmowy odtwarzacz muzyki o otwartym kodzie źródłowym.", "versionInfo": "Wersja {version} (Kompilacja {build})",
        "createdBy": "Stworzony przez Lucas Coelho", "website": "Strona internetowa", "github": "GitHub",
        "releaseNotes": "Informacje o wydaniu", "support": "Wsparcie", "license": "Licencja", "acknowledgments": "Podziękowania",
        "copyright": "© {year} Współtwórcy PPPlayer", "close": "Zamknij"
    },
    'pt': {
        "aboutDescription": "Um reprodutor de música gratuito e de código aberto.", "versionInfo": "Versão {version} (Build {build})",
        "createdBy": "Criado por Lucas Coelho", "website": "Site", "github": "GitHub",
        "releaseNotes": "Notas de lançamento", "support": "Suporte", "license": "Licença", "acknowledgments": "Agradecimentos",
        "copyright": "© {year} Contribuidores do PPPlayer", "close": "Fechar"
    },
    'ru': {
        "aboutDescription": "Бесплатный музыкальный плеер с открытым исходным кодом.", "versionInfo": "Версия {version} (Сборка {build})",
        "createdBy": "Создатель: Lucas Coelho", "website": "Веб-сайт", "github": "GitHub",
        "releaseNotes": "Примечания к выпуску", "support": "Поддержка", "license": "Лицензия", "acknowledgments": "Благодарности",
        "copyright": "© {year} Участники PPPlayer", "close": "Закрыть"
    },
    'sv': {
        "aboutDescription": "En gratis musikspelare med öppen källkod.", "versionInfo": "Version {version} (Bygge {build})",
        "createdBy": "Skapad av Lucas Coelho", "website": "Webbplats", "github": "GitHub",
        "releaseNotes": "Versionsfakta", "support": "Support", "license": "Licens", "acknowledgments": "Erkännanden",
        "copyright": "© {year} PPPlayer-bidragsgivare", "close": "Stäng"
    },
    'uz': {
        "aboutDescription": "Bepul va ochiq kodli musiqa pleyeri.", "versionInfo": "Versiya {version} (Qurilma {build})",
        "createdBy": "Lucas Coelho tomonidan yaratilgan", "website": "Veb-sayt", "github": "GitHub",
        "releaseNotes": "Chiqarish qaydlari", "support": "Qo'llab-quvvatlash", "license": "Litsenziya", "acknowledgments": "Minnatdorchilik",
        "copyright": "© {year} PPPlayer hissa qo'shuvchilari", "close": "Yopish"
    },
    'zh': {
        "aboutDescription": "免费、开源的音乐播放器。", "versionInfo": "版本 {version} (构建 {build})",
        "createdBy": "由 Lucas Coelho 创建", "website": "网站", "github": "GitHub",
        "releaseNotes": "发行说明", "support": "支持", "license": "许可证", "acknowledgments": "鸣谢",
        "copyright": "© {year} PPPlayer 贡献者", "close": "关闭"
    }
}

# 1. Load English file to get the exact exact set of keys
en_file = 'lib/l10n/app_en.arb'
with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

expected_keys = set(en_data.keys())

for filepath in glob.glob('lib/l10n/app_*.arb'):
    filename = os.path.basename(filepath)
    if filename == 'app_en.arb':
        continue
        
    lang_code = filename.replace('app_', '').replace('.arb', '')
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    # Inject the about dialog keys
    t = about_translations.get(lang_code)
    if t:
        for k, v in t.items():
            data[k] = v
            # Inject metadata for these keys too
            meta_key = f"@{k}"
            if k == "versionInfo":
                data[meta_key] = {"placeholders": {"version": {}, "build": {}}}
            elif k == "copyright":
                data[meta_key] = {"placeholders": {"year": {}}}
            else:
                data[meta_key] = {}
                
    # Remove any extra keys not present in app_en.arb
    current_keys = list(data.keys())
    for k in current_keys:
        if k not in expected_keys:
            del data[k]
            
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("About dialog translation complete!")

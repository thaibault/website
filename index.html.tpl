<!-- region vim modline

vim: set tabstop=4 shiftwidth=4 expandtab:
vim: foldmethod=marker foldmarker=region,endregion:

endregion

region header

Copyright Torben Sickert 16.12.2012

License
   This library written by Torben Sickert stand under a creative commons
   naming 3.0 unported license.
   see http://creativecommons.org/licenses/by/3.0/deed.de

endregion -->

<% # region location

<% IMAGE_PATH = 'image/'
<% IMAGE_APPLE_TOUCH_ICON_PATH = IMAGE_PATH + 'appleTouchIcon/'

<% LESS_PATH = 'less/'
<% CASCADING_STYLE_SHEET_PATH = 'cascadingStyleSheet/'

<% COFFEE_SCRIPT_PATH = 'coffeeScript/'
<% JAVA_SCRIPT_PATH = 'javaScript/'

<% LINK_TO_PUBLIC_SSH_KEY = 'data/publicSSHKey.txt'
<% LINK_CURRICULUM_VITAE = 'data/curriculumVitae.pdf'

<% # endregion

<% # region content

<% SOCIAL_MEDIA = (
<%     ('e-mail', 't.sickert@gmail.com'),
<%     ('github', 'https://github.com/thaibault'),
<%     ('google-plus', 'https://plus.google.com/+TorbenSickert'),
<%     ('xing', 'http://www.xing.com/profile/Torben_Sickert'),
<%     ('linked-in', 'http://de.linkedin.com/pub/torben-sickert/28/aa9/919'),
<%     ('skype', 'skype:t.sickert?add'),
<%     ('twitter', 'https://twitter.com/tsickert'),
<%     ('facebook', 'https://de-de.facebook.com/tsickert'),
<%     ('website', 'http://thaibault.github.com'))
<% SECTIONS = (
<%     ('about', (
<%         {'enUS': 'About me', 'deDE': 'Über mich'}, {'enUS': '', 'deDE': ''},
<%         {'enUS': "I'm ambitious and love the challenge",
<%          'deDE': 'Ich bin ambitioniert und liebe die Herausforderung'})),
<%     ('contact', (
<%         {'enUS': 'Contact', 'deDE': 'Kontakt'},
<%         {'enUS': 'Get in touch', 'deDE': 'Lernen wir uns kennen'},
<%         {'enUS': "I'm a freelancer, ready to help you. Let's talk about "
<%                  "your project and what I can do.",
<%          'deDE': 'Ich arbeite selbständig und bin bereit für Ihr Projekt. '
<%                  'Kontaktieren Sie mich und wir sprechen über Ihr '
<%                  'Vorhaben.'})),
<%     ('work', (
<%         {'enUS': 'Work', 'deDE': 'Arbeiten'},
<%         {'enUS': "I love what I'm doing",
<%          'deDE': 'Ich liebe was ich mache'},
<%         {'enUS': 'I offer', 'deDE': 'ich biete'},
<%         {'enUS': (
<%              ('abstract', (
<%                   'contacts', 'conception',
<%                   'Implementation and optimization of applications for the '
<%                   'web; desktop and server', 'quality Assurance',
<%                   'High Reliability Applications', 'Test-driven Design',
<%                   '(Web) progamming', 'Usabillity',
<%                   'Web and search engine optimization',
<%                   'administering servers on Linux, Mac or Windows',
<%                   'Intranet Solutions', 'Community Portal solution',
<%                   'Accessibility', 'Rich Internet Applications',
<%                   'Content Management Systems', 'Web 2.0')),
<%              ('security', (
<%                   'Design by Contract',
<%                   'Integration, application, and unit tests',
<%                   'Proofs of program properties')),
<%              ('knowledge', (
<%                   'economic theoretical knowledge',
<%                   'matic computerized knowledge',
<%                   'mathematical knowledge')),
<%              ('programing Techniques', (
<%                   'Functionally oriented programming',
<%                   'Imperative Oriented Programming',
<%                   'Object-Oriented Programming',
<%                   'Aspect-Oriented Programming')),
<%              ('database', (
<%                   'Object-Relational Modeling (ORM) with SQLAlchemy, POD '
<%                   'or Propel', 'SQL')),
<%              ('versioning', ('GIT', 'SVN', 'CVS', 'Mercurial')),
<%              ('programing Language', (
<%                   'C', 'C++', 'C# (with XNA)', 'Java', 'Python',
<%                   'JavaScript', 'CofProgrammier TechnikenfeeScript',
<%                   'Scheme', 'PHP')),
<%              ('declarative Language', ('XHTML', 'CSS', 'less')),
<%              ('server', ('apache', 'nginx')),
<%              ('framework', (
<%                  'angularJS', 'django', 'jQuery', 'Mootools', 'bootstrap'))
<%         ), 'deDE': (
<%              ('Abstrakt', (
<%                  'Kontakte', 'Konzeption',
<%                  'Umsetzung und Optimierung von Anwendungen fürs Web, '
<%                  'Desktop und Server', 'Qualitätsicherung',
<%                  'Hochzuverlässigkeits-Anwendungen', 'Test-driven Design',
<%                  '(Web)Progammierung', 'Usabillity', 'Web- und '
<%                  'Suchengine-Optimierung',
<%                  'Administrierung für Server auf Linux Mac oder Windows',
<%                  'Intranet Lösungen', 'Community Portallösung',
<%                  'Barrierefreiheit', 'Rich Internet Applications',
<%                  'Content Management Systeme', 'Web 2.0')),
<%              ('Sicherheit', (
<%                  'Design by Contract',
<%                  'Integrations-, Anwendung und Unit-Tests',
<%                  'Beweisen von Programmeigenschaften')),
<%              ('Wissen', (
<%                  'wirtschaftstheoretisches Wissen', 'informatisches Wissen',
<%                  'mathematisches Wissen')),
<%              ('Programmiertechniken', (
<%                  'Funktionalorientierte Programmierung',
<%                  'Imperativorientierte Programmierung',
<%                  'Objektorientierte Programmierung',
<%                  'Aspektorientierte Programmierung')),
<%              ('Datenbanken', (
<%                  'Relationale-Objekt-Modelierung (ORM) mit sqlAlchemy; '
<%                  'POD oder Propel', 'SQL')),
<%              ('Versionierung', ('GIT', 'SVN', 'CVS', 'Mercurial')),
<%              ('Programmiersprachen', (
<%                  'C', 'C++', 'C# (mit XNA)', 'Java', 'Python', 'JavaScript',
<%                  'CoffeeScript', 'Scheme', 'PHP')),
<%              ('Deklarative Sprachen', ('XHTML', 'CSS', 'less')),
<%              ('Server', ('apache', 'nginx')),
<%              ('Framework', (
<%                  'angularJS', 'django', 'jQuery', 'Mootools', 'bootstrap'))
<%         )}, {'enUS': 'Projects', 'deDE': 'Projekte'})))
<% PROJECTS = (
<%     ('boostNode', 'http://thaibault.github.com/boostNode',
<%      {'enUS': (
<%          'TODO',
<%          ('TODO', 'TODO', 'TODO', 'TODO', 'TODO', 'TODO')),
<%       'deDE': (
<%          'Ein universelles Python-Framework zur Anwendung von '
<%          'platformunabhängiger Desktopanwendungen mit '
<%          'Web-Technologien. Das Framework bietet '
<%          'Hochzuverlässigkeitsmerkmale:',
<%          ('100% branch coverage getestet',
<%           'Type checking im Entwicklungsmodus',
<%           'zyklomatische Komplexität kleiner acht',
<%           'vollständige API-Dokumentation '
<%           'http://thaibault.github.com/boostNode/api',
<%           'stets kompatibel zu den neusten beiden Pythonversionen durch '
<%           'integrierte macros',
<%           'Plattform unabhängige Web-View und flexibler multiprozess- und '
<%           'multithread Web-Server'))}),
<%     ('installArchLinux', 'http://archinstall.github.com',
<%      {'enUS': ('TODO',),
<%       'deDE': (
<%          'Installiere ein konfiguriertes ArchLinux mit Pacman als '
<%          'Paketverwaltung an beliebige Orte wie Festplatten, USB-Stick, '
<%          'alternative Partition oder in das bestehende System als '
<%          'Sandboxumgebung. Automatische Konfiguration bestehender posix '
<%          'konformer unix-artiger Systeme. Sowohl Online- als auch '
<%          'Offline-Installationen sind möglich. Selbst ohne root Rechte '
<%          'kann das System in eine eigene Umgebung unterhalb des Home-Ordner'
<%          ' installiert werden. Alle benötigten Abhängigkeiten zum '
<%          'Aufsetzen sind durch eine einfache posix-Umgebung gegeben wie '
<%          'Busybox oder ArchLinux selbst.',)}),
<%     ('genericServiceHandler',
<%      'http://thaibault.github.com/genericServiceHandler',
<%      {'enUS': ('TODO',),
<%       'deDE': (
<%          'Dieses bash-Modul bietet einen generischen Service-Handler zur '
<%          'Steuerung jeglicher Dienste, welche standard Prozesssignale '
<%          'unterstützen. Das Projekt ist vom Systemd-Service-Handling '
<%          'inspiriert und kann in jeder unix-artigen Umgebung eingesetzt '
<%          'werden. Es eignet sich besonders um Dienste in den Hoch- und '
<%          'Herunterfahr-Prozess des Betriebssystems einzubetten.',)}),
<%     ('require', 'http://thaibault.github.com/require',
<%      {'enUS': ('TODO',),
<%       'deDE': (
<%          'Dieses native JavaScript Module bietet einen vollständigen '
<%          'Importmechanismus für JavaScript wie er aus python, php, oder '
<%          'ruby bekannt ist. Hierdurch wird es möglich, dass jede JavaScript'
<%          ' Datei seine eigenen Abhängigkeiten definiert und keine globale '
<%          'iListe an benötigten Dateien im html-Header verwaltet werden '
<%          'muss. Entschiedener Vorteil gegenüber "RequireJS" oder "YepNope" '
<%          'besteht darin, dass auch die Abhängigkeiten der Abhängigkeiten '
<%          'beliebig tief in einer topologischen Sortierung aufgelöst werden '
<%          'können. Das Einbinden von less, coffeeScript oder css ist '
<%          'ebenfalls möglich. Zudem können sich entsprechende "Handler" '
<%          'hinzufügen lassen um im Browser entsprechende SourceMaps zu '
<%          'generieren oder sonstige Aktionen auszulösen.',)}),
<%     ('jQuery-tools', 'http://thaibault.github.com/jQuery-tools',
<%      {'enUS': ('TODO',),
<%       'deDE': (
<%          'jQuery-tools ist ein auf jQuery aufsetzendes Plugin, um '
<%          'objektorientierte jQery-Plugins ähnlich wie bei MooTools oder '
<%          'Prototype zu erstellen. Verschiedene generische Software-Pattern '
<%          'werden durch eine wiederverwendbare Controller-Logik möglich. '
<%          'Zudem werden einige nützliche Werkzeuge zum Bauen von grafischen '
<%          'Oberflächen angeboten wie, Wechselseitiger Ausschluss, '
<%          'Scope-basiertes Event-Handling und einige Low-Level '
<%          'Erweiterungen für native Datentypen. Beispiel-Implementierungen '
<%          'findet sich in den Projekten:', (
<%              ('jQery-incrementer',
<%               'http://thaibault.github.com/jQuery-incrementer'),
<%              ('jQery-lang', 'http://thaibault.github.com/jQuery-lang'),
<%              ('jQuery-website',
<%               'http://thaibault.github.com/jQuery-website'),
<%              ('Meine persönliche Website', 'http://thaibault.github.com')
<%          ))}))

<% # endregion

<% # region runtime

<% DEFAULT_LANGUAGE = 'deDE'
<% ALTERNATE_LANGUAGE = 'enUS'
<% START_UP_ANIMATION_NUMBER = 1

<% # endregion

<!doctype html>

<!-- region browser sniffing -->

<html lang="en">

<!-- endregion -->

<!-- region header -->

    <head>
        <title>Torben Sickert development</title>

    <!-- region meta informations -->

        <meta charset="utf-8">
        <meta name="description" content="development responsive python javascript coffeescript bash design">
        <meta name="author" content="Torben Sickert">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- endregion -->

    <!-- region fav and touch icons -->

        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="<% IMAGE_APPLE_TOUCH_ICON_PATH %>144x144-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="<% IMAGE_APPLE_TOUCH_ICON_PATH %>114x114-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="<% IMAGE_APPLE_TOUCH_ICON_PATH %>72x72-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" href="<% IMAGE_APPLE_TOUCH_ICON_PATH %>57x57-precomposed.png" />
        <link rel="shortcut icon" type="image/x-icon" href="<% IMAGE_PATH %>favicon.ico" />

    <!-- endregion -->

    <!-- region resources -->

        <link type="text/css" rel="stylesheet/less" media="screen" href="<% LESS_PATH %>homePage-1.0.less" />
        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]><script src="<% JAVA_SCRIPT_PATH %>html5shiv-3.7.0.js"></script><![endif]-->
        <script type="text/javascript" src="<% JAVA_SCRIPT_PATH %>coffeeScript-1.6.3.js"></script>
        <script type="text/coffeescript" src="<% COFFEE_SCRIPT_PATH %>require-1.0.coffee"></script>
        <script type="text/coffeescript" src="<% COFFEE_SCRIPT_PATH %>main.coffee"></script>

    <!-- endregion -->

    </head>

<!-- endregion -->

<!-- region body -->

    <body class="home-page" style="display: none">
        <div class="window-loading-cover"><div></div></div>

    <!-- region menu -->

        <div class="start-up-animation-number-<% START_UP_ANIMATION_NUMBER %> navbar-wrapper ">
            <div class="container">
                <div class="navbar navbar-inverse navbar-static-top">
                    <div class="container">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="#">thaibault <span class="dimension-indicator"></span></a>
                            <% START_UP_ANIMATION_NUMBER += 1
                            <a href="#lang-<% ALTERNATE_LANGUAGE %>" class="start-up-animation-number-<% START_UP_ANIMATION_NUMBER %>"><% ALTERNATE_LANGUAGE[:-2] %></a>
                            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                                <% for section in range(3):
                                    <span class="icon-bar"></span>
                                <% end
                            </button>
                        </div>
                        <div class="navbar-collapse collapse">
                            <div class="navbar-highlighter"></div>
                            <ul class="nav navbar-nav">
                                <% for name, section in SECTIONS:
                                    <% if section[0]:
                                        <% START_UP_ANIMATION_NUMBER += 1
                                        <li class="start-up-animation-number-<% START_UP_ANIMATION_NUMBER %><%' active' if name == SECTIONS[0][0] else ''%>">
                                            <a href="#<% name %>"><% section[0][DEFAULT_LANGUAGE]%><!--<% ALTERNATE_LANGUAGE %>:<% section[0][ALTERNATE_LANGUAGE] %>--></a>
                                        </li>
                                    <% end
                                <% end
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- endregion -->

    <!-- region carousel -->

        <div class="carousel slide">
            <div class="carousel-inner">
                <% for name, section in SECTIONS:
                    <div class="item <% name %>">
                        <div class="carousel-image-<% name %>">
                            <div class="container">
                                <% if section[1][DEFAULT_LANGUAGE]:
                                    <h1>
                                        <% section[1][DEFAULT_LANGUAGE] %>
                                        <!--enUS:<% section[1][ALTERNATE_LANGUAGE] %>-->
                                    </h1>
                                <% if name == 'work':
                                    <h2>
                                        <% section[2][DEFAULT_LANGUAGE] %>
                                        <!--<% ALTERNATE_LANGUAGE %>:<% section[2][ALTERNATE_LANGUAGE] %>-->
                                    </h2>
                                    <p>
                                        <langReplace>
                                            <% for title, keywords in section[3][DEFAULT_LANGUAGE]:
                                                <% if title != section[3][DEFAULT_LANGUAGE][0][0]:
                                                    <strong><% title %></strong>
                                                <% ', '.join(keywords) %>
                                        </langReplace>
                                        <!--<% ALTERNATE_LANGUAGE %>:
                                            <% for title, keywords in section[3][ALTERNATE_LANGUAGE]:
                                                <% if title != section[3][DEFAULT_LANGUAGE][0][0]:
                                                    <strong><% title %></strong>
                                                <% ', '.join(keywords) %>
                                        -->
                                    </p>
                                    <h2>
                                        <% section[4][DEFAULT_LANGUAGE] %>
                                        <!--<% ALTERNATE_LANGUAGE %>:<% section[4][ALTERNATE_LANGUAGE] %>-->
                                    </h2>
                                    <dl class="dl-horizontal">
                                        <% for project_name, project_page_link, project_description in PROJECTS:
                                            <dt>
                                                <a href="<% project_page_link %>" target="_blank"><% project_name %></a>
                                            </dt>
                                            <dd>
                                                <% project_description[DEFAULT_LANGUAGE][0] %>
                                                <!--<% ALTERNATE_LANGUAGE %>:<% project_description[ALTERNATE_LANGUAGE][0] %>-->
                                                <% if len(project_description[DEFAULT_LANGUAGE]) > 1:
                                                    <ul>
                                                        <% for index, element in enumerate(project_description[DEFAULT_LANGUAGE][1]):
                                                            <li>
                                                                <% if is_type_of(element, tuple):
                                                                    <a href="<% element[1] %>"><% element[0] %></a>
                                                                <% else:
                                                                    <% element %>
                                                                    <!--<% ALTERNATE_LANGUAGE %>:<% project_description[ALTERNATE_LANGUAGE][1][index] %>-->
                                                            </li>
                                                    </ul>
                                            </dd>
                                    </dl>
                                <% else:
                                    <p class="lead">
                                        <% section[2][DEFAULT_LANGUAGE] %>
                                        <!--<% ALTERNATE_LANGUAGE %>:<% section[2][ALTERNATE_LANGUAGE] %>-->
                                        <% if name == 'about':
                                            <a href="<% LINK_CURRICULUM_VITAE %>" target="_blank">Lebenslauf<!--<% ALTERNATE_LANGUAGE %>:Curriculum Vitae--></a>
                                    </p>
                                <% if name == 'contact':
                                    <a href="tel:004917610248185">Tel.<!--enEN:Phone--> +49 (0) 176 <span>/</span> 10 248 185</a>
                                    <% for name, link in SOCIAL_MEDIA:
                                        <% if '@' in link:
                                            <% link = 'mailto:%s' % link
                                        <a class="glyphicon-social glyphicon-social-<% name %>" href="<% link %>" target="_blank"></a>
                            </div>
                        </div>
                    </div>
                <% end
            </div>
        </div>

    <!-- endregion -->

    <!-- region about this website -->

        <div class="about-this-website">
            <div class="carousel-image-about-this-website">
                <div class="container">
                    <h1>
                        Impressum
                        <!--<% ALTERNATE_LANGUAGE %>:About this website-->
                    </h1>
                    <h2>Kontakt<!--<% ALTERNATE_LANGUAGE %>:Contact--></h2>
                    <div class="lead">
                        <p>Anbieter von<!--<% ALTERNATE_LANGUAGE %>:Provider of--> <a href="<% SOCIAL_MEDIA[-1][1] %>"><% SOCIAL_MEDIA[-1][1] %></a>:</p>
                        <p>Torben Sickert</p>
                        <p>Christoph-Mang-Str. 14</p>
                        <p>79100 Freiburg</p>
                        <p>Tel. 0049 (0) 176 / 10248185</p>
                        <p>Internet: <a href="<% SOCIAL_MEDIA[-1][1] %>"><% SOCIAL_MEDIA[-1][1] %></a></p>
                        <p>Email: <a href="mailto:#"><% SOCIAL_MEDIA[0][1] %></a></p>
                        <br />
                        <p><a href="<% LINK_TO_PUBLIC_SSH_KEY %>" target="_blank">öffentlicher SSH-Schlüssel<!--<% ALTERNATE_LANGUAGE %>:public ssh key--></a></p>
                    </div>
                    <h2>
                        Haftungsausschluss
                        <!--<% ALTERNATE_LANGUAGE %>:Disclaimer-->
                    </h2>
                    <h3>
                        Haftung für Inhalte
                        <!--<% ALTERNATE_LANGUAGE %>:Liability for content-->
                    </h3>
                    <p>
                        Die Inhalte unserer Seiten wurden mit größter Sorgfalt
                        erstellt. Für die Richtigkeit, Vollständigkeit und
                        Aktualität der Inhalte können wir jedoch keine Gewähr
                        übernehmen. Als Diensteanbieter sind wir gemäß
                        § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach
                        den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis
                        10 TMG sind wir als Diensteanbieter jedoch nicht
                        verpflichtet, übermittelte oder gespeicherte fremde
                        Informationen zu überwachen oder nach Umständen zu
                        forschen, die auf eine rechtswidrige Tätigkeit
                        hinweisen. Verpflichtungen zur Entfernung oder Sperrung
                        der Nutzung von Informationen nach den allgemeinen
                        Gesetzen bleiben hiervon unberührt. Eine diesbezügliche
                        Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis
                        einer konkreten Rechtsverletzung möglich. Bei Bekannt
                        werden von entsprechenden Rechtsverletzungen werden wir
                        diese Inhalte umgehend entfernen.
                    </p>
                    <h3>
                        Haftung für Links
                        <!--<% ALTERNATE_LANGUAGE %>:Liability for links-->
                    </h3>
                    <p>
                        Unser Angebot enthält Links zu externen Webseiten
                        Dritter, auf deren Inhalte wir keinen Einfluss haben.
                        Deshalb können wir für diese fremden Inhalte auch keine
                        Gewähr übernehmen. Für die Inhalte der verlinkten
                        Seiten ist stets der jeweilige Anbieter oder Betreiber
                        der Seiten verantwortlich. Die verlinkten Seiten wurden
                        zum Zeitpunkt der Verlinkung auf mögliche
                        Rechtsverstöße überprüft. Rechtswidrige Inhalte waren
                        zum Zeitpunkt der Verlinkung nicht erkennbar. Eine
                        permanente inhaltliche Kontrolle der verlinkten Seiten
                        ist jedoch ohne konkrete Anhaltspunkte einer
                        Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von
                        Rechtsverletzungen werden wir derartige Links umgehend
                        entfernen.
                    </p>
                    <h3>
                        Urheberrecht
                        <!--<% ALTERNATE_LANGUAGE %>:Copyright-->
                    </h3>
                    <p>
                        Die durch die Seitenbetreiber erstellten Inhalte und
                        Werke auf diesen Seiten unterliegen dem deutschen
                        Urheberrecht. Die Vervielfältigung, Bearbeitung,
                        Verbreitung und jede Art der Verwertung außerhalb der
                        Grenzen des Urheberrechtes bedürfen der schriftlichen
                        Zustimmung des jeweiligen Autors bzw. Erstellers.
                        Downloads und Kopien dieser Seite sind nur für den
                        privaten, nicht kommerziellen Gebrauch gestattet.
                        Soweit die Inhalte auf dieser Seite nicht vom Betreiber
                        erstellt wurden, werden die Urheberrechte Dritter
                        beachtet. Insbesondere werden Inhalte Dritter als
                        solche gekennzeichnet. Sollten Sie trotzdem auf eine
                        Urheberrechtsverletzung aufmerksam werden, bitten wir
                        um einen entsprechenden Hinweis. Bei Bekanntwerden von
                        Rechtsverletzungen werden wir derartige Inhalte
                        umgehend entfernen.
                    </p>
                    <h3>
                        Datenschutz
                        <!--<% ALTERNATE_LANGUAGE %>:Privacy Policy-->
                    </h3>
                    <p>
                        Die Nutzung unserer Webseite ist in der Regel ohne
                        Angabe personenbezogener Daten möglich. Soweit auf
                        unseren Seiten personenbezogene Daten (beispielsweise
                        Name, Anschrift oder eMail-Adressen) erhoben werden,
                        erfolgt dies, soweit möglich, stets auf freiwilliger
                        Basis. Diese Daten werden ohne Ihre ausdrückliche
                        Zustimmung nicht an Dritte weitergegeben. Wir w
                        darauf hin, dass die Datenübertragung im Internet (z.B.
                        bei der Kommunikation per E-Mail) Sicherheitslücken
                        aufweisen kann. Ein lückenloser Schutz der Daten vor
                        dem Zugriff durch Dritte ist nicht möglich. Der Nutzung
                        von im Rahmen der Impressumspflicht veröffentlichten
                        Kontaktdaten durch Dritte zur Übersendung von nicht
                        ausdrücklich angeforderter Werbung und
                        Informationsmaterialien wird hiermit ausdrücklich
                        widersprochen. Die Betreiber der Seiten behalten sich
                        ausdrücklich rechtliche Schritte im Falle der
                        unverlangten Zusendung von Werbeinformationen, etwa
                        durch Spam-Mails, vor.
                    </p>
                    <h3>
                        Datenschutzerklärung für die Nutzung von Google
                        Analytics
                        <!--<% ALTERNATE_LANGUAGE %>:
                            Privacy Statement for using Google Analytics
                        -->
                    </h3>
                    <p>
                        Diese Website benutzt Google Analytics, einen
                        Webanalysedienst der Google Inc. ("Google"). Google
                        Analytics verwendet sog. "Cookies", Textdateien, die
                        auf Ihrem Computer gespeichert werden und die eine
                        Analyse der Benutzung der Website durch Sie
                        ermöglichen. Die durch den Cookie erzeugten
                        Informationen über Ihre Benutzung dieser Website werden
                        in der Regel an einen Server von Google in den USA
                        übertragen und dort gespeichert. Im Falle der
                        Aktivierung der IP-Anonymisierung auf dieser Webseite
                        wird Ihre IP-Adresse von Google jedoch innerhalb von
                        Mitgliedstaaten der Europäischen Union oder in anderen
                        Vertragsstaaten des Abkommens über den Europäischen
                        Wirtschaftsraum zuvor gekürzt. Nur in Ausnahmefällen
                        wird die volle IP-Adresse an einen Server von Google in
                        den USA übertragen und dort gekürzt. Im Auftrag des
                        Betreibers dieser Website wird Google diese
                        Informationen benutzen, um Ihre Nutzung der Website
                        auszuwerten, um Reports über die Websiteaktivitäten
                        zusammenzustellen und um weitere mit der Websitenutzung
                        und der Internetnutzung verbundene Dienstleistungen
                        gegenüber dem Websitebetreiber zu erbringen. Die im
                        Rahmen von Google Analytics von Ihrem Browser
                        übermittelte IP-Adresse wird nicht mit anderen Daten
                        von Google zusammengeführt. Sie können die Speicherung
                        der Cookies durch eine entsprechende Einstellung Ihrer
                        Browser-Software verhindern; wir weisen Sie jedoch
                        darauf hin, dass Sie in diesem Fall gegebenenfalls
                        nicht sämtliche Funktionen dieser Website
                        vollumfänglich werden nutzen können. Sie können darüber
                        hinaus die Erfassung der durch das Cookie erzeugten und
                        auf Ihre Nutzung der Website bezogenen Daten (inkl.
                        Ihrer IP-Adresse) an Google sowie die Verarbeitung
                        dieser Daten durch Google verhindern, indem sie das
                        unter dem folgenden Link verfügbare Browser-Plugin
                        herunterladen und installieren:
                        http://tools.google.com/dlpage/gaoptout?hl=de.
                    </p>
                    <h3>Copyright Statement</h3>
                        Unless noted otherwise, all artwork on this website is
                        protected property of the website author. Any use for
                        commercial purpose, reproduction and publication
                        requires the author's written permission. Commercial
                        work created in cooperation or bound by contract with
                        third parties are specifically marked. Respective
                        copyrights apply.
                    </h3>
                </div>
            </div>
        </div>

    <!-- endregion -->

    <!-- region footer -->

        <!--
            Wrap the footer of the page in another container to center the
            content.
        -->
        <% START_UP_ANIMATION_NUMBER += 1
        <div class="start-up-animation-number-<% START_UP_ANIMATION_NUMBER %> footer">
            <footer>
                <p>
                    &copy; 2013 Torben Sickert, Inc. &middot; <a href="#about-this-website">about this website<!--<% ALTERNATE_LANGUAGE %>:impressum--></a>
                </p>
            </footer>
        </div>

    <!-- endregion -->

        <a href="#top">top</a>
    </body>

<!-- endregion -->

</html>

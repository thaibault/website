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
<%         {'enUS': "I'm a computer scientist and love the challenge",
<%          'deDE': 'Ich bin Informatiker und liebe die Herausforderung'})),
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
<%         {'enUS': 'in a nutshell', 'deDE': 'in Kürze'},
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
<%      {'enUS': 'TODO mmmmmmmmmmmmmmm mmmmmmmmmmmmmmm mmmmmmmmmmmmmmmmmmmmmmm'
<%               'mmmmmm m m m mmmmmmmmmmmmmmmmmm mmmmmmmmmmmmmm mm m m mm',
<%       'deDE': 'TODO'}),
<%     ('installArchLinux', 'http://archinstall.github.com',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('genericServiceHandler',
<%      'http://thaibault.github.com/genericServiceHandler',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('require', 'http://thaibault.github.com/require',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('jQuery-tools', 'http://thaibault.github.com/jQuery-tools',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('jQuery-lang', 'http://thaibault.github.com/jQuery-lang',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('jQuery-incrementer',
<%      'http://thaibault.github.com/jQuery-incrementer',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}),
<%     ('jQuery-website', 'http://thaibault.github.com/jQuery-website',
<%      {'enUS': 'TODO', 'deDE': 'TODO'}))

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
                                                <strong><% title %></strong>
                                                <% ', '.join(keywords) %>
                                        </langReplace>
                                        <!--<% ALTERNATE_LANGUAGE %>:
                                            <% for title, keywords in section[3][ALTERNATE_LANGUAGE]:
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
                                                <% project_description[DEFAULT_LANGUAGE] %>
                                                <!--<% ALTERNATE_LANGUAGE %>:<% project_description[ALTERNATE_LANGUAGE] %>-->
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

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
<% STYLE_SHEET_PATH = 'cascardingStyleSheet/'

<% COFFEE_SCRIPT_PATH = 'coffeeScript/'
<% JAVA_SCRIPT_PATH = 'javaScript/'

<% LINK_TO_PUBLIC_SSH_KEY = 'https://www.dropbox.com/s/u6ic4cgbxdf7ko7/id_rsa.pub'

<% # endregion

<% # region content

<% SOCIAL_MEDIA = (
<%     ('e-mail', 't.sickert@gmail.com'),
<%     ('github', 'https://github.com/thaibault'),
<%     ('google-plus', 'https://plus.google.com/+TorbenSickert'),
<%     ('xing', 'http://www.xing.com/profile/Torben_Sickert'),
<%     ('linked-in', 'http://de.linkedin.com/pub/torben-sickert/28/aa9/919'),
<%     ('skype', ''),
<%     ('twitter', 'https://twitter.com/tsickert'),
<%     ('facebook', 'https://de-de.facebook.com/tsickert'),
<%     ('website', 'http://thaibault.github.io/website/'))

<% SECTIONS = (
<%     ('contact', (
<%         {'enUS': 'Contact', 'deDE': 'Kontakt'},
<%         {'enUS': 'Get in touch', 'deDE': 'Lernen wir uns kennen'},
<%         {'enUS': "I'm a freelancer, ready to help you. Let's talk about "
<%                  "your project and what I can do.",
<%          'deDE': 'Ich arbeite selbständig und bin bereit für Ihr Projekt. '
<%                  'Kontaktieren Sie mich und wir sprechen über Ihr '
<%                  'Vorhaben.'})),
<%     ('skills', (
<%         {'enUS': 'Skills', 'deDE': 'Fähigkeiten'},
<%         {'enUS': "I'm an ambitious IT guy and love what I'm doing!",
<%          'deDE': "Ich bin ambitionierter IT'ler und liebe was ich tue!"},
<%         {'enUS': {
<%              'abstract': (
<%                  'contacts', 'conception',
<%                  'Implementation and optimization of applications for the '
<%                  'web, ', 'desktop and server', 'quality Assurance',
<%                  'High Reliability Applications', 'Test-driven Design',
<%                  '(Web) progamming', 'Usabillity',
<%                  'Web and search engine optimization',
<%                  'administering servers on Linux, Mac or Windows',
<%                  'Intranet Solutions', 'Community Portal solution',
<%                  'Accessibility', 'Rich Internet Applications',
<%                  'Content Management Systems', 'Web 2.0'),
<%              'security': (
<%                  'Design by Contract',
<%                  'Integration, application, and unit tests',
<%                  'Proofs of program properties'),
<%              'other': (
<%                  'economic theoretical knowledge',
<%                  'matic computerized knowledge', 'mathematical knowledge'),
<%              'programingTechnics': (
<%                  'Functionally oriented programming',
<%                  'Imperative Oriented Programming',
<%                  'Object-Oriented Programming',
<%                  'Aspect-Oriented Programming'),
<%              'database': (
<%                  'Object-Relational Modeling (ORM) with SQLAlchemy, POD or '
<%                  'Propel', 'SQL'),
<%              'versioning': ('GIT', 'SVN', 'CVS', 'Mercurial'),
<%              'programingLanguage': (
<%                  'C', 'C++', 'C# (with XNA)', 'Java', 'Python',
<%                  'JavaScript', 'CoffeeScript', 'Scheme', 'PHP'),
<%              'declarativeLanguage': ('XHTML', 'CSS', 'less'),
<%              'server': ('apache', 'nginx'),
<%              'framework': (
<%                  'angularJS', 'django', 'jQuery', 'Mootools', 'bootstrap')},
<%          'deDE': 'TODO'})),
<%     ('references', (
<%         {'enUS': 'References', 'deDE': 'Referenzen'},
<%         {'enUS': "You don't want good service, instead of the result! "
<%                  "Perfection kills!",
<%          'deDE': 'TODO'},
<%         {'enUS': 'Experiences from Posic, Akra, Virtual Identity, Chair of '
<%                  'Humanoid',
<%          'deDE': 'TODO'},
<%         {'enUS': 'Robots Lab and Rechnernetze and Telematik in University '
<%                  'Freiburg, BPV, BTI, Vattenfall...',
<%          'deDE': 'TODO'})),
<%     ('about', (
<%         {'enUS': 'About me', 'deDE': 'Über mich'},
<%         {'enUS': "I'm a computer scientist and love the challenge",
<%          'deDE': 'Ich bin Informatiker und liebe die Herausforderung'},
<%         {'enUS': 'Experiences from Posic, Akra, Virtual Identity, Chair of '
<%                  'Humanoid Robots Lab and Rechnernetze and Telematik in '
<%                  'University Freiburg, BPV, BTI, Vattenfall...',
<%          'deDE': 'TODO'})))

<% PROJECTS = (
<%     ('boostNode', 'http://thaibault.github.io/boostNode/'),
<%     ('installArchLinux', 'http://archinstall.github.io/archInstall/'),
<%     ('genericServiceHandler',
<%      'http://thaibault.github.io/genericServiceHandler/'),
<%     ('require', 'http://thaibault.github.io/require/'),
<%     ('jquery-tools', 'http://thaibault.github.io/jQuery-tools/'),
<%     ('jquery-lang', 'http://thaibault.github.io/jQuery-lang/'),
<%     ('jquery-incrementer',
<%      'http://thaibault.github.io/jQuery-incrementer/'),
<%     ('jquery-website', 'http://thaibault.github.io/jQuery-website/'))

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

        <% START_UP_ANIMATION_NUMBER += 1
        <div class="start-up-animation-number-<% START_UP_ANIMATION_NUMBER %> carousel slide">
            <div class="carousel-inner">
                <% for name, section in SECTIONS:
                    <div class="item <% name %>">
                        <div class="carousel-image-<% name %>">
                            <div class="container">
                                <h1>
                                    <% section[1][DEFAULT_LANGUAGE] %>
                                    <!--enUS:<% section[1][ALTERNATE_LANGUAGE] %>-->
                                </h1>
                                <p>
                                    <% section[2][DEFAULT_LANGUAGE] %>
                                    <!--<% ALTERNATE_LANGUAGE %>:<% section[2][ALTERNATE_LANGUAGE] %>-->
                                </p>
                                <% if name == 'contact':
                                    <a href="tel:004917610248185">Tel.<!--enEN:Phone--> +49 (0) 176 <span>/</span> 10 248 185</a>
                                    <% for name, link in SOCIAL_MEDIA:
                                        <% if '@' in link:
                                            <% link = 'mailto:%s' % link
                                        <a class="glyphicon-social glyphicon-social-<% name %>" href="<% link %>" target="_blank"></a>
                                <% elif name == 'references':
                                    <% for project_name, project_page_link in PROJECTS:
                                        <a href="<% project_page_link %>"><% project_name %></a>
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
                        <p>Email: <a href="mailto:<% SOCIAL_MEDIA[0][1] %>"><% SOCIAL_MEDIA[0][1] %></a></p>
                        <br />
                        <p><a href="<% LINK_TO_PUBLIC_SSH_KEY %>">öffentlicher SSH-Schlüssel<!--<% ALTERNATE_LANGUAGE %>:public ssh key--></a></p>
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
                    &copy; 2013 Torben Sickert, Inc. &middot; <a href="#about-this-website">about this website</a>
                </p>
            </footer>
        </div>

    <!-- endregion -->

        <a href="#top">top</a>
    </body>

<!-- endregion -->

</html>

<% # region locations 

<% IMAGE_PATH = 'image/'
<% IMAGE_APPLE_TOUCH_ICON_PATH = IMAGE_PATH + 'appleTouchIcon/'
<% LESS_PATH = 'less/'
<% STYLE_SHEET_PATH = 'styleSheet/'
<% COFFEE_SCRIPT_PATH = 'coffeeScript/'
<% JAVA_SCRIPT_PATH = 'javaScript/'

<% # endregion

<% # region content

<% SOCIAL_MEDIA = (
<%     ('email', 'mailto:t.sickert@gmail.com'),
<%     ('github', 'https://github.com/thaibault'),
<%     ('google', 'https://plus.google.com/110796145663857741723/posts'),
<%     ('xing', 'http://www.xing.com/profile/Torben_Sickert'),
<%     ('linkedin', 'http://de.linkedin.com/pub/torben-sickert/28/aa9/919'),
<%     ('skype', ''),
<%     ('twitter', 'https://twitter.com/tsickert'),
<%     ('facebook', 'https://de-de.facebook.com/tsickert'))
<% SECTIONS = (
<%     ('contact', (
<%         'Hire me', 'Get in touch', "I'm a freelancer, ready to help you. "
<%         "Let's talk about your project and what I can do.")),
<%     ('skills', (
<%         'Skills', 'Knowing a lot of facts is not the same as being smart.',
<%         'Ambition, manage projects with love..')),
<%     ('references', (
<%         'References', "You don't want good service, instead of the result! "
<%                       "Perfection kills!",
<%         'Experiences from Posic, Akra, Virtual Identity, Chair of Humanoid'
<%         'Robots Lab and Rechnernetze and Telematik in University Freiburg,'
<%         'BPV, BTI, Vattenfall...')),
<%     ('about', (
<%         'About', "I'm a computer scientist and love the challenge",
<%         'Experiences from Posic, Akra, Virtual Identity, Chair of Humanoid'
<%         'Robots Lab and Rechnernetze and Telematik in University Freiburg,'
<%         'BPV, BTI, Vattenfall...')))
<% PROJECTS = (
<%     ('boostNode', 'http://thaibault.github.io/boostNode/'),
<%     ('installArchLinux', 'http://thaibault.github.io/installArchLinux/'),
<%     ('require', 'http://thaibault.github.io/require/'),
<%     ('jquery-tools', 'http://thaibault.github.io/jquery-tools/'),
<%     ('jquery-incrementer', 'http://thaibault.github.io/jquery-incrementer/'))

<% # endregion

<% # region runtime

<% START_UP_ANIMATION_NUMBER = 1

<% # endregion

<!doctype html>

<!-- region browser sniffing -->

<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8"><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9"><![endif]-->
<!--[if gt IE 8]><!--><html class="no-js"><!--<![endif]-->

<!-- endregion -->

<!-- region header -->

    <head>
        <title>
            Torben Sickert
        </title>

    <!-- region meta informations -->

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="description" content="">
        <meta name="author" content="Torben Sickert">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- endregion -->

    <!-- region fav and touch icons -->

        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="<%IMAGE_APPLE_TOUCH_ICON_PATH%>144x144-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="<%IMAGE_APPLE_TOUCH_ICON_PATH%>114x114-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="<%IMAGE_APPLE_TOUCH_ICON_PATH%>72x72-precomposed.png" />
        <link rel="apple-touch-icon-precomposed" href="<%IMAGE_APPLE_TOUCH_ICON_PATH%>57x57-precomposed.png" />
        <link rel="shortcut icon" type="image/x-icon" href="<%IMAGE_PATH%>favicon.ico" />

    <!-- endregion -->

    <!-- region ressources -->

        <link type="text/css" rel="stylesheet/less" href="<%LESS_PATH%>website-1.0.less" />
        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]><script src="<%JAVA_SCRIPT_PATH%>html5shiv-3.6.2.js"></script><![endif]-->
        <script type="text/javascript" src="<%JAVA_SCRIPT_PATH%>coffeeScript-1.6.2.js"></script>
        <script type="text/coffeescript" src="<%COFFEE_SCRIPT_PATH%>require-1.0.coffee"></script>
        <script type="text/coffeescript" src="<%COFFEE_SCRIPT_PATH%>main.coffee"></script>

    <!-- endregion -->

    </head>

<!-- endregion -->

<!-- region body -->

    <body class="website" style="display: none">
        <!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->
        <div class="window-loading-cover"><div></div></div>

    <!-- region menu -->

        <div class="start-up-animation-number-<%START_UP_ANIMATION_NUMBER%> navbar-wrapper ">
            <!-- Wrap the .navbar in .container to center it within the absolutely positioned parent. -->
            <div class="container">
                <div class="navbar navbar-inverse">
                    <div class="navbar-inner">
                        <!-- Responsive Navbar Part 1: Button for triggering responsive navbar. -->
                        <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                            <% for section in range(3):
                                <span class="icon-bar"></span>
                        </button>
                        <a class="brand" href="#">thaibault</a>
                        <div class="dimension-indicator"></div>
                        <!-- Responsive Navbar Part 2: Places all navbar contents. -->
                        <div class="nav-collapse collapse">
                            <ul class="nav">
                                <% for name, section in SECTIONS:
                                    <% START_UP_ANIMATION_NUMBER += 1
                                    <li class="start-up-animation-number-<%START_UP_ANIMATION_NUMBER%><%' active' if name == SECTIONS[0][0] else ''%>">
                                        <a href="#<%name%>">
                                            <%section[0]%>
                                        </a>
                                    </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>        

    <!-- endregion -->

    <!-- region carousel -->

        <% START_UP_ANIMATION_NUMBER += 1
        <div id="headerCarousel" class="start-up-animation-number-<%START_UP_ANIMATION_NUMBER%> carousel slide">
            <div class="carousel-inner">
                <% for name, section in SECTIONS:
                    <div class="item<%' active' if name == SECTIONS[0][0] else ''%>">
                        <div class="carousel-image-<%name%>"></div>
                        <div class="container">
                            <div class="carousel-caption">
                                <h1><%section[1]%></h1>
                                <p class="lead">
                                    <%section[2]%>
                                </p>
                                <% if name == 'contact':
                                    <p class="lead phone-number">+49 176 <span>/</span> 10 248 185</p>
                                    <% for name, link in SOCIAL_MEDIA:
                                        <a class="btn social-media social-media-<%name%>" href="<%link%>" target="_blank"></a>
                            </div>
                        </div>
                        <% START_UP_ANIMATION_NUMBER += 1
                        <div class="start-up-animation-number-<%START_UP_ANIMATION_NUMBER%> container content">
                            <p class="lead">
                                Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy
                                eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam
                                voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet
                                clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit
                                amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
                                nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed
                                diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
                                Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor
                                sit amet.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- endregion -->

        <!-- Wrap the rest of the page in another container to center all the content. -->
        <% START_UP_ANIMATION_NUMBER += 1
        <div class="start-up-animation-number-<%START_UP_ANIMATION_NUMBER%> container footer">

    <!-- region footer -->

            <footer>
                <p class="pull-right"><a href="#top">Back to top</a></p>
                <p>
                    &copy; 2013 Torben Sickert, Inc. &middot; <a href="#privacy">Privacy</a> &middot; <a href="#terms">Terms</a> &middot; <a href="#legal-notice">legal notice</a>
                </p>
            </footer>

    <!-- endregion -->

        </div>
    </body>

<!-- endregion body -->

</html>

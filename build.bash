#!/bin/bash

function websiteRenderHelper() {
    # TODO integrate later loading js ressources like html5shiv.

    # Exit if something goes wrong.
    set -e

    # region constants

    local USE_BASE64_ENCODING=false
    local USE_BASE64_FAVICON_ENCODING=true

        # region locations

    local BUILD_PATH='build/'
    # NOTE: Path shouldn't have a slash in the end.
    local LESS_PATH='less'
    local CSS_PATH='styleSheet/'
    local IMAGE_PATH='image/'
    local COFFEE_SCRIPT_PATH='coffeeScript/'
    local COFFEE_SCRIPT_ENTRY_POINT='main.coffee'
    local JAVA_SCRIPT_PATH='javaScript/'
    local IMAGE_FAVICON_PATH="${IMAGE_PATH}favicon.ico"
    local IMAGE_BASE64_EXCLUDE_LOCATIONS=("${IMAGE_PATH}appleTouchIcon/" \
        "$IMAGE_FAVICON_PATH")
    local IMAGE_INCLUDE_LOCATIONS=("${IMAGE_PATH}appleTouchIcon/")
    local UNNEEDED_JAVA_SCRIPT_FILE_PATTERN=('^coffeeScript-.+$' \
        '^require-.+$' '^less-.+$')
    local UNUSED_CSS_SELECTORS_INFORMATION_FILE='unusedCSSSelectors.txt'

        # endregion

    # endregion

    # region initialize development repository

    websiteChangeDirectory
    git checkout master

    # endregion

    # region render html

    echo "Clear old builds in \"$BUILD_PATH\"."
    rm --recursive "$BUILD_PATH"
    mkdir --parents "$BUILD_PATH"
    echo 'Render html code.'
    template index.tpl 1>index.html
    cp index.html "${BUILD_PATH}index.html"

    # endregion

    # region images

    echo 'Handle images.'
    if "$USE_BASE64_ENCODING"; then
        imagesToCSSClasses "$IMAGE_PATH" '.*\.\(png\|jpg\|jpeg\|ico\)' \
            ${IMAGE_BASE64_EXCLUDE_LOCATIONS[*]} 1>"${BUILD_PATH}main.less"
        local includeImagePath
        for includeImagePath in ${IMAGE_INCLUDE_LOCATIONS[*]}; do
            echo "Copy include image \"$includeImagePath\" to \"${BUILD_PATH}${includeImagePath}\"."
            mkdir --parents "${BUILD_PATH}${includeImagePath}"
            cp --recursive "${includeImagePath}" "$(echo \
                "${BUILD_PATH}${includeImagePath}" | sed --regexp-extended \
                's/[^\/]+\/?$//g')"
        done
    else
        touch "${BUILD_PATH}main.less"
    fi
    if "$USE_BASE64_FAVICON_ENCODING"; then
        echo 'Insert base64 code for favicon in html code.'
        local escapedFaviconBase64String=$(validateSEDReplacement $(base64 --wrap \
            0 "$IMAGE_FAVICON_PATH"))
        sed --in-place --regexp-extended \
            "s/(<link [^>]*href=\")[^\"]+\.ico(\"[^>]*>)/\1data:image\/x-icon;base64,$escapedFaviconBase64String\2/g" \
            "${BUILD_PATH}index.html"
    fi

    # endregion

    # region style code

    echo 'Handle style code.'
    local temporaryMergedCssFilePath=$(mktemp)
    local temporaryImportCutedCssFilePath=$(mktemp)
    local styleEntryPointFilePath
    for styleEntryPointFilePath in $(grep --extended-regexp \
        '^ *<link.+href=".+\.(less|css)".*> *$' "${BUILD_PATH}index.html" | \
        grep --only-matching --extended-regexp 'href=".+"' | sed \
        s/^href=\"//g | sed s/\"$//g)
    do
        # TODO
        # NOTE: Deeper dependencies could also have dependencies. These aren't
        # included yet.
        echo "Grap ressource \"$styleEntryPointFilePath\" and all its dependencies."
        local dependencies=$(grep --extended-regexp '^@import url\(.+\);$' \
            "$styleEntryPointFilePath" | grep --extended-regexp \
            --only-matching '\(.+\)' | sed s/^.//g | sed s/.$//g)
        echo "Stylescheet dependencies are: \"$(echo $dependencies | sed \
            's/ /", "/g')\"."
        mergeTextFiles $dependencies 1>"$temporaryMergedCssFilePath"
        # Remove import statements.
        sed --regexp-extended 's/^@import url\(.+\);$//g' \
            "$styleEntryPointFilePath" 1>"$temporaryImportCutedCssFilePath"
        mergeTextFiles "${BUILD_PATH}main.less" "$temporaryMergedCssFilePath" \
            "$temporaryImportCutedCssFilePath" 1>"${LESS_PATH}/temp.less"
    done
    echo 'Precompile generated less code.'
    # NOTE: Parameter "--compress" is needed for later regex logic.
    lessc --compress --strict-imports "${LESS_PATH}/temp.less" "${BUILD_PATH}main.less"
    rm "${LESS_PATH}/temp.less"
    if "$USE_BASE64_ENCODING"; then
        echo 'Delete relative path references in class names.'
        # TODO
        # NOTE: We only replace "background-image: url(...)" syntax to make it
        # possible to not include images via the implicit
        # "background: url(...)" syntax.
        sed --in-place --regexp-extended \
            "s/( *background-image: *url\(.*?)(\.\.(\/|\\\))+(.+\); *)/\1\4/g" \
             "${BUILD_PATH}main.less"
        echo 'Replace image path references by their corresponding classes.'
        sed --in-place --regexp-extended \
            "s/( *)background-image: *url\((\"|')([^:]+)(\"|')\); */\1.image-data-\3;/g" \
            "${BUILD_PATH}main.less"
        local replacementPattern='(\.image-data[^@#&%+./_{; ]*?)[@#&%+./_ ]([^{;]*;)'
        while [ "$(grep --extended-regexp "$replacementPattern" \
            "${BUILD_PATH}main.less")" ]
        do
            sed --in-place --regexp-extended "s/$replacementPattern/\1-\2/g" \
                "${BUILD_PATH}main.less"
        done
        echo "Delete class reference which isn't available."
        local classReference
        for classReference in $(grep --only-matching --extended-regexp \
            '\.image-data[^;{ ]+?' "${BUILD_PATH}main.less")
        do
            if [ "$(grep --only-matching "$classReference{" "${BUILD_PATH}main.less")" == '' ]; then
                echo "Delete unneeded class reference \"$classReference\"."
                sed --in-place "s/$classReference//g" "${BUILD_PATH}main.less"
            fi
        done
        echo 'Compile final less code.'
        # NOTE: Parameter "--compress" is needed to easily remove unused classes.
        lessc --strict-imports --compress "${BUILD_PATH}main.less" "${BUILD_PATH}main.css"
        rm "${BUILD_PATH}main.less"
    else
        mv "${BUILD_PATH}main.less" "${BUILD_PATH}main.css"
        echo 'Adapt all path references to ressources.'
        sed --in-place 's/\.\.(\/|\\)//g' "${BUILD_PATH}main.css"
        echo 'Copy images.'
        cp --recursive "$IMAGE_PATH" "${BUILD_PATH}${IMAGE_PATH}"
        if "$USE_BASE64_FAVICON_ENCODING"; then
            rm "${BUILD_PATH}${IMAGE_FAVICON_PATH}"
        fi
    fi
    echo 'Remove unused css selectors.'
    local unusedCSSSelector
    local uniqCSSInformation=$(mktemp)
    uniq "$UNUSED_CSS_SELECTORS_INFORMATION_FILE" 1>"$uniqCSSInformation"
    while read unusedCSSSelector; do
        if [[ "$unusedCSSSelector" ]]; then
            local escapeSymbole
            unusedCSSSelector=$(echo "$unusedCSSSelector" | sed 's/\[/\\[/g' | \
                sed 's/\]/\\]/g' | sed 's/\./\\./g' | sed 's/\*/\\*/g' | \
                sed 's/\^/\\^/g' | sed 's/\$/\\$/g' | sed 's/, /,/g')
            local unusedCSSPattern="^$unusedCSSSelector{.*$"
            if [[ $(grep "$unusedCSSPattern" "${BUILD_PATH}main.css") ]]; then
                sed --in-place "s/$unusedCSSPattern//g" "${BUILD_PATH}main.css"
            else
                echo "Unused css pattern \"$unusedCSSPattern\" not found."
            fi
        fi
    done < "$uniqCSSInformation"
    echo 'Remove style references from html file.'
    sed --in-place --regexp-extended \
        's/^ *<link.+href=".+\.(less|css)".*> *$//g' \
        "${BUILD_PATH}index.html"
    echo 'Merge html and css file.'
    local headerEndingLine=$(grep --extended-regexp --line-number \
        ' *</head.*>' "${BUILD_PATH}index.html" | grep --extended-regexp \
        --only-matching '^[0-9]+')
    let "beforeHeaderEndingLine=$headerEndingLine-1"
    local numberOfLines=$(wc --lines "${BUILD_PATH}index.html" | grep \
        --extended-regexp --only-matching '[0-9]+')
    let "numberOfFooterLines=$numberOfLines-$beforeHeaderEndingLine"
    head --lines $beforeHeaderEndingLine "${BUILD_PATH}index.html" \
        1>"${BUILD_PATH}temp.html"
    echo '<style type="text/css">' 1>>"${BUILD_PATH}temp.html"
    cat "${BUILD_PATH}main.css" 1>>"${BUILD_PATH}temp.html"
    echo '</style>' 1>>"${BUILD_PATH}temp.html"
    tail --lines $numberOfFooterLines "${BUILD_PATH}index.html" \
        1>>"${BUILD_PATH}temp.html"
    mv "${BUILD_PATH}temp.html" "${BUILD_PATH}index.html"
    rm "${BUILD_PATH}main.css"

    # endregion

    # region scripts

    echo 'Handle java and coffee scripts.'
    cp --recursive "$COFFEE_SCRIPT_PATH" "$BUILD_PATH"
    cp --recursive "$JAVA_SCRIPT_PATH" "$BUILD_PATH"
    local neededFile
    local neededFiles=''
    for neededFile in $(determineCoffeeScriptDependencies \
        "${COFFEE_SCRIPT_PATH}${COFFEE_SCRIPT_ENTRY_POINT}" \
        "$JAVA_SCRIPT_PATH" | sed 's/\n/ /g')
    do
        if [[ "$neededFiles" ]]; then
            neededFiles+=' '
        fi
        neededFiles+="$(basename "$neededFile" | sed 's/.coffee$/.js/g')"
    done
    echo 'Remove require dependence.'
    macro --path "${BUILD_PATH}${COFFEE_SCRIPT_PATH}" --extension coffee \
        --new-version 'standalone' --first-line-regex-pattern \
        '(?P<constant_version_pattern>^## (?P<current_version>[a-zA-Z0-9\.]+))\n'
    echo 'Compile coffee script code.'
    coffee --compile --output "${BUILD_PATH}${JAVA_SCRIPT_PATH}" \
        "${BUILD_PATH}${COFFEE_SCRIPT_PATH}"
    local neededJavaScripts=''
    for neededFile in $neededFiles; do
        local needed=true
        local unneededJavaScriptFilePattern
        for unneededJavaScriptFilePattern in ${UNNEEDED_JAVA_SCRIPT_FILE_PATTERN[*]}; do
            if [[ $(echo "$neededFile" | grep --extended-regexp "$unneededJavaScriptFilePattern") ]]; then
                needed=false
                break
            fi
        done
        if $needed; then
            if [[ "$neededJavaScripts" ]]; then
                neededJavaScripts+=' '
            fi
            neededJavaScripts+="${BUILD_PATH}${JAVA_SCRIPT_PATH}${neededFile}"
        fi
    done
    echo "Script dependencies are: \"$(echo $neededJavaScripts | sed 's/ /", "/g' )\"."
    echo 'Merge javaScript.'
    mergeTextFiles $neededJavaScripts 1>"${BUILD_PATH}main.js"
    rm --recursive "${BUILD_PATH}${COFFEE_SCRIPT_PATH}"
    rm --recursive "${BUILD_PATH}${JAVA_SCRIPT_PATH}"
    # Remove javaScript include statements.
    # NOTE: These pattern assumes that "<!--[IF..." syntax is in the same line
    # as javaScript include statement.
    sed --in-place --regexp-extended \
        's/^[^<]*<script[^>]+src="[^"]+"[^>]*>[^<]*<[^>]+>//g' \
        "${BUILD_PATH}index.html"
    echo 'Merge html and javaScript code.'
    local headerEndingLine=$(grep --extended-regexp --line-number \
        ' *</head.*>' "${BUILD_PATH}index.html" | grep --extended-regexp \
        --only-matching '^[0-9]+')
    let "beforeHeaderEndingLine=$headerEndingLine-1"
    local numberOfLines=$(wc --lines "${BUILD_PATH}index.html" | grep \
        --extended-regexp --only-matching '[0-9]+')
    let "numberOfFooterLines=$numberOfLines-$beforeHeaderEndingLine"
    head --lines $beforeHeaderEndingLine "${BUILD_PATH}index.html" \
        1>"${BUILD_PATH}temp.html"
    echo '<script type="text/javaScript">' 1>>"${BUILD_PATH}temp.html"
    cat "${BUILD_PATH}main.js" 1>>"${BUILD_PATH}temp.html"
    echo -e '\n</script>' 1>>"${BUILD_PATH}temp.html"
    tail --lines $numberOfFooterLines "${BUILD_PATH}index.html" \
        1>>"${BUILD_PATH}temp.html"
    mv "${BUILD_PATH}temp.html" "${BUILD_PATH}index.html"
    rm "${BUILD_PATH}main.js"

    # endregion

    # region html

    echo 'Compress final html file.'
    htmlcompressor --output "${BUILD_PATH}index.html" \
        --remove-intertag-spaces --remove-form-attr --remove-quotes \
        --simple-doctype --remove-style-attr --remove-link-attr \
        --remove-script-attr --remove-form-attr --remove-input-attr \
        --simple-bool-attr --remove-js-protocol --remove-http-protocol \
        --remove-https-protocol --remove-surrounding-spaces max --compress-js \
        --compress-css "${BUILD_PATH}index.html"

    # endregion

    cd -
}
alias websiteRender='bash --login -c websiteRenderHelper'

function websitePublish() {
    local BUILD_PATH='build/'

    websiteRender
    websiteChangeDirectory

    # region handle staging branch

    echo 'Commit results to git hub pages.'
    git checkout gh-pages
    echo 'Copy new assets to staging branch.'
    cp --force --recursive ${BUILD_PATH}* .
    git add *
    (git commit --all --message 'New staging version compiled.' || true)
    git push
    git checkout master
    template index.tpl 1>index.html
    cd -

    # endregion
}

[[ "$0" == *build.bash ]] && websiteRender "$@"

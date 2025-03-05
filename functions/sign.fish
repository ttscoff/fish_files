function sign --wraps=codesign -d 'Sign a macOS app with Developer ID Application'
    codesign --force --verbose --sign 'Developer ID Application' -o runtime $argv
    if test $status -ne 0
        echo "Error: Signing failed for '$argv'"
        return 1
    end
end

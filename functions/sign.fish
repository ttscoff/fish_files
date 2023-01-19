function sign --wraps=codesign\ --force\ --verbose\ --sign\ \'Developer\ ID\ Application\'\ -o\ runtime --description alias\ sign=codesign\ --force\ --verbose\ --sign\ \'Developer\ ID\ Application\'\ -o\ runtime
  codesign --force --verbose --sign 'Developer ID Application' -o runtime $argv; 
end

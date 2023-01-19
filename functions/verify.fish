function verify --wraps='codesign --deep -vv --verify' --description 'alias verify=codesign --deep -vv --verify'
  codesign --deep -vv --verify $argv; 
end

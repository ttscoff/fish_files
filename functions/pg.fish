function pg --wraps='ps -ax | grep -i' --description 'alias pg=ps -ax | grep -i'
  ps -ax | grep -i $argv; 
end

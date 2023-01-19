function todos --wraps=ack\ --nobreak\ --nocolor\ \"\(TODO\|FIXME\):\"\|sed\ -E\ \"s/\(.\*:\[\[:digit:\]\]+\):.\*\(\(TODO\|FIXME\):.\*\)/\\2\ :\>\>\ \\1/\"\|grep\ -E\ --color=always\ \":\>\>.\*:\\d+\" --description alias\ todos=ack\ --nobreak\ --nocolor\ \"\(TODO\|FIXME\):\"\|sed\ -E\ \"s/\(.\*:\[\[:digit:\]\]+\):.\*\(\(TODO\|FIXME\):.\*\)/\\2\ :\>\>\ \\1/\"\|grep\ -E\ --color=always\ \":\>\>.\*:\\d+\"
  ack --nobreak --nocolor "(TODO|FIXME):"|sed -E "s/(.*:[[:digit:]]+):.*((TODO|FIXME):.*)/\2 :>> \1/"|grep -E --color=always ":>>.*:\d+" $argv; 
end

# Requires speedtest CLI (not brew install speedtest-cli,
# but the version you can download from
# <https://www.speedtest.net/apps/cli>)
#
# Requires spark plugin for sparkline support
# fisher install jorgebucaran/spark.fish
function speed
    argparse 's/sparkline=' 't/type=' -- $argv
    or return 1

    set -l type both
    if test -n "$_flag_type"
        if string match -rq '^u' -- $_flag_type
            set type upload
        else if string match -rq '^d' -- $_flag_type
            set type download
        else if string match -rq '^b' -- $_flag_type
            set type both
        else
            printf "speed: invalid --type '%s' (use upload|download|both)\n" $_flag_type 1>&2
            return 2
        end
    end

    set -l logdir ~/logs
    set -l logfile $logdir/speed.csv
    mkdir -p $logdir

    if test -n "$_flag_sparkline"
        if test ! -f $logfile
            printf "speed: no log file found at %s\n" $logfile 1>&2
            return 1
        end

        set -l lines (tail -n $_flag_sparkline $logfile)
        set -l down_vals (printf "%s\n" $lines | awk -F, '{print $2}')
        set -l up_vals (printf "%s\n" $lines | awk -F, '{print $3}')

        if test "$type" = download -o "$type" = both
            if test -n "$down_vals"
                set -l down_spark (spark $down_vals)
                set -l down_minmax (printf "%s\n" $down_vals | awk 'NR==1{min=$1;max=$1} {if($1<min)min=$1;if($1>max)max=$1} END{printf "%s %s", min, max}')
                set -l down_min (string split ' ' -- $down_minmax)[1]
                set -l down_max (string split ' ' -- $down_minmax)[2]
                printf "⬇️ %s [%s/%s]\n" $down_spark $down_min $down_max
            end
        end

        if test "$type" = upload -o "$type" = both
            if test -n "$up_vals"
                set -l up_spark (spark $up_vals)
                set -l up_minmax (printf "%s\n" $up_vals | awk 'NR==1{min=$1;max=$1} {if($1<min)min=$1;if($1>max)max=$1} END{printf "%s %s", min, max}')
                set -l up_min (string split ' ' -- $up_minmax)[1]
                set -l up_max (string split ' ' -- $up_minmax)[2]
                printf "⬆️ %s [%s/%s]\n" $up_spark $up_min $up_max
            end
        end

        return 0
    end

    tput civis 1>&2
    set -l jsonfile (mktemp)
    speedtest -f json -p no >$jsonfile &
    set -l spid $last_pid

    set -l spinner_chars '⠋' '⠙' '⠚' '⠞' '⠖' '⠦' '⠴' '⠲' '⠳' '⠓'
    set -l spinner_len (count $spinner_chars)
    set -l idx 1
    while kill -0 $spid 2>/dev/null
        printf '\r[%s] Testing' $spinner_chars[$idx] 1>&2
        set idx (math "$idx + 1")
        if test $idx -gt $spinner_len
            set idx 1
        end
        sleep 0.1
    end

    wait $spid
    set -l st $status

    printf '\r\033[2K' 1>&2

    if test $st -ne 0
        rm -f $jsonfile
        tput cnorm 1>&2
        return $st
    end

    set -l json (cat $jsonfile)
    rm -f $jsonfile

    set -l pyfile (mktemp)
    printf '%s\n' \
        'import json' \
        'import math' \
        'import sys' \
        '' \
        'data = json.load(sys.stdin)' \
        '' \
        'def calc(bandwidth):' \
        '    return int(round(bandwidth / (1024 * 100)))' \
        '' \
        'print(f"{calc(data["download"]["bandwidth"])} {calc(data["upload"]["bandwidth"])}")' >$pyfile

    set -l speeds (printf "%s\n" $json | python3 $pyfile)
    rm -f $pyfile

    set -l download (string split ' ' -- $speeds)[1]
    set -l upload (string split ' ' -- $speeds)[2]

    if test "$type" = download -o "$type" = both
        printf "⬇️ %s\n" $download
    end
    if test "$type" = upload -o "$type" = both
        printf "⬆️ %s\n" $upload
    end
    set -l timestamp (date -Iseconds)
    printf "%s,%s,%s\n" $timestamp $download $upload >>$logfile

    set -l tmpfile (mktemp)
    tail -n 100 $logfile >$tmpfile
    mv $tmpfile $logfile

    tput cnorm 1>&2
end

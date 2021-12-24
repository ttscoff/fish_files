function days_in --description 'get the number of days in a given month/year'
  if test (count $argv) -eq 0
    echo "Usage: days_in MONTH [YEAR]"
    echo "       MONTH can be numeric or texti (jan, feb, etc.)"
    echo "       if YEAR is not specified, the current year will be used"
    return 1
  end
  set -l month $argv[1]
  set -l year (date '+%Y')
  if test (count $argv) -eq 2
    set year $argv[2]
  end
  if test (string match -r '^[A-Za-z]+$' $month)
    set -l months jan feb mar apr may jun jul aug sep oct nov dec
    set month (index_of (string sub -s 1 -e 3 (string lower $month)) $months)
    if test -z "$month"
      echo "Invalid month name"
      return 1
    end
  end
  cal $month $year | awk 'NF {DAYS = $NF}; END {print DAYS}'
end

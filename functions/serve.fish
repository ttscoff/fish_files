function serve --description 'start a local server'
	set -l port 8080
	if test (count $argv) -eq 1
		set port $argv[1]
	end
	python -m SimpleHTTPServer $port &
	open http://localhost:$port
	fg
end

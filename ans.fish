function ans --description 'Get the accepted answer from StackOverflow as Markdown'
    gather --accepted-only (sl "!stackoverflow.com $argv!!")
end

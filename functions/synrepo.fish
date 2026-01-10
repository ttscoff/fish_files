function synrepo --description "Create a new bare git repository on syn"
    if string-empty $argv
        echo "synrepo: must provide a repository name" >&2
        return 1
    end

    ssh syn "mkdir -p ~/repos/$argv && cd ~/repos/$argv && git init --bare"
    git remote add origin "syn:~/repos/$argv"
    echo "Repository '$argv' created successfully."
end

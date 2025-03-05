function git-protocol-https-to-git --description 'Change git remote protocol from https to git'
    sed -i 's|https://\(\([[:alnum:]]\+\.\)\+[[:alnum:]]\+\)/|git@\1:|' .git/config
    echo "Git remote protocol has been changed from HTTPS to GIT."

    # Verify if the change was successful
    if git remote -v | grep -q 'git@'
        then
        echo "Remote protocol change verified successfully."
    else
        echo "Error: Remote protocol change failed."
    end
end

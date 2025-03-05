function setapplink --description "Generate an internal Setapp link for an app"
    set -l appId (curl -SsL "https://setapp.com/apps/$argv" | grep 'appId' | grep -Eo ':[0-9]+' | tr -d ':')
    if test -z "$appId"
        echo "Error: App ID not found for '$argv'"
        return 1
    end
    echo "App ID: "$appId
    echo "setappdiscovery://open_collection?sender_domain=https://brettterpstra.com&should_launch=0&app_id="$appId"&sender=Brett%20Terpstra"
    # open "setappdiscovery://open_collection?sender_domain=https://brettterpstra.com&should_launch=0&app_id="$appId"&sender=Brett%20Terpstra"
end

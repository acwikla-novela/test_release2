#!/bin/bash

function parse_yaml() {

  local prefix=$2
  local s='[[:space:]]*'
  local w='[a-zA-Z0-9_]*'
  local fs=$(echo @|tr @ '\034')

  sed "h;s/^[^:]*//;x;s/:.*$//;y/-/_/;G;s/\n//" $1 |
  sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
  awk -F$fs '{
    indent = length($1)/2;
    vname[indent] = $2;

    for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
        vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
        printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
    }
  }'
}

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# current project name
projectName="$(git config --get remote.origin.url | cut -d/ -f5 | cut -d. -f1)"

masterBranch=master

# checkout to master branch, this will break if the user has uncommited changes
git checkout $masterBranch

# master branch validation
if [ $branch == "master" ]; then

##  Type version
#	echo "Enter the release version number"
#	read versionNumber
##  Version from meta.yaml
eval $(parse_yaml meta.yaml)
versionNumber=$package_version

	# v1.0.0, v1.7.8, etc..
	versionLabel=v$versionNumber
	releaseBranch=master_release

  echo "Delete old branch $releaseBranch ....."
	# delete local&remote release_branch if exist, if not we get error, but that is ok
  #	ToDo   git push origin --delete $releaseBranch not working!!!
  git branch -d master_release
  git push origin --delete master_release

  git checkout $masterBranch

	echo "Started releasing $versionLabel for $projectName ....."

	# pull the latest version of the code from master
	git pull

	# create empty commit from master branch, create release_branch
	git commit --allow-empty -m "Creating Branch $releaseBranch"

	# create tag for new version from -master. If tag exist, don`t worry.
	git tag $versionLabel

	# push commit to remote origin
	git push

	# push tag to remote origin
	git push --tags origin

	# create the release branch from the -master branch
  git checkout -b $releaseBranch $masterBranch

	# checkout to master branch
	git checkout $masterBranch

  # push local releaseBranch to remote
	git push -u origin $releaseBranch

	echo "$versionLabel is successfully released for $projectName ...."

	# checkout to master branch
	git checkout $masterBranch

	# pull the latest version of the code from master
	git pull

	echo "Bye!"

else
	echo "Please make sure you are on master branch and come back!"
	echo "Bye!"
fi

echo "Click 'Enter' to exit"
read someKey

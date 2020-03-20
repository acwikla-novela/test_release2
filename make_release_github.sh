#!/bin/bash

#	ToDo   git push origin --delete $releaseBranch not working due to refs!!!
#	ToDo   override release
#	ToDo   auto-increment version in setup.py

branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

projectName="$(git config --get remote.origin.url | cut -d/ -f5 | cut -d. -f1)"
repoFullName=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')

# Personall access token, set by command: git config --global github.token XXXXXXXXXXXXXXXXX
token=$(git config --global github.token)

masterBranch=master

git checkout $masterBranch

# master branch validation
if [ $branch == "master" ]; then
  versionNumber=$(python setup.py --version)
	versionLabel=v$versionNumber
	releaseBranch=master_release

#	echo "Type release title: "
#	read title
  title=$versionLabel

	echo "Pre-release? [y/n]: "
	read prerelease
  if [ $prerelease == "y" ]; then
    prerelease="true"
  else
    prerelease="false"
  fi

  echo "Delete old branch $releaseBranch ....."
  git branch -d master_release
  git push origin --delete master_release

  git checkout $masterBranch

	echo "Started releasing $versionLabel for $projectName ....."

  generate_post_data()
{
  cat <<EOF
{
  "tag_name": "$versionLabel",
  "target_commitish": "$branch",
  "name": "$title",
  "draft": false,
  "prerelease": $prerelease,
}
EOF
}

	git pull

#  response=$(curl --data "$(generate_post_data)" "https://api.github.com/repos/$repoFullName/releases?access_token=$token");
  response=$(curl -o -I -L -s -w "%{http_code}" --data "$(generate_post_data)" "https://api.github.com/repos/$repoFullName/releases?access_token=$token")

  if [[ $response == 400 || $response == 422 ]]; then
    echo "Something go wrong, code $response"
    echo "Check if this release version not exist already"
  else
    echo "$versionLabel is successfully released for $projectName ...."

    git commit --allow-empty -m "Creating Branch $releaseBranch"

    git checkout -b $releaseBranch $masterBranch

    git checkout $masterBranch

    git push -u origin $releaseBranch

    git checkout $masterBranch

    git pull

    echo "Bye!"
  fi

else
	echo "Please make sure you are on master branch and come back!"
	echo "Bye!"
fi

echo "Click 'Enter' to exit"
read _


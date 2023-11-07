
URL=${GIT_REPOSITORY}
SRC_URL=https://github.com/TeraTermProject/teraterm.git
SRC=teraterm
DIST=github_io

if [ -z "$URL" ]; then
	echo GIT_REPOSITORY is empty
	exit 1;
fi

rm -rf $DIST
git clone $URL $DIST
(cd $DIST ; ls | egrep -v '^$DIST/.git$' | xargs rm -rf)

# main
rm -rf $SRC
git clone --branch main --depth 1 ${SRC_URL} $SRC

## /
cp -r $SRC/doc/web/* $DIST
cp $DIST/index.html.ja $DIST/index.html

## manual
mkdir $DIST/manual/5/en
cp -r $SRC/doc/en/html/* $DIST/manual/5/en
mkdir $DIST/manual/5/ja
cp -r $SRC/doc/ja/html/* $DIST/manual/5/ja

# 4-stable
rm -rf $SRC
git clone --branch 4-stable --depth 1 ${SRC_URL} $SRC

## manual
mkdir $DIST/manual/4/en
cp -r $SRC/doc/en/html/* $DIST/manual/4/en
mkdir $DIST/manual/4/ja
cp -r $SRC/doc/ja/html/* $DIST/manual/4/ja

# convert UTF-8 html
find $DIST/manual -name "*.html" -exec perl convert_utf8html.pl {} \;

# push $DIST
pushd $DIST
git config --local user.name ${GIT_USER_NAME}
git config --local user.email ${GIT_EMAIL_NAME}

# remove deleted files from repository
del_file_count=`git ls-files --deleted | wc -l`
if [ $del_file_count -ne 0 ]; then
	echo git rm `git ls-files --deleted`
	git ls-files --deleted -z | xargs -0 git rm
fi

# add new file to repository
git add .

git commit -m "update"
git push
popd

rm -rf $SRC


#URL=git@github.com:TeraTermProject/TeraTermProject.github.io.git
URL=${GIT_REPOSITORY}
#SRC_URL=https://github.com/TeraTermProject/teraterm-mirror-gitsvn.git
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

# trunk
rm -rf $SRC
git clone --branch trunk --depth 1 ${SRC_URL} $SRC

cp -r $SRC/doc/web/* $DIST
cp $DIST/index.html.ja $DIST/index.html
mkdir $DIST/manual/5/en
cp -r $SRC/doc/en/html/* $DIST/manual/5/en
mkdir $DIST/manual/5/ja
cp -r $SRC/doc/ja/html/* $DIST/manual/5/ja

# 4-stable/manual
rm -rf $SRC
git clone --branch 4-stable --depth 1 ${SRC_URL} $SRC

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
git rm `git ls-files --deleted`
git add .
git commit -m "update"
git push
popd

rm -rf $SRC

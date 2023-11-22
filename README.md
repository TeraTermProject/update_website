# webサイトをアップデートする

環境変数を設定、スクリプトを実行する

```
#export GIT_REPOSITORY=https://zmatsuo:${PASSWD}@github.com/TeraTermProject/TeraTermProject.github.io.git
export GIT_REPOSITORY=https://github.com/TeraTermProject/TeraTermProject.github.io.git
export GIT_USER_NAME=zmatsuo
export GIT_USER_EMAIL=6488847+zmatsuo@users.noreply.github.com
bash update_website.sh
```

## 追加ファイル

add/ フォルダにファイルを置くと、webサイトにファイルが追加される

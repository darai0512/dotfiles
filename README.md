# unix系デバイス移行
## 2018MBP to Apple M3 Pro on 20231120

新デバイス側で設定・移行した方法

### 1. Preference

- キーボードリピート速度
- キーボードショートカット -> 修飾キー：capslock to ctrl
- トラックパッドで3本指ドラッグ　https://support.apple.com/ja-jp/HT204609
- 色温度
- IME設定からKeyboard入力で先頭自動大文字の解除
- bluetoothをメニューバーに：コントロールセンター
  - mouseなど設定して切り替え
- 時計を秒まで表示：コントロールセンター

### 2. Finder

- カラム表記
- `ユーザー`やゴミ箱をよく使う項目へ
  - https://minacoole.com/macbookpro-finder-8/
- dotfiles表示　https://qiita.com/cs_sonar/items/aa0f0d5ddfbc108e4b8e

### 3. Terminal

- default shellをbashに
  - https://zenn.dev/akido_/articles/7c9638e164b847
- [HomeBrew](https://brew.sh/) && `$brew install rcmdnk/file/brew-file` && `$pbpaste > ~/config/brewfile/Brewfile` && `$brew file install`
  - brew-file入れたら.bashrcを https://homebrew-file.readthedocs.io/en/latest/installation.html
  - 移行元の操作 https://homebrew-file.readthedocs.io/en/latest/getting_started.html
  - kitting設定とのバッティングしないように注意

### 4. 各アプリを起動&設定、dotfilesも

- 英かな
  - KeyRemapと除外アプリ設定
  - Appleシリコンでも動く、ありがたや
- .gitconfig
- AirDropで設定移行
  - スティッキーズ
  - Clipy snipet.txt
  - iterm2: settings->Profiles->Other Actions export json
- Docker => Settings->K8s->enable, restart

### Opt. apache

`brew tap homebrew/apache`でもいいが、ここではOS X標準のapacheを使う

以下、特定ディレクトリ(`~/Sites/`)以下のファイルに`localhost:80`でアクセスするための設定（Sierra/High Sierra/Mojaveで検証済）

- ユーザーディレクトリの有効化
  - 下記のコメントアウトを外す
  - phpを利用したい場合は`php7_module`(Sierraなど古いと`php5_module`)を含む行のコメントアウトも外す

```
$sudo vim /etc/apache2/httpd.conf
...
#LoadModule userdir_module libexec/apache2/mod_userdir.so
...
#Include /private/etc/apache2/extra/httpd-userdir.conf
...
```

- `/etc/apache2/extra/httpd-userdir.conf`の下記コメントアウトを外す
  - `/etc`と`/private/etc`は同じinodeなので`/private/etc/apache2/extra/httpd-userdir.conf`を修正してもOK

```
$sudo vim /etc/apache2/extra/httpd-userdir.conf
#Include /private/etc/apache2/users/*.conf
```

- 独自モジュールを追加できるようになったので、開放したいディレクトリを指定して再起動

```
$sudo vim /private/etc/apache2/users/`whoami`.conf
<Directory "/Users/darai0512/Sites/"> # s/darai0512/`whoami`/
  AllowOverride All
  Require all granted
</Directory>
# 以下は不要（特定のファイルアクセス時にヘッダーを追加する設定）
<FilesMatch "\.(mjs)$">
  Header set Content-Disposition attachment
</FilesMatch>
$sudo apachectl restart
```

- 確認

```
$mkdir /Users/`whoami`/Sites
$echo 'work!' > ~/Sites/index.html
```

http://localhost/~darai0512

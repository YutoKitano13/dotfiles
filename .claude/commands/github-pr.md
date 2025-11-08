# PRを作成する

以下の手順でbaseブランチ $ARGUMENTS に対してPRを作成してください。

## 手順
1. `git status` で現在の状態を確認し、もしpushされていないcommitがあれば `git push` する。
2. `git diff origin/<baseブランチ名>..HEAD` を実行し、今回の変更内容を確認する。
3. `gh pr create --draft --title <title> --body <body>` の形式でコマンドを実行しPRを作成する。

## 注意点
- PRはDraftで作成すること
- もし '.github/' ディレクトリ内にPRのテンプレートファイルが存在すれば、その形式でPRの本文を生成すること。


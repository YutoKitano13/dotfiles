---
name: worktree-create
description: "現在のリポジトリで新規ブランチを切って git worktree を作成するスキル。worktree はリポジトリの隣（../{repo}-{branch}）に配置する。トリガー: 'worktree-create', 'worktree作って', 'worktree切って', '並行作業用に切って'。"
---

# Worktree Create

現在のリポジトリで新規ブランチを切り、隣接ディレクトリに git worktree を作成するスキル。並行作業・hotfix・サブエージェントへのタスク委譲などに使う。

## 使用タイミング

- 現在のブランチ作業を中断せずに別ブランチで並行作業したい時
- ユーザーが「worktree作って」「並行作業用にブランチ切って」と言った時
- レビュー対応・hotfix など、既存作業ツリーを汚したくない時

## 前提条件

- カレントディレクトリが git 管理下（`.git` を持つリポジトリ内）であること
- そうでない場合は実行を中断し、対象リポジトリへの `cd` をユーザーに依頼する

## ワークフロー

### Step 1: 事前確認

```bash
# git 管理下か確認
git rev-parse --show-toplevel

# 現在のブランチを確認（= worktree のベースになる）
git branch --show-current

# 既存 worktree を一覧（重複検知のため）
git worktree list

# 未コミット変更の有無（情報として把握）
git status --short
```

- `git rev-parse` が失敗したら git リポジトリ外。実行を中断してユーザーに通知する
- 現在のブランチ名を**ベースブランチとして記録**する

### Step 2: ブランチ名とパスの決定

ユーザーから用途・タスク内容を聞き、適切なブランチ名を提案する。

**ブランチ名のルール:**
- `<type>/<kebab-case-description>` 形式（例: `feat/add-user-auth`, `fix/login-redirect`）
- type: `feat`, `fix`, `refactor`, `docs`, `chore`, `test` など
- ユーザーが明示的に指定した場合はそれを優先

**worktree ディレクトリ名のルール:**
- 配置場所: リポジトリの**隣**（`../`）
- ディレクトリ名: `{repo-name}-{sanitized-branch}` 形式
  - リポジトリ名: `basename $(git rev-parse --show-toplevel)`
  - ブランチ名の `/` は `-` に置換（パスに使えるよう正規化）
  - 例: リポジトリ `webinar-api` + ブランチ `feat/add-auth` → `../webinar-api-feat-add-auth`

提案した名前をユーザーに確認してから次に進む。

### Step 3: 重複チェック

```bash
# 同名ブランチが既に他 worktree でチェックアウトされていないか
git worktree list | grep -F "[<branch-name>]"

# 配置先パスが既に存在しないか
ls -d "../{repo}-{sanitized-branch}" 2>/dev/null
```

- どちらかにヒットしたらユーザーに報告し、別名を提案する
- 同じブランチを 2 つの worktree で同時にチェックアウトすることは git の仕様上できない

### Step 4: worktree の作成

```bash
# 新規ブランチを切って worktree を作成（ベース = 現在のブランチ）
git worktree add ../<repo>-<sanitized-branch> -b <branch-name>
```

- `-b` で新規ブランチ作成
- ベースは現在の HEAD（明示指定しなくても OK）
- エラーが出たら原因をユーザーに報告。`--force` は使わない

### Step 5: 作成後の案内

#### 5-1. 作成パスの提示

絶対パスで明示する（後の `cd` やエディタで開く操作で迷わないように）。

```bash
# 作成された worktree の絶対パスを取得
realpath "../<repo>-<sanitized-branch>"
```

#### 5-2. gitignore 設定ファイルのコピー案内

worktree は object database を共有するが、**gitignore されたファイル（`.env`, `.env.local`, `vendor/`, `node_modules/` など）は引き継がれない**。
プロジェクトによっては動作に必須なので、コピーすべき候補をリストアップして案内する。

```bash
# .env 系ファイルを検出（実際にコピーはしない、ファイル名提示まで）
find . -maxdepth 2 -type f \( -name ".env" -o -name ".env.local" -o -name ".env.development" \) 2>/dev/null
```

**重要**: `.env` などの中身は読まない・コピーしない。**ファイル名の提示と「手動コピーを推奨」のメッセージ**に留める。組織ポリシーで認証情報の取り扱いに該当するため。

ユーザーへの提示例:
> 以下のファイルは worktree に引き継がれていません。必要に応じて手動でコピーしてください:
> - `.env`
> - `.env.local`
>
> コピーコマンド例: `cp .env <worktree-path>/.env`

#### 5-3. worktree 一覧表示

最終状態を可視化する。

```bash
git worktree list
```

### Step 6: 結果のまとめ

ユーザーに以下を簡潔に報告:

- 作成した worktree の**絶対パス**
- 切ったブランチ名 & ベースブランチ
- コピー推奨ファイル（あれば）
- 削除方法のヒント: `git worktree remove <path>` & `git branch -D <branch>`

## 重要な注意事項

- **git 管理下でのみ実行**: `git rev-parse --show-toplevel` で確認してから着手する
- **配置場所は固定**: `../{repo}-{sanitized-branch}` 形式。他の場所を勝手に選ばない
- **`--force` 禁止**: 既存ディレクトリやブランチと衝突したら別名を提案する。強制上書きしない
- **`.env` の中身は触らない**: ファイル名の提示のみ。コピーはユーザーに任せる
- **ベースは現在のブランチ**: main/develop を勝手に推測しない。実行時の HEAD を起点にする
- **ブランチ名はユーザー確認後に作成**: 提案 → 合意 → 実行の順序を守る
- **未コミット変更があっても worktree 作成自体は可能**: ただしユーザーには現状を伝える

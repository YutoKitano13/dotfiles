---
name: commit-push-pr
description: "実装完了後にブランチ作成・コミット・プッシュ・Draft PR作成までを一括で行うスキル。トリガー: 'commit-push-pr', 'PRまで出して', 'プルリク作成', 'ブランチ切ってPR'。"
---

# Commit, Push & Draft PR

実装完了後に、新しいブランチの作成からDraft PRの作成までを一括で行うスキルです。

## 使用タイミング

- 機能実装やバグ修正が完了した時
- ユーザーが「PRまで出して」「コミットしてPR作って」と言った時

## ワークフロー

### Step 1: 事前確認

現在の状態を把握します。

```bash
# 現在のブランチを確認（= PRのベースブランチになる）
git branch --show-current

# 変更内容を確認
git status
git diff HEAD
```

- **現在のブランチ名を記録する**: これがPRのベースブランチ（base）になる
- 変更がない場合はユーザーに通知して終了する

### Step 2: PRテンプレートの確認

リポジトリに`.github`配下のPRテンプレートがあるか確認します。

```bash
# PRテンプレートの検索（大文字小文字両方）
find .github -iname "pull_request_template*" -type f 2>/dev/null
```

テンプレートが見つかった場合は、その内容を読み取ってPR本文のベースとして使用します。

### Step 3: ブランチの作成

変更内容に基づいた適切なブランチ名を生成します。

```bash
# ブランチ名の規則: <type>/<short-description>
# type: feat, fix, refactor, docs, chore, test など
git checkout -b <branch-name>
```

**ブランチ名のルール:**
- `feat/add-user-auth` のように `<type>/<kebab-case-description>` 形式
- 短く、変更内容が分かる名前にする
- ユーザーがブランチ名を指定した場合はそれを使用する

### Step 4: コミット

変更をステージングしてコミットします。

```bash
# 関連ファイルをステージング（.envや秘密情報を含むファイルは除外）
git add <files>

# コミットメッセージの作成
git commit -m "$(cat <<'EOF'
<type>: <簡潔な変更の説明>

<変更の詳細（必要に応じて）>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

**コミットメッセージのルール:**
- Conventional Commits形式: `feat:`, `fix:`, `refactor:` など
- 1行目は簡潔に（50文字以内を目安）
- 必要に応じて本文に詳細を記載
- `Co-Authored-By` を末尾に付与

### Step 5: プッシュ

リモートにブランチをプッシュします。

```bash
git push -u origin <branch-name>
```

### Step 6: Draft PRの作成

#### テンプレートがある場合

テンプレートの各セクションを変更内容に基づいて埋めてPRを作成します。

```bash
gh pr create --draft --base <base-branch> --title "<PRタイトル>" --body "$(cat <<'EOF'
<テンプレートに基づいたPR本文>
EOF
)"
```

#### テンプレートがない場合

以下のデフォルトフォーマットを使用します。

```bash
gh pr create --draft --base <base-branch> --title "<PRタイトル>" --body "$(cat <<'EOF'
## 概要

<変更内容の要約を1〜3文で記載>

## 変更内容

<変更の詳細をbullet pointで記載>

## 確認したこと

- [ ] <実施した確認事項>
- [ ] <動作確認の内容>

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Step 7: 結果の報告

作成したPRのURLをユーザーに報告します。

```bash
# PR URLの取得
gh pr view --json url -q '.url'
```

## 重要な注意事項

- **ベースブランチ**: Step 1で確認した「元のブランチ」を必ず `--base` に指定する。mainやdevelopを推測してはならない
- **Draft PR**: 必ず `--draft` フラグを付けてPRを作成する
- **秘密情報**: `.env`, `credentials`, API keyなどを含むファイルはコミットしない。検出した場合はユーザーに警告する
- **ブランチ名の確認**: ブランチ作成前にユーザーに提案して確認を取る
- **コミットメッセージ**: 変更内容を正確に反映した内容にする
- **PRテンプレート**: `.github/PULL_REQUEST_TEMPLATE.md` や `.github/pull_request_template.md` などが存在する場合は必ずそれを使用する
- **git hookのスキップ禁止**: `--no-verify` は使わない。hookが失敗したら原因を調査して修正する

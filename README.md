# メディアリテラシー分析プラグイン

## 概要
これは[media_literacy_game_backend](https://github.com/tamacampus/media_literacy_game_backend)をティラノビルダーから呼び出すためのプラグインです。
投稿文や謝罪文をメディアリテラシーの観点から分析し、リスクレベルを判定します。

## 機能
- 投稿文のメディアリテラシー分析
- 謝罪文の適切性評価
- 文脈情報を考慮した分析

## 使用する変数

### 入力変数
- `f.analysisInput` - 分析対象のテキスト

### 出力変数
- `f.riskLevel` - リスクレベル（0:非常に低い〜4:非常に高い）
- `f.riskLevelText` - リスクレベルのテキスト表現
- `f.riskExplanation` - リスクの説明文

## パラメータ設定

### APIサーバーURL
分析APIのURLを指定します。デフォルト: `https://media-literacy-game-api.starry-night.dev`

### 分析モード
- `post` - 投稿分析モード
- `apology` - 謝罪文分析モード

### 文脈情報
投稿者の情報や現在のSNS環境などの背景情報を直接入力できます（最大1000文字、オプション）

## 使用例

```tyranoscript
; 分析対象のテキストを設定
[iscript]
f.analysisInput = "今日は楽しい一日でした！";
[endscript]

; メディアリテラシー分析を実行（文脈情報付き）
[media_literacy_analyzer api="https://media-literacy-game-api.starry-night.dev" analyze_mode="post" context="投稿者は大学生で、SNSでの影響力は小さい。現在のSNS環境は比較的穏やか。"]

; 結果を表示
リスクレベル: [emb exp="f.riskLevelText"][l][r]
説明: [emb exp="f.riskExplanation"][l][r]
```

### 文脈情報なしの使用例

```tyranoscript
; 分析対象のテキストを設定
[iscript]
f.analysisInput = "申し訳ございません";
[endscript]

; メディアリテラシー分析を実行（文脈情報なし）
[media_literacy_analyzer api="https://media-literacy-game-api.starry-night.dev" analyze_mode="apology"]
```

## 文脈情報の活用
文脈情報を提供することで、より適切な分析が可能になります：
- 投稿者の属性（年齢、職業、影響力など）
- 現在のSNS環境（炎上しやすい話題、社会情勢など）
- 企業や公人の場合はその立場や責任範囲

文脈情報を設定しない場合は、一般的な基準で分析されます。

## ティラノビルダー向け機能
### 説明文出力機能
拡張機能内部で説明文を出力する機能です。この機能には自動改ページ機能が組み込まれており、長文でもメッセージボックスを溢れることなく表示できます。

### 投稿分析・謝罪文分析切り替え機能
ドロップダウンから簡単にモードを切り替えできる機能です。

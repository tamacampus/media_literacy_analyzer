[macro name="media_literacy_analyzer"]

[iscript]
(async () => {
    try {
        const agreedToResearch = (f.agreedToResearch === 1) ? true : false;
        // APIリクエストのパラメータを準備
        const requestData = {
            text: f.analysisInput,
            agreedToResearch: agreedToResearch
        };
        
        // 文脈情報が指定されている場合は追加
        if (mp.context && mp.context.trim() !== '') {
            requestData.context = mp.context;
            console.log('文脈情報を追加:', mp.context);
        }

        // APIエンドポイントを分析モードに応じて選択
        const endpoint = mp.analyze_mode === 'apology' ? '/apology' : '/analyze';
        
        console.log('APIリクエスト:', mp.api + endpoint, requestData);
        
        // API呼び出し
        const response = await fetch(`${mp.api}${endpoint}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        });
        

        if (!response.ok) {
            console.warn(`API呼び出しエラー: ${response.status}`);
            throw new Error(`API呼び出しエラー: ${response.status}`);
        }

        const result = await response.json();
    
        if (!result.success) {
            console.warn('分析失敗:', result.error);
            throw new Error(result.error || '分析に失敗しました');
        }

        // リスクレベルを数値に変換
        const riskLevelToNumber = {
            "very low": 0,
            "low": 1,
            "medium": 2,
            "high": 3,
            "very high": 4
        };
        
        // 分析結果をゲーム変数に保存
        if (riskLevelToNumber[result.analysis.riskLevel] === undefined) {
            console.warn('未知のリスクレベル:', result.analysis.riskLevel);
            f.riskLevel = 0;  // デフォルト値
        }else{
            f.riskLevel = riskLevelToNumber[result.analysis.riskLevel];
        }
        f.riskLevelText = result.analysis.riskLevel;  // 元のテキスト値も保存
        f.riskExplanation = result.analysis.explanation;

        console.log('炎上分析完了:', f.riskLevel, '(', f.riskLevelText, ')');

    } catch (error) {
        console.error('メディアリテラシー分析エラー:', error);
        // エラー時でもゲームを進行させるためのデフォルト値を設定
        f.riskLevel = 0;  // very low に相当
        f.riskLevelText = "very low";
        f.riskExplanation = "分析に失敗しました";
    }
    finally {
        // 3. シナリオの進行を再開
        console.log("シナリオの進行を再開",mp.show_result);
        if(mp.show_result){
            // 結果表示
            TYRANO.kag.ftag.startTag("jump", {target: "result"});
        }else{
            // 結果非表示
            TYRANO.kag.ftag.startTag("jump", {target: "end"});
        }
    }
})();
[endscript]

[cm  ]
[tb_start_text mode=1 ]
読み込み中……
[_tb_end_text]

[s  ]
*result

[cm  ]
[iscript]
// 説明文を改ページ用に分割（1ページ目80文字、2ページ目以降120文字）
f.explanationPages = [];
const firstPageChars = 80;
const otherPageChars = 120;
const fullText = f.riskExplanation || "";

if (fullText.length <= firstPageChars) {
    // 短い場合はそのまま1ページに
    f.explanationPages.push(fullText);
} else {
    // 長い場合は分割
    let currentPosition = 0;
    let pageIndex = 0;
    
    while (currentPosition < fullText.length) {
        // 現在のページの最大文字数を決定（1ページ目は80文字、それ以降は120文字）
        const maxCharsForCurrentPage = pageIndex === 0 ? firstPageChars : otherPageChars;
        let endPosition = Math.min(currentPosition + maxCharsForCurrentPage, fullText.length);
        
        // 文の途中で切れないように調整（句読点を探す）
        if (endPosition < fullText.length) {
            const lastPeriod = fullText.lastIndexOf('。', endPosition);
            const lastComma = fullText.lastIndexOf('、', endPosition);
            const breakPoint = Math.max(lastPeriod, lastComma);
            
            // 句読点が見つかり、かつ最大文字数の半分以上の位置にあれば、そこで区切る
            if (breakPoint > currentPosition && breakPoint - currentPosition > maxCharsForCurrentPage / 2) {
                endPosition = breakPoint + 1;
            }
        }
        
        f.explanationPages.push(fullText.substring(currentPosition, endPosition));
        currentPosition = endPosition;
        pageIndex++;
    }
}

// リスクレベルを日本語表記に変換
const riskLevelMap = {
    0: "非常に低い",
    1: "低い",
    2: "中程度",
    3: "高い",
    4: "非常に高い"
};
f.riskLevelJa = riskLevelMap[f.riskLevel] || "不明";

// ページカウンターをリセット
f.currentPage = 0;
[endscript]

*display_page
[cm  ]

[if exp="f.currentPage == 0"]
[tb_start_tyrano_code]
リスクレベル：[emb exp="f.riskLevelJa"][r]
[_tb_end_tyrano_code]
[endif]

[tb_start_tyrano_code]
[emb exp="f.explanationPages[f.currentPage]"]
[_tb_end_tyrano_code]

[iscript]
f.currentPage++;
[endscript]

[if exp="f.currentPage < f.explanationPages.length"]
[tb_start_tyrano_code]
[r]（続く...）[p]
[_tb_end_tyrano_code]
[jump target="*display_page"]
[else]
[p]
[endif]

*end
[cm  ]
[endmacro]
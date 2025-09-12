/*
    ティラノビルダープラグイン開発用のテンプレート
    まず、このファイルを編集してプラグイン開発を試してみると良いでしょう。    
*/

'use strict';
module.exports = class plugin_setting {
    
    constructor(TB) {
        
        /* TBはティラノビルダーの機能にアクセスするためのインターフェスを提供する */
        this.TB = TB;
        
        /* プラグイン名を格納する */
        this.name= TB.$.s("メディアリテラシー分析");
        
        /*プラグインの説明文を格納する*/
        this.plugin_text= TB.$.s("投稿文や謝罪文をメディアリテラシーの観点から分析するプラグインです。");
        
        /*プラグイン説明用の画像ファイルを指定する。プラグインフォルダに配置してください*/
        this.plugin_img = "no_image";
        
    }
    
    
    /* プラグインをインストールを実行した時１度だけ走ります。フォルダのコピーなどにご活用ください。*/
    triggerInstall(){
        app.config.project_config["map_var"]["analysisInput"]={"val":"入力内容","kind":"f"};
        app.config.project_config["map_var"]["riskLevel"]={"val":"0","kind":"f"};
        app.config.project_config["map_var"]["riskLevelText"]={"val":"リスクレベル(テキスト)","kind":"f"};
        app.config.project_config["map_var"]["riskExplanation"]={"val":"リスク説明","kind":"f"};
    }
    
    /*
        追加するコンポーネントを定義します。
    */
    
    defineComponents(){
        
        var cmp = {};
        var TB = this.TB;
        
        
        /*
            cmp配列
            cmpにプラグイン用のコンポーネントを定義していきます。
            配列名にはタグ名を指定してください。
            他のタグと被らないように世界で一つだけの名称になるように工夫してください。
            （自分の所持しているドメイン名を含めるなど）
        */
        
        /*
            sample_component_1 
            次のパラメータのサンプルを設置
            Image:イメージ選択
            
        */
        
        cmp["media_literacy_analyzer"] = {
            
            "info":{
                
                "default":true, /*trueを指定するとコンポーネントがデフォルトで配置されます。*/
                "name":TB.$.s("メディアリテラシー分析"), /* コンポーネント名称 */
                "help":TB.$.s("投稿文や謝罪文をメディアリテラシーの観点から分析するプラグインです。"), /* コンポーネントの説明を記述します */ 
                "icon":TB.$.s("s-icon-star-full") /* ここは変更しないでください */
                
            },
            
            /* コンポーネントの情報の詳細を定義します */
            
            "component":{
                
                name : TB.$.s("メディアリテラシー分析"), /* コンポーネント名称 */
                component_type : "Simple", /*タイムラインのコンポーネントタイプ */
                
                /*ビューに渡す値*/
                default_view : {
                    base_img_url : "data/bgimage/",  /*画像選択のベースとなるフォルダを指定*/
                    icon : "s-icon-star-full", /*変更しない*/
                    icon_color : "#FF4500", /*変更しない*/
                    category : "plugin" /*変更しない*/
                },
                
                /*変更しない*/
                param_view : {
                },
            
                /* コンポーネントのパラメータを定義していきます */
                param:{

                    /*APIサーバーのURL*/
                    "api" : {
                        type : "Text",
                        name : TB.$.s("APIサーバーURL"),
                        help : TB.$.s("APIサーバーのURLを指定してください"),
                        vital : true,
                        default_val : "https://media-literacy-game-api.starry-night.dev",
                        validate : {
                            required : true
                        }
                    },
                    "show_result": {
                        type: "Check",
                        name: TB.$.s("結果表示"),
                        default_val: true,
                    },
                    "analyze_mode": {
                        type: "Select",
                        name: TB.$.s("分析モード"),
                        help: TB.$.s("分析モードを選択してください"),
                        vital: true,
                        default_val: "post",
                        select_list: [{
                            val: "post",
                            name: TB.$.s("投稿分析")
                        }, {
                            val: "apology",
                            name: TB.$.s("謝罪文分析")
                        }]
                    },
                    "context": {
                        type: "Text",
                        name: TB.$.s("文脈情報"),
                        help: TB.$.s("投稿者の情報や現在のSNS環境などの背景情報を入力してください（最大1000文字）"),
                        vital: false,
                        default_val: "",
                        validate: {
                            required: false
                        }
                    }
                }
            }
            
        };
        return cmp;
    }
}


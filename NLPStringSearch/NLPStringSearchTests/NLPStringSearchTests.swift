//
//  NLPStringSearchTests.swift
//  NLPStringSearchTests
//
//  Created by Jeffrey Bergier on 2020/05/02.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import XCTest
@testable import NLPStringSearch

class NLPStringSearchTests: XCTestCase {

    // Article Text: https://www3.nhk.or.jp/news/html/20200501/k10012415011000.html
    let inputString = """
    関西電力は、福井県にある大飯原子力発電所３号機の定期検査の作業開始を新型コロナウイルスの感染防止のため２か月から３か月程度、延ばすことを決めました。
    およそ年１回の頻度で実施することが決まっている原発の定期検査では全国から作業員が集まります。
    福井県にある大飯原発３号機でも今月８日からの検査に県外から900人前後の作業員が集まる見通しで、福井県の杉本知事は先月、新型コロナウイルスの感染防止のため、福井に来る前に作業員は２週間の自宅待機を関西電力に求めるなどしていました。
    これに関して、大飯原発の文能一成所長が１日、地元の福井県おおい町を訪れ、定期検査の作業開始を２か月から３か月程度延ばす方針を伝えました。
    理由は、感染の拡大を防ぐためとしています。
    関西電力では、定期検査の開始時期については、今後、作業を請け負う協力会社などと調整したうえで決めるとしています。
    """

    let outputKatakana = """
    カンサイデンリョクハ､フクイケンニアルオオイゲンシリョクハツデンショ3ゴウキノテイキケンサノサギョウカイシヲシンガタコロナウイルスノカンセンボウシノタメ2カゲツカラ3カゲツテイド､ノバスコトヲキメマシタ｡
    オヨソネン1カイノヒンドデジッシスルコトガキマッテイルゲンパツノテイキケンサデハゼンコクカラサギョウインガアツマリマス｡
    フクイケンニアルオオイゲンパツ3ゴウキデモコンゲツ8カカラノケンサニケンガイカラ900ニンゼンゴノサギョウインガアツマルミトオシデ､フクイケンノスギモトチジハセンゲツ､シンガタコロナウイルスノカンセンボウシノタメ､フクイニクルマエニサギョウインハ2シュウカンノジタクタイキヲカンサイデンリョクニモトメルナドシテイマシタ｡
    コレニカンシテ､オオイゲンパツノブンノウイッセイショチョウガ1カ､ジモトノフクイケンオオイマチヲオトズレ､テイキケンサノサギョウカイシヲ2カゲツカラ3カゲツテイドノバスホウシンヲツタエマシタ｡
    リユウハ､カンセンノカクダイヲフセグタメトシテイマス｡
    カンサイデンリョクデハ､テイキケンサノカイシジキニツイテハ､コンゴ､サギョウヲウケオウキョウリョクカイシャナドトチョウセイシタウエデキメルトシテイマス｡
    """
    let outputLatin = """
    kansaidenryokuha､fukuikenniaruooigenshiryokuhatsudensho3goukinoteikikensanosagyoukaishiwoshingatakoronauirusunokansenboushinotame2kagetsukara3kagetsuteido､nobasukotowokimemashita｡
    oyosonen1kainohindodejisshisurukotogakima~tsuteirugenpatsunoteikikensadehazenkokukarasagyouingaatsumarimasu｡
    fukuikenniaruooigenpatsu3goukidemokongetsu8kakaranokensanikengaikara900ninzengonosagyouingaatsumarumitooshide､fukuikennosugimotochijihasengetsu､shingatakoronauirusunokansenboushinotame､fukuinikurumaenisagyouinha2shuukannojitakutaikiwokansaidenryokunimotomerunadoshiteimashita｡
    korenikanshite､ooigenpatsunobunnouisseishochouga1ka､jimotonofukuikenooimachiwootozure､teikikensanosagyoukaishiwo2kagetsukara3kagetsuteidonobasuhoushinwotsutaemashita｡
    riyuuha､kansennokakudaiwofusegutametoshiteimasu｡
    kansaidenryokudeha､teikikensanokaishijikinitsuiteha､kongo､sagyouwoukeoukyouryokukaishanadotochouseishitauedekimerutoshiteimasu｡
    """
    
    func test_japaneseToLatin() {
        let outputLatin = Search.japaneseToLatin(self.inputString)
        XCTAssertEqual(outputLatin, self.outputLatin)
    }

    func test_japaneseToKatakana() {
        let outputKatakana = Search.japaneseToKatakana(self.inputString)
        XCTAssertEqual(outputKatakana, self.outputKatakana)
    }

}

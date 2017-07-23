# README
* Ruby version:2.3.3
* Rails Version:5.0.2
* Test Suite:Rspec3.6.0
* Database:sqlite3 (1.3.13-x64-mingw32)

## 特徴

- サイファー開催をするためのモバイルアプリ向けAPI

## 詳細

### 利用の流れ
0. twitter, facebook, googleのいずれかのアカウントでfirebaseを通してOAuth認証
1. ユーザー作成
2. アクセストークン取得
3. コミュニティ作成
4. コミュニティに紐づいた形でサイファー作成
5. ユーザー、コミュニティ、サイファーの各情報の閲覧、更新、削除

## エンドポイント

### 1.ユーザー作成

#### リクエスト詳細

- JSON型式
- リクエストボディに入れる

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| name | ○ | String | ユーザー名 | - |
| home | ○ | String | 活動本拠地 | - |
| bio | ○ | String | bio | - |
|mc_flag| ○ | Boolean|mcならtrue|-|
|dj_flag| ○ | Boolean|djならtrue|-|
|trackmaker_flag| ○ | Boolean|trackmakerならtrue|-|
|firebase_uid|○|String|firebaseのID|-|
| twitter_account |  | String | 連携twitterアカウント | - |
| facebook_account |  | String | 連携facebookアカウント | - |
| google_account |  | String | 連携googleアカウント | - |
| thumbnail|  | String | サムネイルパス | - |

#### URI

| メソッド | URI | 備考 |
|-|-|-|
| POST | /api/v1/users/signup | - |

#### レスポンス

| ステータス | 詳細 |
|-|-|
|201|作成成功|
|400|失敗|


### 2.アクセストークン取得

#### リクエスト詳細

- JSON型式
- リクエストボディに入れる

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| firebase_uid | ○ | String | firebaseのid | - |

#### URI

| メソッド | URI | 備考 |
|-|-|-|
| POST | /api/v1/users/login | - |

#### レスポンス

| ステータス | 詳細 |
|-|-|
|201|アクセストークン作成成功|
|400|失敗(パラメータ不正)|
|404|失敗(firebaseidなし)|

### 3.コミュニティ作成

#### リクエスト詳細
- JSON型式
- リクエストボディに入れる

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| name | ○ | String | コミュニティ名 | - |
| home | ○ | String | 活動本拠地 | - |
| bio | ○ | String | 活動内容 | - |
| thumbnail| ○ | String | サムネイルパス | - |
| twitter_account |  | String | twitterアカウント | あれば登録 |
| facebook_account |  | String | フェイスブッカケアカウント | あれば登録 |

#### URI

| メソッド | URI | 備考 |
|-|-|-|
| POST | /api/v1/communities | - |

#### レスポンス

| ステータス | 詳細 |
|-|-|
| 201 | 成功 |
|400|失敗(パラメータ不正)|
|401|認証失敗|


### 4.サイファー作成

#### リクエスト詳細
- JSON型式
- リクエストボディに入れる

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
|community_id|○|Integer|コミュニティid|-|
| name | ○ | String | サイファー名 | - |
| info| ○| String | サイファー情報 | - |
| cypher_from | ○ | DateTime | 開始日時 | - |
| cypher_to | ○ | DateTime | 終了日時 | - |
| place | ○ | String | 開催地 | - |
| capacity |  | Integer | 定員 | 基本OFF |

#### URI

| メソッド | URI | 備考 |
|-|-|-|
| POST | /api/v1/communities/:community_id/cyphers | コミュニティIDも必要なのでここで |

#### レスポンス

| ステータス | 詳細 |
|-|-|
|201|成功|
|400|失敗(パラメータ不正)|
|401|失敗(認証不正)|
|409|失敗(コミュニティホストじゃない)|

### 5.1. 閲覧

#### 5.1.1. コミュニティ情報詳細型：community

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | コミュニティID | - |
| name | ○ | String | コミュニティ名 | - |
| home | ○ | String | 活動本拠地 | - |
| bio | ○ | String | 活動内容 | - |
| twitter_account |  | String | twitterアカウント | - |
| facebook_account |  | String | facebookアカウント | - |
| tags| ○ | tag[] | タグ | - |
| hosts | ○ | User[] | コミュニティ主催者 | - |
| members |  | User[] | コミュニティ参加者 | - |
| regular_cypher |  | hash | 定期開催サイファー情報 | 単発開催の場合があるので必須ではない |
|　|place|String|||
|　|cypher_day|String|||
|　|cypher_from|String|||
|　|cypher_to|String|||
| thumbnail_url|  | String | サムネイルパス | - |
| past_cyphers|  | CypherSummary[] | 過去の開催サイファー | - |
| future_cyphers|  | CypherSummary[] | 当日以降ののサイファー | - |

##### コミュニティ詳細 取得URI

| メソッド | URI | 備考 |
|-|-|-|
| GET | /api/v1/communities/1 | - |


##### リクエストパラメーター サンプル：

`/api/v1/communities/99`

##### レスポンス

| 名前 | 必須 | 型 | 詳細 |
|-|-|-|-|
| community | | community | コミュニティ情報 |


#### 5.1.2. コミュニティ情報要約型：communitySummary

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | コミュニティID | - |
| name | ○ | String | コミュニティ名 | - |
| thumbnail_url|  | String | サムネイルパス | - |
| next_cyphers |  | CypherSummary[] | 次のサイファー | - |

#### コミュニティ一覧 取得URI

| メソッド | URI | 備考 |
|-|-|-|
| GET | /api/v1/my_communities | 参加コミュニティ |
| GET | /api/v1/following_communities | フォローコミュニティ |
| GET | /api/v1/host_communities | ホストしているコミュニティ |

##### リクエストパラメーター サンプル：

`/api/v1/my_communities?since_id=99`
`/api/v1/following_communities?since_id=99`
`/api/v1/hosting_communities?since_id=99`

##### レスポンス

並び順：イベント表示開始日時 降順

| 名前 | 必須 | 型 | 詳細 |
|-|-|-|-|
| communities[] | | communitySummary[] | コミュニティ情報リスト |
| total | ○ | Integer | 総件数 |

#### 5.1.3. サイファー情報詳細型：CypherDetail

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | サイファーID | - |
| name | ○ | String | サイファー名 | - |
|serial_num||Integer|連番||
| thumbnail_url|  | String | サムネイルパス | - |
| cypher_from | ○ | String | 開始日時 | - |
| cypher_to | ○ | String | 終了日時 | - |
| place | ○ | String | 開催地 | - |
| info | ○  | String | サイファー説明 | - |
| host | ○ | User | サイファー主催者 | - |
| capacity |  | Capacity | 定員 | 基本OFF |
| community | ○ | CommunitySummary | コミュニティ要約 | - |
|tags||tag[]|タグ|-|


##### サイファー詳細 取得URI

| メソッド | URI | 備考 |
|-|-|-|
| GET | /api/v1/cyphers | サイファー詳細 |


##### リクエストパラメーター サンプル：

`/api/v1/cyphers/99`

#### 5.1.4. サイファー情報要約型：CypherSummary

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | サイファーID | - |
| name | ○ | String | サイファー名 | - |
| serial_num||Integer|連番||
| thumbnail_url|  | String | サムネイルパス | - |
| cypher_from | ○ | String | 開始日時 | - |
| cypher_to | ○ | String | 終了日時 | - |
|place||String|||
| capacity |  | Capacity | 定員 | 基本OFF |
|thumbnail_url||String|サムネイルURL|コミュニティのサムネイル|

##### サイファー一覧 取得URI

| メソッド | URI | 備考 |
|-|-|-|
| GET | /api/v1/cyphers | 開催予定のすべてのサイファー |
| GET | /api/v1/participating_cyphers | 参加表明済みサイファー |
| GET | /api/v1/hosting_cyphers | 自分の開くサイファー |

##### リクエストパラメーター サンプル：

`/api/v1/cyphers?since_id=99&cypher_from=2017-07-12T17:00:00Z`
`/api/v1/participating_cyphers?since_id=99&cypher_from=2017-07-12T17:00:00Z`
`/api/v1/hosting_cyphers?since_id=99&cypher_from=2017-07-12T17:00:00Z`

##### レスポンス

並び順：サイファー開始日時 降順

| 名前 | 必須 | 型 | 詳細 |
|-|-|-|-|
| cyphers[] | | CypherSummary[] | サイファー情報リスト |
| total | ○ | Integer | 総件数 |

#### 5.1.5. ユーザー型：User

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | コミュニティID | - |
| name | ○ | String | ユーザー名 | - |
| home |  | String | 活動本拠地 | - |
| bio |  | String | bio | - |
| twitter_account |  | String | 連携twitterアカウント | - |
| facebook_account |  | String | 連携facebookアカウント | - |
| google_account |  | String | 連携googleアカウント | - |
| type | ○ | hash | ユーザーのタイプ | - |
|||mc_flag|boolean| mcならtrue |
|||dj_flag|boolena| djならtrue|
|||trackmaker_flag|boolean|trackmakerならtrue|
| participating_cyphers |  | cypher_summary[] | 参加予定サイファー | - |
| participating_communities |  | community_summary[] | 参加コミュニティ | - |
| thumbnail_url|  | String | サムネイルパス | 登録されていなければデフォの絵のパス |

##### ユーザー 取得URI

| メソッド | URI | 備考 |
|-|-|-|
| GET | /api/v1/users | - |


##### リクエストパラメーター サンプル：

`/api/v1/users/99`

##### レスポンス

並び順：イベント表示開始日時 降順

| 名前 | 必須 | 型 | 詳細 |
|-|-|-|-|
| user | | user | ユーザー |

### 5.2. 更新

#### 5.2.1. コミュニティ更新時入力情報：community_update
- JSON型式
- リクエストボディに入れる

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
|id|○|Integer|コミュニティid|-|
| name | ○ | String | コミュニティ名 | - |
| home | ○ | String | 活動本拠地 | - |
| bio | ○ | String | 活動内容 | - |
| thumbnail| ○ | String | サムネイルパス | - |
| twitter_account |  | String | twitterアカウント | あれば登録 |
| facebook_account |  | String | フェイスブッカケアカウント | あれば登録 |

##### URI

| メソッド | URI | 備考 |
|-|-|-|
| put | /api/v1/communities/コミュニティid| - |

##### レスポンス

| ステータス | 詳細 |
|-|-|
|200|成功|  
|400|失敗(パラメータ不正)|
|401|認証失敗|
|409|失敗(ホストじゃない)|

#### 5.2.2. サイファー更新時入力情報：cypher_update

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
|id|○|Integer|サイファーid|-|
| name | ○ | String | サイファー名 | - |
| info| ○| String | サイファー情報 | - |
| cypher_from | ○ | String | 開始日時 | - |
| cypher_to | ○ | String | 終了日時 | - |
| place | ○ | String | 開催地 | - |
| capacity |  | Capacity | 定員 | 基本OFF |

##### URI

| メソッド | URI | 備考 |
|-|-|-|
| PUT | /api/v1/cyphers/サイファーid | - |

##### レスポンス

| ステータス | 詳細 |
|-|-|
|200|成功|  
|400|失敗(パラメータ不正)|
|401|失敗(認証不正)|
|409|失敗(ホストじゃない)|

####  5.2.3. ユーザー更新時入力情報 user_update
| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| name | ○ | String | ユーザー名 | - |
| home | ○ | String | 活動本拠地 | - |
| bio | ○ | String | bio | - |
|mc_flag| ○ | Boolean|mcならtrue|-|
|dj_flag| ○ | Boolean|djならtrue|-|
|trackmaker_flag| ○ | Boolean|trackmakerならtrue|-|
|firebase_uid|○|String|firebaseのID|-|
| twitter_account |  | String | 連携twitterアカウント | - |
| facebook_account |  | String | 連携facebookアカウント | - |
| google_account |  | String | 連携googleアカウント | - |
| thumbnail|  | String | サムネイルパス | - |

##### URI

| メソッド | URI | 備考 |
|-|-|-|
| PUT | /api/v1/users/ | - |

##### レスポンス

| ステータス | 詳細 |
|-|-|
| 200 |  成功 |  
|400|失敗(パラメータ不正)|
|401|認証失敗|

### 5.3 削除

#### 5.3.1. コミュニティ削除時入力情報：community_delete

##### URI

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
| id | ○ | Integer | コミュニティid | - |

| メソッド | URI | 備考 |
|-|-|-|
| DELETE | /api/v1/communities/コミュニティid | - |

##### レスポンス

| ステータス | 詳細 |
|-|-|
|200|成功|
|400|失敗(パラメータ不正)|
|401|認証失敗|
|409|失敗(ホストじゃない)|

#### 5.3.3. サイファー削除時入力情報：cypher_delete

##### URI

| | 必須 | 型 | 詳細 | 備考 |
|-|-|-|-|-|
|id|○|Integer|サイファーid|-|

| メソッド | URI | 備考 |
|-|-|-|
| DELETE | /api/v1/cyphers/サイファーid | - |


##### レスポンス

| ステータス | 詳細 |
|-|-|
|200|成功|  
|400|失敗(パラメータ不正)|
|401|失敗(認証不正)|
|409|失敗(コミュニティホストじゃない)|

#### 5.4.1. ユーザー削除時入力情報：user_delete



##### URI
| メソッド | URI | 備考 |
|-|-|-|
| DELETE | /api/v1/users | - |

##### レスポンス
| ステータス | 詳細 |
|-|-|
| 200 |  成功 |  
|401|認証失敗|

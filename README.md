# NyARToolkitAS3
version 4.1.2

Copyright (C)2008-2012 Ryo Iizuka

http://nyatla.jp/nyartoolkit/  
airmail(at)ebony.plala.or.jp  
wm(at)nyatla.jp


## About NyARToolkit
* NyARToolkitは、NyARToolKit 4.1.1のAPIを基盤としたARアプリケーション向けのクラスライブラリです。
* Flash10以上(Stage3Dを使う場合は11以上)に対応しています。
* ARToolKitの基本機能と、NyARToolKitオリジナルの拡張機能、フレームワークで構成しています。
* ライブラリは4部構成です。NyARTookitを純粋に移植したsrcモジュール、NyARToolkitのRPF(Reality Platform)クラスのあるsrc.rpf,Flash向けの拡張クラスのあるsrc.flarif,サンプルのある、sampleです。
* このSDKが提供する3Dレンダラアダプタは、paperVision3Dのみです。他の3Dレンダラアダプタに対応するときの参考にして下さい。(FLARToolKitでは対応すると思います。)
* sampleモジュールは、いくつかの動作チェックプログラムと、RPFを使ったサンプルアプリケーションがあります。


ARToolKitについては、下記のURLをご覧ください。  
http://www.hitl.washington.edu/artoolkit/

## NyARToolkitAS3の特徴

NyARToolkitAS3の特徴を紹介します。
* 入力画像、内部画像のフォーマットが、BitmapData形式です。
* 次の項目について、高速な機能が利用できます。(ラべリング、姿勢最適化、画像処理、行列計算、方程式計算)
* NyId規格のIDマーカが使用できます。
* RPF(RealityPlatform - マーカ状態管理システム)が利用できます。
* MarkerSystemが使用できます。
* 簡易スケッチシステムがあります。MarkerSystemと組み合わせることで、以前と比較して、コンパクトな実装ができます。


## インストール

FlashDevelopでコンパイルできるプロジェクトが、sampleフォルダにあります。

FlashDevelopはこちらからダウンロードして下さい。
http://www.flashdevelop.org/wikidocs/index.php?title=Main_Page


## 外部ライブラリ

NyARToolkitAS3のサンプルを動作させるには、PaperVision3d、またはAway3Dが必要です。

* PaperVision3D  
http://blog.papervision3d.org/
* Away3D (Away3Dについては、3.4以前と、4.0以降向けの２種類があります。)  
http://away3d.com/


## サンプルの概要

サンプルプログラムの概要です。2つのFlashDevelopプロジェクトについて、説明します。

### Sample/nytest project  
NyARToolkitのテストプログラムです。
* Main.as
NyARToolkitのテストプログラムです。ベンチマークと、基本クラスのテストを実行して、結果を表示します。依存する外部ライブラリはありません。

### Sample/FLTest project
 FLARToolkitのテストプログラムです。
* Main.as
NyARToolkitのFlash拡張部分のテストと、ベンチマークプログラムです。テスト結果をコンソールに出力します。依存する外部ライブラリはありません。

### Sample/Pv3d  
paperVision3dを使ったサンプルプログラムです。sketchのサンプルのみとなります。
* IdMarker.as  
IDマーカを認識するプログラムです。ID0のマーカを使ってください。
* ImagePickup.as  
マーカ平面から画像を取得するプログラムです。Hiroマーカを使ってください。
* JpegInput.as  
カメラ画像の変わりにJpeg画像を入力するプログラムです。
* MarkerPlane.as  
マーカ平面とマウス座標の相互変換をするプログラムです。
* PngMarker.as  
マーカパターンにPNG画像を使うプログラムです。
* SimpleLite.as  
ARマーカに立方体を表示するプログラムです。Hiroマーカを使ってください。
* SimpleLiteM.as  
複数のARマーカに立方体を表示するプログラムです。HiroマーカとKanjiマーカを使ってください。

### Sample/Away3d  
Away3D version 3.4以前向けのサンプルです。スクリーン制御に難があるため、640x480以外のサイズではうまく動きません。
*Sample/Away3D4  
Away3D version 4.0.0 beta向けのデモです。
 

## ライセンス

NyARToolkitAS3は、商用ライセンスとLGPLv3のデュアルライセンスを採用しています。

LGPLv3を承諾された場合には、商用、非商用にかかわらず、無償でご利用になれます。 LGPLv3を承諾できない場合には、商用ライセンスの購入をご検討ください。

* LGPLv3  
LGPLv3については、COPYING.txtをお読みください。
* 商用ライセンス  
商用ライセンスについては、ARToolWorks社に管理を委託しております。http://www.artoolworks.com/Home.html

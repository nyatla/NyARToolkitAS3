/**
 * このサンプルプログラムは、Idマーカを認識するサンプルです。
 * 複数のマーカ、複数のパターンを同時に認識します。
 */
package 
{
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.*;
	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import flash.media.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.detector.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.support.pv3d.rpf.*;
	import jp.nyatla.nyartoolkit.as3.rpf.mklib.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import org.papervision3d.objects.*;
	
	public class NyIdView extends Sprite 
	{
		public static var inst:NyIdView;
        private var textbox:TextField = new TextField();
		private var param:FLARParam;
		private var code:NyARCode;
		public function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}
		public static function megs(i_str:String):void
		{
			inst.msg(i_str);
		}
		private var _reality:FLARRealityPv3d;
		private var _reality_src:FLARRealitySource_BitmapImage;
		public function NyIdView():void 
		{
			NyIdView.inst = this;
			//デバック用のテキストボックス
			this.textbox.x =0; this.textbox.y = 240;
			this.textbox.width=240,this.textbox.height=200; 
			this.textbox.condenseWhite = true;
			this.textbox.multiline =   true;
			this.textbox.border = true;
			this.textbox.visible = true;
            addChild(textbox);

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"../../../data/camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=new FLARParam();
            		param.loadARParam(data);
            		param.changeScreenSize(320,240);
				});
			mf.addTarget(
				"../../../data/patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=new NyARCode(16, 16);
					code.loadARPatt(data);
				}
			);
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event*/
		}
		private function _onEnterFrame(e:Event = null):void
		{
			this._reality_src.getBufferedImage().draw(this._video);
			//reality_srcと共有するので描画の必要なし。//this._reality.drawRealitySource(this._reality_src,this._controler._background);
			this._reality.progress(this._reality_src);
			//unknownターゲットを1個得る
			var t:NyARRealityTarget=this._reality.selectSingleUnknownTarget();
			if(t!=null){
				//ディスパッチ
				var r:RawbitSerialIdTable_IdentifyIdResult = new RawbitSerialIdTable_IdentifyIdResult();
				//ターゲットに一致するデータを検索
				
				if(this._marker_tbl.identifyId_2(t,this._reality_src,r)){
					//ここで既に認識しているターゲットを除外すれば、内側矩形の誤認識へ減るけど、マーカパターン変えた方が早いかも。
					if(this._reality.changeTargetToKnown(t,r.artk_direction,r.marker_width)){
						//遷移に成功したので、tagにBaseNodeを作っておく。（表示の時に使う。）
						t.tag = new DisplayObject3D();
						var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
						var plane:Plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
						plane.rotationX = 180;
						DisplayObject3D(t.tag).addChild(plane);
						// Place the light at upper front.
						// ライトの設定。手前、上のほう。
						var light:PointLight3D = new PointLight3D();
						light.x = 0;
						light.y = 1000;
						light.z = -1000;
	
						// Create Cube.
						var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x75104e); // Color is ping. / ピンク色。
						var cube:Cube = new Cube(new MaterialsList({all: fmat}), 40, 40, 40); // 40mm x 40mm x 40mm
						cube.z = 20; // Move the cube to upper (minus Z) direction Half height of the Cube. / 立方体の高さの半分、上方向(-Z方向)に移動させるとちょうどマーカーにのっかる形になる。
						DisplayObject3D(t.tag).addChild(cube);
					}
				}else{
					//一致しないので、このターゲットは捨てる。(15クロック無視)
					this._reality.changeTargetToDead_2(t,15);
				}
			}
			
			//RealityTargetの状態毎の処理
			var tl:NyARRealityTargetList = this._reality.refTargetList();
			var node_array:Vector.<DisplayObject3D> = new Vector.<DisplayObject3D>();
			for(var i:int=tl.getLength()-1;i>=0;i--){
				t=NyARRealityTarget(tl.getItem(i));
				switch(t.getTargetType())
				{
				case NyARRealityTarget.RT_DEAD:
					break;
				case NyARRealityTarget.RT_KNOWN:
					this._reality.loadTransformMat(t,DisplayObject3D(t.tag).transform);
					node_array.push(DisplayObject3D(t.tag));
					break;
				case NyARRealityTarget.RT_UNKNOWN:
					break;
				}
			}			
			//レンダリング？
			this._controler.render(node_array);
		}
		private var _controler:PV3dControler;
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		private static const WIDTH:int = 320;
		private static const HEIGHT:int = 240;
		private var _marker_tbl:RawbitSerialIdTable;

		private function main(e:Event):void
		{
			//Realityインスタンスの生成（最大数2）
			this._reality = new FLARRealityPv3d(param, false, 10, 1000, 2, 10);
			//Pv3dのコントローラ
			this._controler = new PV3dControler(this._reality.refCamera3d(), WIDTH, HEIGHT, this);
			//RealitySourceの生成(Pv3dコントローラのビットマップを借用)
			this._reality_src = new FLARRealitySource_BitmapImage( -1, -1, null, 2, 100, this._controler._background.bitmapData);
			//マーカデーブルの生成(登録数2,16x16,25%エッジ,解像度4)
			this._marker_tbl = new RawbitSerialIdTable(2);
			this._marker_tbl.addAnyItem("", 80);
			//カメラ
			this._webcam = Camera.getCamera();
			if (!this._webcam) {
				throw new Error('No webcam!!!!');
			}
			this._webcam.setMode(WIDTH,HEIGHT, 15);
			this._video = new Video( WIDTH,HEIGHT);
			this._video.attachCamera(_webcam);
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			msg("#ready");
			return;
		}
		
	}

}

import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
import org.libspark.flartoolkit.core.param.*;
import org.papervision3d.render.LazyRenderEngine;
import org.papervision3d.scenes.Scene3D;
import org.papervision3d.view.Viewport3D;
import org.papervision3d.objects.*;
import org.papervision3d.cameras.*;

import flash.display.*;

/**
 * Pv3dのレンダリングコントローラ
 */
class PV3dControler
{
	protected var _viewport:Viewport3D;
	protected var _camera3d:Camera3D;
	protected var _scene:Scene3D;
	protected var _renderer:LazyRenderEngine;
	
	public var _background:Bitmap;
	public function PV3dControler(i_camera3d:Camera3D,i_width:int,i_height:int,root_sprite:Sprite)
	{		
		this._background = new Bitmap(new BitmapData(i_width, i_height, false));
		this._background.x = 0;
		this._background.y = 0;
		this._background.width= i_width;
		this._background.height = i_height;
		root_sprite.addChild(this._background);
		this._viewport = new Viewport3D(i_width,i_height);
		this._viewport.scaleX = 1;
		this._viewport.scaleY = 1;
		this._viewport.x = -4; // 4pix ???
		root_sprite.addChild(this._viewport);
		
		this._camera3d = i_camera3d;
		this._scene = new Scene3D();
		this._renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);
	}
	/**
	 * DisplayNode配列と背景を、o_bitmapへ出力。
	 * @param	i_background
	 * @param	i_dispray_object
	 */
	public function render(i_dispray_object:Vector.<DisplayObject3D>):void
	{
		var i:int;
		for (i = 0; i < i_dispray_object.length;i++){
			this._scene.addChild(i_dispray_object[i]);
		}
		this._renderer.render();
		for (i = 0; i < i_dispray_object.length;i++){
			this._scene.removeChild(i_dispray_object[i]);
		}
	}
}
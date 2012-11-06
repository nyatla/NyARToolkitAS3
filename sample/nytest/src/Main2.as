package 
{

	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.NyARDoubleMatrix44;
	import jp.nyatla.nyartoolkit.as3.detector.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.realitysource.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.markersystem.*;
//	import jp.nyatla.nyartoolkit.as3.pro.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
//	import jp.nyatla.nyartoolkit.as3.pro.icp.*;
	/**
	 * ...
	 * @author 
	 */
	public class Main2 extends Sprite 
	{
		
		private static var inst:Main2;
        private var textbox:TextField = new TextField();
		private var param:NyARParam;
		private var code:NyARCode;
		private var raster_bgra:NyARRgbRaster;
		private var id_bgra:NyARRgbRaster;
		public function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}
		public static function megs(i_str:String):void
		{
			inst.msg(i_str);
		}

		public function Main2():void 
		{
			Main2.inst = this;
			//デバック用のテキストボックス
			this.textbox.x = 0; this.textbox.y = 0;
			this.textbox.width=640,this.textbox.height=480; 
			this.textbox.condenseWhite = true;
			this.textbox.multiline =   true;
			this.textbox.border = true;
            addChild(textbox);

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"../../../data/camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=NyARParam.createFromARParamFile(data);
            		param.changeScreenSize(320,240);
				});
			mf.addTarget(
				"../../../data/patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=NyARCode.createFromARPattFile(data,16, 16);
				}
			);
			mf.addTarget(
				"../../../data/320x240ABGR.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster = new NyARRgbRaster(320, 240, NyARBufferType.INT1D_X8R8G8B8_32);
					var b:Vector.<int> =	Vector.<int>(r.getBuffer());
					data.endian = Endian.LITTLE_ENDIAN;
					for (var i:int = 0; i < 320 * 240; i++) {
						b[i]=data.readInt();
					}
            		raster_bgra=r;
				});

			mf.addTarget(
				"../../../data/320x240NyId.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster = new NyARRgbRaster(320, 240, NyARBufferType.INT1D_X8R8G8B8_32);
					var b:Vector.<int> =	Vector.<int>(r.getBuffer());
					data.endian = Endian.LITTLE_ENDIAN;
					for (var i:int = 0; i < 320 * 240; i++) {
						b[i]=data.readInt();
					}
            		id_bgra=r;
				});				
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event*/
		}
		private function testNyARSingleDetectMarker():void
		{
			var mat:NyARDoubleMatrix44=new NyARDoubleMatrix44();
			var ang:NyARDoublePoint3d = new NyARDoublePoint3d();
			var d:NyARSingleDetectMarker=NyARSingleDetectMarker.createInstance(this.param, this.code, 80.0,NyARSingleDetectMarker.PF_NYARTOOLKIT);
			d.detectMarkerLite(raster_bgra,100);
			msg("cf=" + d.getConfidence());
			{
				d.getTransmationMatrix(mat);
				msg("getTransmationMatrix");
				msg(mat.m00 + "," + mat.m01 + "," + mat.m02 + "," + mat.m03);
				msg(mat.m10 + "," + mat.m11 + "," + mat.m12 + "," + mat.m13);
				msg(mat.m20 + "," + mat.m21 + "," + mat.m22 + "," + mat.m23);
				msg("getZXYAngle");
				mat.getZXYAngle(ang);
				msg(ang.x + "," + ang.y + "," + ang.z);
			}
			msg("#benchmark");
			{
				var date : Date = new Date();
				for(var i2:int=0;i2<100;i2++){
					d.detectMarkerLite(raster_bgra,100);
					d.getTransmationMatrix(mat);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");
			}
			return;
		}

		private function main(e:Event):void
		{
			var mat:NyARDoubleMatrix44=new NyARDoubleMatrix44();
			var ang:NyARDoublePoint3d = new NyARDoublePoint3d();
			msg("NyARToolkitAS3 check program.");
			msg("(c)2010 nyatla.");
			msg("#ready!");
			{
				msg("<NyARSingleDetectMarker>");
				testNyARSingleDetectMarker();
			}
			msg("#finish!");
			return;
		}
		
	}
	
}

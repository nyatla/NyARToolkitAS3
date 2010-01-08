package 
{

	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARDoublePoint3d;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;
	import jp.nyatla.nyartoolkit.as3.detector.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
        private var textbox:TextField = new TextField();
		private var param:NyARParam;
		private var code:NyARCode;
		private var raster_bgra:NyARRgbRaster;
		private function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}

		public function Main():void 
		{
			//デバック用のテキストボックス
			this.textbox.x = 100; this.textbox.y = 100;
			this.textbox.width=400,this.textbox.height=200; 
			this.textbox.condenseWhite = true;
			this.textbox.multiline =   true;
            addChild(textbox);

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"../../../data/camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=new NyARParam();
            		param.loadARParam(data);
            		param.changeScreenSize(320,240);
				});
			mf.addTarget(
				"../../../data/patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=new NyARCode(16, 16);
					code.loadARPattFromFile(data);
				}
			);
			mf.addTarget(
				"../../../data/320x240ABGR.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster = new NyARRgbRaster(new NyARIntSize(320, 240), INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32);
					var b:Vector.<int> =	Vector.<int>(r.getBufferReader().getBuffer());
					data.endian = Endian.LITTLE_ENDIAN;
					for (var i:int = 0; i < 320 * 240; i++) {
						b[i]=data.readInt();
					}
         
            		raster_bgra=r;
				});
/*				
			mf.addTarget(
				"320x240NyId.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:FLARRgbRaster_BitmapData=new FLARRgbRaster_BitmapData(320,240);
            		r.setFromByteArray(data);
            		id_bgra=r;
				});				
 */           //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event*/
		}
		
		private function main(e:Event):void
		{
			var mat:NyARTransMatResult=new NyARTransMatResult();
			msg("#ready!");
			var d:NyARSingleDetectMarker=new NyARSingleDetectMarker(this.param, this.code, 80.0, INyARBufferReader.BUFFERFORMAT_INT1D_X8R8G8B8_32);
			d.detectMarkerLite(raster_bgra,100);
			msg("cf=" + d.getConfidence());
			{
				d.getTransmationMatrix(mat);
				msg("getTransmationMatrix");
				msg(mat.m00 + "," + mat.m01 + "," + mat.m02 + "," + mat.m03);
				msg(mat.m10 + "," + mat.m11 + "," + mat.m12 + "," + mat.m13);
				msg(mat.m20 + "," + mat.m21 + "," + mat.m22 + "," + mat.m23);
				var ang:NyARDoublePoint3d = new NyARDoublePoint3d();
				msg("getZXYAngle");
				mat.getZXYAngle(ang);
				msg(ang.x + "," + ang.y + "," + ang.z);
			}
			msg("#benchmark");
			{
				var date : Date = new Date();
				for(var i2:int=0;i2<1000;i2++){
//					d.detectMarkerLite(raster_bgra,100);
					d.getTransmationMatrix(mat);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 1000 frame");
			}
			return;
		}
		
	}
	
}


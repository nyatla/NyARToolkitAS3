package sketch 
{
	import flash.geom.Rectangle;
	import jp.nyatla.as3utils.sketch.*;
	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.detector.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;	
	/**
	 * ...
	 * @author nyatla
	 */
	public class test extends DebugSketch
	{
		public override function setup():void
		{
			//コンテンツのセットアップ
			this.setupFile("../../../data/camera_para.dat", URLLoaderDataFormat.BINARY);//0
			this.setupFile("../../../data/patt.hiro", URLLoaderDataFormat.TEXT);//1
			this.setupFile("../../../data/320x240ABGR.raw", URLLoaderDataFormat.BINARY);//2
			this.setupFile("../../../data/320x240NyId.raw", URLLoaderDataFormat.BINARY);//3
		}
		public override function main():void
		{
			param=new FLARParam(this.getFile(0),320,240);
			code=new FLARCode(16, 16);
			code.loadARPatt(this.getFile(1));
			
			var b:BitmapData;
			var data:ByteArray;
			var i:int;
			{	
				b=	arimg.getBitmapData();
				data = this.getFile(2);
				data.endian = Endian.LITTLE_ENDIAN;
				for (i = 0; i < 320 * 240; i++) {
					b.setPixel(i % 320, i / 320, data.readInt());
				}
			}
			{
				b =	idimg.getBitmapData();
				data = this.getFile(3);
				data.endian = Endian.LITTLE_ENDIAN;
				for (i = 0; i < 320 * 240; i++) {
					b.setPixel(i%320,i/320,data.readInt());
				}
			}
			testNyARSingleDetectMarker();
			
			
		}
		private	var param:FLARParam;
		private	var code:FLARCode;
		private	var arimg:FLARRgbRaster_BitmapData = new FLARRgbRaster_BitmapData(320,240,true);
		private	var idimg:FLARRgbRaster_BitmapData = new FLARRgbRaster_BitmapData(320,240,true);
		
		private function testNyARSingleDetectMarker():void
		{
			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			var d:FLARSingleMarkerDetector=new FLARSingleMarkerDetector(this.param, this.code, 80.0);
			d.detectMarkerLite(arimg,100);
			msg("cf=" + d.getConfidence());
			{
				d.getTransformMatrix(mat);
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
					d.detectMarkerLite(arimg,100);
					d.getTransformMatrix(mat);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");
			}
			return;
		}		
	}

}
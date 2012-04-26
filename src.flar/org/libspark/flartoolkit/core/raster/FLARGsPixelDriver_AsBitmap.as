package org.libspark.flartoolkit.core.raster 
{
	import flash.display.BitmapData;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	public class FLARGsPixelDriver_AsBitmap implements INyARGsPixelDriver
	{
		protected var _ref_buf:BitmapData;
		private var _ref_size:NyARIntSize;
		public function getSize():NyARIntSize
		{
			return this._ref_size;
		}
		public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_n:int,o_buf:Vector.<int>,i_st_buf:int):void
		{
			for (var i:int = i_n - 1; i >= 0; i--) {
				o_buf[i_st_buf+i] = _ref_buf.getPixel(i_x[i],i_y[i]);
			}
			return;	
		}
		public function getPixel(i_x:int,i_y:int):int
		{
			return _ref_buf.getPixel(i_x,i_y)& 0x000000ff;;
		}
		public function setPixel(i_x:int,i_y:int,i_gs:int):void
		{
			this._ref_buf.setPixel(i_x, i_y, i_gs);
		}
		public function setPixels(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,i_intgs:Vector.<int>):void
		{
			for (var i:int = i_num - 1; i >= 0; i--){
				this._ref_buf.setPixel(i_x[i], i_y[i], i_intgs[i]);
			}
		}	
		public function switchRaster(i_ref_raster:INyARRaster):void
		{
			this._ref_buf=BitmapData(i_ref_raster.getBuffer());
			this._ref_size=i_ref_raster.getSize();
		}
		public function isCompatibleRaster(i_raster:INyARRaster):Boolean
		{
			return i_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData);
		}	
	}	
	
	

}
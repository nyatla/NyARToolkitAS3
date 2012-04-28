package org.libspark.flartoolkit.core.rasterfilter 
{
	import flash.geom.*;
	import flash.display.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterfilter.*;
	import jp.nyatla.as3utils.*;
	import flash.filters.*;	
	
	public class FLARGs2BinFilter
	{
		private var _dest:Point = new Point(0,0);
		private var _src:Rectangle = new Rectangle();
		private var _ref_raster:FLARGrayscaleRaster;
		public function FLARGs2BinFilter(i_ref_raster:FLARGrayscaleRaster)
		{
			NyAS3Utils.assert(i_ref_raster.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
			this._ref_raster = i_ref_raster;
		}		
		/**
		 * GS画像からGrayscale画像とBin画像を同時に生成します。
		 * @param	l
		 * @param	t
		 * @param	w
		 * @param	h
		 * @param	i_gs
		 * @param	i_bin
		 */
		public function convertRect(l:int, t:int, w:int, h:int, i_th:int,i_bin:FLARBinRaster):void
		{			
			this._src.left  =l;
			this._src.top   =t;
			this._src.width =w;
			this._src.height = h;
			this._dest.x = l;
			this._dest.y = t;
			var gsbmp:BitmapData = this._ref_raster.getBitmapData();
			var binbmp:BitmapData = i_bin.getBitmapData();
			binbmp.fillRect(binbmp.rect, 0x0);
			binbmp.threshold(gsbmp,this._src,this._dest, '<=', i_th, 0xff0000ff, 0xff);			
		}
		/**
		 * 同一サイズの画像にグレースケール画像を生成します。
		 * @param i_raster
		 * @throws NyARException
		 */
		public function convert(i_th:int,i_bin:FLARBinRaster):void
		{
			var s:NyARIntSize = this._ref_raster.getSize();
			this.convertRect(0, 0, s.w, s.h, i_th, i_bin);			
		}
	}


}
package org.libspark.flartoolkit.core.rasterfilter.rgb2gs 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.ColorMatrixFilter;
	import jp.nyatla.as3utils.*;
	/**
	 * ...
	 * @author 
	 */
	public class FLARRasterFilter_Rgb2Gs_RgbAve192
	{
		private static const ZERO_POINT:Point = new Point(0,0);
		private static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0, 0, 0, 0,0,
			0,0,0,0,0,
			0.25, 0.25, 0.25,0,0,
			0, 0, 0,0,0
		]);
		private var _tmp:BitmapData;	
		
		public function doFilter(i_input:INyARRaster,i_output:INyARRaster):void
		{
			NyAS3Utils.assert (i_input.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
			NyAS3Utils.assert (i_output.isEqualBufferType(NyARBufferType.OBJECT_AS3_BitmapData));
			
			var out_buf:BitmapData = BitmapData(i_output.getBuffer());
			var in_buf:BitmapData= BitmapData(i_input.getBuffer());
			out_buf.applyFilter(in_buf, in_buf.rect, ZERO_POINT, MONO_FILTER);
		}
	}

}
package jp.nyatla.nyartoolkit.as3.core.rasterdriver 
{
	import jp.nyatla.nyartoolkit.core.types.*;
	
/**
 * ヒストグラムを生成するインタフェイスです。
 * @author nyatla
 *
 */
	public interface INyARHistogramFromRaster
	{
		//GSRaster
		function createHistogram(i_l:int,i_t:int,i_w:int,i_h:int,i_skip:int,o_histogram:NyARHistogram):void;
		function createHistogram(i_skip:int,o_histogram:NyARHistogram):void;
	}


}
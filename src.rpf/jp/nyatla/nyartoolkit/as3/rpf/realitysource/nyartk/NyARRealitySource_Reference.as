package jp.nyatla.nyartoolkit.as3.rpf.realitysource.nyartk 
{
	import jp.nyatla.nyartoolkit.as3.rpf.realitysource.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	/**
	 * RGBラスタをラップしたRealitySourceです。
	 * @author nyatla
	 *
	 */
	public class NyARRealitySource_Reference extends NyARRealitySource
	{
		protected var _filter:NyARRasterFilter_Rgb2Gs_RgbAve;
		/**
		 * 
		 * @param i_width
		 * ラスタのサイズを指定します。
		 * @param i_height
		 * ラスタのサイズを指定します。
		 * @param i_ref_raster_distortion
		 * 歪み矯正の為のオブジェクトを指定します。歪み矯正が必要ない時は、NULLを指定します。
		 * @param i_depth
		 * エッジ画像のサイズを1/(2^n)で指定します。(例:QVGA画像で1を指定すると、エッジ検出画像は160x120になります。)
		 * 数値が大きいほど高速になり、検出精度は低下します。実用的なのは、1<=n<=3の範囲です。標準値は2です。
		 * @param i_number_of_sample
		 * サンプリングするターゲット数を指定します。大体100以上をしておけばOKです。具体的な計算式は、{@link NyARTrackerSource_Reference#NyARTrackerSource_Reference}を参考にして下さい。
		 * @param i_raster_type
		 * ラスタタイプ
		 * @throws NyARException
		 */
		public function NyARRealitySource_Reference(i_width:int, i_height:int , i_ref_raster_distortion:NyARCameraDistortionFactor , i_depth:int , i_number_of_sample:int , i_raster_type:int )
		{
			this._rgb_source=new NyARRgbRaster(i_width,i_height,i_raster_type);
			this._filter=new NyARRasterFilter_Rgb2Gs_RgbAve(this._rgb_source.getBufferType());
			this._source_perspective_reader=new NyARPerspectiveRasterReader(_rgb_source.getBufferType());
			this._tracksource=new NyARTrackerSource_Reference(i_number_of_sample,i_ref_raster_distortion,i_width,i_height,i_depth,true);
			return;
		}
		public override function isReady():Boolean
		{
			return this._rgb_source.hasBuffer();
		}
		public override function syncResource():void
		{
			this._filter.doFilter_1(this._rgb_source,this._tracksource.refBaseRaster());
			super.syncResource();
		}
		public override function makeTrackSource():NyARTrackerSource
		{
			this._filter.doFilter_1(this._rgb_source,this._tracksource.refBaseRaster());		
			return this._tracksource;
		}

	}

}
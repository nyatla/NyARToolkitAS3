package jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2bin
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;


	/**
	 * 定数閾値による2値化をする。
	 * 
	 */
	public class NyARRasterFilter_ARToolkitThreshold implements INyARRasterFilter_Rgb2Bin
	{
		private var _threshold:int;
		private var _do_threshold_impl:IdoThFilterImpl;

		public function NyARRasterFilter_ARToolkitThreshold(i_threshold:int, i_input_raster_type:int)
		{
			this._threshold = i_threshold;
			switch (i_input_raster_type) {
			case NyARBufferType.INT1D_X8R8G8B8_32:
				this._do_threshold_impl=new doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32();
				break;
			default:
				throw new NyARException();
			}

			
		}
		/**
		 * 画像を２値化するための閾値。暗点<=th<明点となります。
		 * @param i_threshold
		 */
		public function setThreshold(i_threshold:int ):void 
		{
			this._threshold = i_threshold;
		}
		public function doFilter_1(i_input:INyARRgbRaster,i_output:NyARBinRaster):void
		{
			//assert (i_input.getSize().isEqualSize(i_output.getSize()) == true);
			var s:NyARIntSize=i_input.getSize();
			this._do_threshold_impl.doThFilter(i_input,0,0,s.w,s.h,this._threshold,i_output);
			return;
		}
		public function doFilter_2(i_input:INyARRgbRaster,i_area:NyARIntRect,i_output:NyARBinRaster):void
		{
			//assert (i_input.getSize().isEqualSize(i_output.getSize()) == true);
			this._do_threshold_impl.doThFilter(i_input,i_area.x,i_area.y,i_area.w,i_area.h,this._threshold,i_output);
			return;
			
		}		
	}
}
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterfilter.*;
import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.as3utils.*;
/*
 * ここから各ラスタ用のフィルタ実装
 */
interface IdoThFilterImpl
{
	function doThFilter(i_raster:INyARRaster,i_l:int, i_t:int,i_w:int,i_h:int,i_th:int,o_raster:INyARRaster):void;
}

class doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32 implements IdoThFilterImpl
{
	public function doThFilter(i_raster:INyARRaster,i_l:int,i_t:int,i_w:int,i_h:int,i_th:int,o_raster:INyARRaster):void
	{
		//		assert (i_raster.isEqualBufferType( NyARBufferType.INT1D_X8R8G8B8_32));
		var input:Vector.<int>=(Vector.<int>)(i_raster.getBuffer());
		var output:Vector.<int>=(Vector.<int>)(o_raster.getBuffer());
		var th:int=i_th*3;

		var s:NyARIntSize=i_raster.getSize();
		var skip_src:int=(s.w-i_w);
		var skip_dst:int=skip_src;
		var pix_count:int=i_w;
		var pix_mod_part:int=pix_count-(pix_count%8);			
		//左上から1行づつ走査していく
		var pt_dst:int=(i_t*s.w+i_l);
		var pt_src:int=pt_dst;
		for (var y:int = i_h-1; y >=0 ; y-=1){
			var x:int,v:int;
			for (x = pix_count-1; x >=pix_mod_part; x--){
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
			}
			for (;x>=0;x-=8){
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))<=th?0:1;
			}
			//スキップ
			pt_src+=skip_src;
			pt_dst+=skip_dst;				
		}	
		return;			
	}	
}

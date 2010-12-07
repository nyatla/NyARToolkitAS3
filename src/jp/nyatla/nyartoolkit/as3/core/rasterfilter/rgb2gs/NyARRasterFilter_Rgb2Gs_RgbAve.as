package jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs 
{
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;	
	/**
	 * RGBラスタをGrayScaleに変換するフィルタを作成します。
	 * このフィルタは、RGB値の平均値を、(R+G+B)/3で算出します。
	 *
	 */
	public class NyARRasterFilter_Rgb2Gs_RgbAve implements INyARRasterFilter_Rgb2Gs
	{
		private var _do_filter_impl:IdoThFilterImpl;
		public function NyARRasterFilter_Rgb2Gs_RgbAve(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}else if(args[0] is int){
					NyARRasterFilter_Rgb2Gs_RgbAve_b(int(args[0]));
				}
				break;
			case 2:
				if((args[0] is int) && (args[1] is int)){
					NyARRasterFilter_Rgb2Gs_RgbAve_a(int(args[0]),int(args[1]))
				}
				break;
			default:
				throw new NyARException();
			}			
		}
		public function NyARRasterFilter_Rgb2Gs_RgbAve_a(i_in_raster_type:int,i_out_raster_type:int):void
		{
			if(!initInstance(i_in_raster_type,i_out_raster_type))
			{
				throw new NyARException();
			}
		}
		public function NyARRasterFilter_Rgb2Gs_RgbAve_b(i_in_raster_type:int):void
		{
			if(!initInstance(i_in_raster_type,NyARBufferType.INT1D_GRAY_8))
			{
				throw new NyARException();
			}
		}
		protected function initInstance(i_in_raster_type:int,i_out_raster_type:int):Boolean
		{
			switch(i_out_raster_type){
			case NyARBufferType.INT1D_GRAY_8:
				switch (i_in_raster_type){
				case NyARBufferType.INT1D_X8R8G8B8_32:
					this._do_filter_impl=new doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32();
					break;
				default:
					return false;
				}
				break;
			default:
				return false;
			}
			return true;
		}
		public function doFilter_1(i_input:INyARRgbRaster,i_output:NyARGrayscaleRaster):void
		{
			//assert (i_input.getSize().isEqualSize(i_output.getSize()) == true);
			var s:NyARIntSize=i_input.getSize();
			this._do_filter_impl.doFilter(i_input,(Vector.<int>)(i_output.getBuffer()),0,0,s.w,s.h);
			return;
		}
		/**
		 * 同一サイズのラスタi_inputとi_outputの間で、一部の領域だけにラスタ処理を実行します。
		 * @param i_input
		 * @param i_rect
		 * @param i_output
		 * @throws NyARException
		 */
		public function doFilter_2(i_input:INyARRgbRaster,i_rect:NyARIntRect,i_output: NyARGrayscaleRaster ):void
		{
			//assert (i_input.getSize().isEqualSize(i_output.getSize()) == true);
			this._do_filter_impl.doFilter(i_input,(Vector.<int>)(i_output.getBuffer()),i_rect.x,i_rect.y,i_rect.w,i_rect.h);
			
		}
		/**
		 * 異サイズのラスタi_inputとi_outputの間で、一部の領域をi_outputへ転送します。
		 * 関数は、i_outputのサイズをi_skip倍した領域を、i_inputのi_left,i_topの位置から切り出し、フィルタ処理をしてi_outputへ格納します。
		 * @param i_input
		 * @param i_left
		 * @param i_top
		 * @param i_skip
		 * @param i_output
		 */
		public function doCutFilter(i_input:INyARRgbRaster,i_left:int,i_top:int,i_skip:int,i_output:NyARGrayscaleRaster):void
		{
			this._do_filter_impl.doCutFilter(i_input,i_left,i_top,i_skip,i_output);		
		}
	}
}
import flash.utils.ByteArray;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;

/*
 * ここから各種ラスタ向けのフィルタ実装
 *
 */
interface IdoThFilterImpl
{
	/**
	 * 同一サイズのラスタ間での転送
	 * @param i_input
	 * @param o_output
	 * @param l
	 * @param t
	 * @param w
	 * @param h
	 */
	function doFilter(i_input:INyARRaster, o_output:Vector.<int>, l:int, t:int, w:int, h:int):void;
	/**
	 * 異サイズラスタ間での転送
	 * @param i_input
	 * @param l
	 * @param t
	 * @param i_st
	 * @param o_output
	 */
	function doCutFilter(i_input:INyARRaster,l:int,t:int,i_st:int,o_output:NyARGrayscaleRaster):void;
}

class doThFilterImpl_BUFFERFORMAT_INT1D_X8R8G8B8_32 implements IdoThFilterImpl
{
	public function doCutFilter(i_input:INyARRaster,l:int,t:int,i_st:int,o_output:NyARGrayscaleRaster):void
	{
		//assert(i_input.isEqualBufferType(NyARBufferType.INT1D_X8R8G8B8_32));
		//assert(i_input.getSize().isInnerSize(l+o_output.getWidth()*i_st,t+o_output.getHeight()*i_st));
		var input:Vector.<int>=(Vector.<int>)(i_input.getBuffer());
		var output:Vector.<int>=(Vector.<int>)(o_output.getBuffer());
		var v:int;
		var pt_src:int,pt_dst:int;
		var dest_size:NyARIntSize=o_output.getSize();
		var src_size:NyARIntSize=i_input.getSize();
		var skip_src_y:int=(src_size.w-dest_size.w*i_st)+src_size.w*(i_st-1);
		var skip_src_x:int=i_st;
		var pix_count:int=dest_size.w;
		var pix_mod_part:int=pix_count-(pix_count%8);			
		//左上から1行づつ走査していく
		pt_dst=0;
		pt_src=(t*src_size.w+l);
		for (var y:int = dest_size.h-1; y >=0; y-=1){
			var x:int;
			for (x = pix_count-1; x >=pix_mod_part; x--){
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
			}
			for (;x>=0;x-=8){
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
				v=input[pt_src++];output[pt_dst++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				pt_src+=skip_src_x;
			}
			//スキップ
			pt_src+=skip_src_y;
		}
		return;		
	}
	public function doFilter(i_input:INyARRaster,o_output:Vector.<int>,l:int,t:int,w:int,h:int):void
	{
		//assert(i_input.isEqualBufferType(NyARBufferType.INT1D_X8R8G8B8_32));
		var size:NyARIntSize=i_input.getSize();
		var in_buf:Vector.<int> = (Vector.<int>)( i_input.getBuffer());
		var bp:int = (l+t*size.w);
		var v:int;
		var b:int=t+h;
		var row_padding_dst:int=(size.w-w);
		var row_padding_src:int=row_padding_dst;
		var pix_count:int=w;
		var pix_mod_part:int=pix_count-(pix_count%8);
		var src_ptr:int= t * size.w + l;
		for (var y:int = t; y < b; y++) {
			var x:int=0;
			for (x = pix_count-1; x >=pix_mod_part; x--){
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
			}
			for (;x>=0;x-=8){
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
				v=in_buf[src_ptr++];o_output[bp++]=(((v>>16)& 0xff)+((v>>8)& 0xff)+(v &0xff))>>2;
			}
			bp+=row_padding_dst;
			src_ptr+=row_padding_src;
		}
		return;			
	}
}

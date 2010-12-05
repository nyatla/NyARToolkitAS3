package jp.nyatla.nyartoolkit.as3.core.rasterreader 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	/**
	 * ...
	 * @author 
	 */
	public class NyARPerspectiveRasterReader 
	{
		protected var _perspective_gen:NyARPerspectiveParamGenerator ; 
		private static const LOCAL_LT:int = 1 ; 
		protected var __pickFromRaster_cpara:Vector.<Number> = new Vector.<Number>(8); 
		private var _picker:IPickupRasterImpl ; 
		private function initializeInstance( i_buffer_type:int ):void
		{ 
			switch( i_buffer_type ){
			default:
				this._picker = new PPickup_Impl_AnyRaster() ;
				break ;
			}
			this._perspective_gen = new NyARPerspectiveParamGenerator_O1( LOCAL_LT , LOCAL_LT ) ;
			return  ;
		}
		public function NyARPerspectiveRasterReader(...args:Array)
		{
			switch(args.length) {
			case 0://public function NyARPerspectiveRasterReader()
				initializeInstance(NyARBufferType.NULL_ALLZERO);
				return;
			case 1://public function NyARPerspectiveRasterReader( i_input_raster_type:int )
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}else if (args[0] is int)
				{
					this.initializeInstance(int(args[0])) ;
				}
				return;
			default:
				break;
			}
			throw new NyARException();
		}
		public function read4Point_1( i_in_raster:INyARRgbRaster , i_vertex:Vector.<NyARDoublePoint2d> , i_edge_x:int , i_edge_y:int , i_resolution:int , o_out:INyARRgbRaster ):Boolean
		{
			var out_size:NyARIntSize = o_out.getSize() ;
			var xe:int = out_size.w * i_edge_x / 50 ;
			var ye:int = out_size.h * i_edge_y / 50 ;
			if( i_resolution == 1 ) {
				if( !this._perspective_gen.getParam_3((xe * 2 + out_size.w), (ye * 2 + out_size.h), i_vertex, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.onePixel(xe + LOCAL_LT , ye + LOCAL_LT , this.__pickFromRaster_cpara , i_in_raster , o_out) ;
			}
			else {
				if( !this._perspective_gen.getParam_3((xe * 2 + out_size.w) * i_resolution, (ye * 2 + out_size.h) * i_resolution, i_vertex, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.multiPixel(xe * i_resolution + LOCAL_LT , ye * i_resolution + LOCAL_LT , this.__pickFromRaster_cpara , i_resolution , i_in_raster , o_out) ;
			}
			return true ;
		}
		
		public function read4Point_2( i_in_raster:INyARRgbRaster , i_vertex:Vector.<NyARIntPoint2d>, i_edge_x:int , i_edge_y:int , i_resolution:int , o_out:INyARRgbRaster ):Boolean
		{
			var out_size:NyARIntSize = o_out.getSize() ;
			var xe:int = out_size.w * i_edge_x / 50 ;
			var ye:int = out_size.h * i_edge_y / 50 ;
			if( i_resolution == 1 ) {
				if( !this._perspective_gen.getParam_4((xe * 2 + out_size.w), (ye * 2 + out_size.h), i_vertex, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.onePixel(xe + LOCAL_LT , ye + LOCAL_LT , this.__pickFromRaster_cpara , i_in_raster , o_out) ;
			}
			else {
				if( !this._perspective_gen.getParam_4((xe * 2 + out_size.w) * i_resolution, (ye * 2 + out_size.h) * i_resolution, i_vertex, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.multiPixel(xe * i_resolution + LOCAL_LT , ye * i_resolution + LOCAL_LT , this.__pickFromRaster_cpara , i_resolution , i_in_raster , o_out) ;
			}
			return true ;
		}
		
		public function read4Point_3( i_in_raster:INyARRgbRaster , i_x1:Number , i_y1:Number , i_x2:Number , i_y2:Number , i_x3:Number , i_y3:Number , i_x4:Number , i_y4:Number , i_edge_x:int , i_edge_y:int , i_resolution:int , o_out:INyARRgbRaster ):Boolean
		{ 
			var out_size:NyARIntSize = o_out.getSize() ;
			var xe:int = out_size.w * i_edge_x / 50 ;
			var ye:int = out_size.h * i_edge_y / 50 ;
			if( i_resolution == 1 ) {
				if( !this._perspective_gen.getParam_5((xe * 2 + out_size.w), (ye * 2 + out_size.h), i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.onePixel(xe + LOCAL_LT , ye + LOCAL_LT , this.__pickFromRaster_cpara , i_in_raster , o_out) ;
			}
			else {
				if( !this._perspective_gen.getParam_5((xe * 2 + out_size.w) * i_resolution, (ye * 2 + out_size.h) * i_resolution, i_x1, i_y1, i_x2, i_y2, i_x3, i_y3, i_x4, i_y4, this.__pickFromRaster_cpara) ) {
					return false ;
				}
				
				this._picker.multiPixel(xe * i_resolution + LOCAL_LT , ye * i_resolution + LOCAL_LT , this.__pickFromRaster_cpara , i_resolution , i_in_raster , o_out) ;
			}
			return true ;
		}
		
	}
}
//
//ここから先は入力画像毎のラスタドライバ
//
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;

interface IPickupRasterImpl
{
	function onePixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,i_in_raster:INyARRgbRaster,o_out:INyARRgbRaster):void;
	function multiPixel(pk_l:int,pk_t:int,cpara:Vector.<Number>,i_resolution:int,i_in_raster:INyARRgbRaster,o_out:INyARRgbRaster):void;
}


class PPickup_Impl_AnyRaster implements IPickupRasterImpl 
{
	private var __pickFromRaster_rgb_tmp:Vector.<int> = new Vector.<int>(3) ; 
	public function onePixel( pk_l:int , pk_t:int , cpara:Vector.<Number> , i_in_raster:INyARRgbRaster , o_out:INyARRgbRaster ):void
	{
		switch( o_out.getBufferType() ){
		case NyARBufferType.INT1D_X8R8G8B8_32:
			onePixel_INT1D_X8R8G8B8_32(pk_l , pk_t , i_in_raster.getWidth() , i_in_raster.getHeight() , cpara , i_in_raster.getRgbPixelReader() , o_out) ;
			break ;
		default:
			onePixel_ANY(pk_l , pk_t , i_in_raster.getWidth() , i_in_raster.getHeight() , cpara , i_in_raster.getRgbPixelReader() , o_out) ;
			break ;
		}
		return  ;
	}
	
	public function multiPixel( pk_l:int , pk_t:int , cpara:Vector.<Number> , i_resolution:int , i_in_raster:INyARRgbRaster , o_out:INyARRgbRaster ):void
	{
		switch( o_out.getBufferType() ){
		case NyARBufferType.INT1D_X8R8G8B8_32:
			multiPixel_INT1D_X8R8G8B8_32(pk_l , pk_t , i_in_raster.getWidth() , i_in_raster.getHeight() , i_resolution , cpara , i_in_raster.getRgbPixelReader() , o_out) ;
			break ;
		default:
			multiPixel_ANY(pk_l , pk_t , i_in_raster.getWidth() , i_in_raster.getHeight() , i_resolution , cpara , i_in_raster.getRgbPixelReader() , o_out) ;
			break ;
		}
		return  ;
	}
	
	private function onePixel_INT1D_X8R8G8B8_32( pk_l:int , pk_t:int , in_w:int , in_h:int , cpara:Vector.<Number> , i_in_reader:INyARRgbPixelReader , o_out:INyARRgbRaster ):void
	{
		//assert( ! (( o_out.isEqualBufferType(NyARBufferType.INT1D_X8R8G8B8_32) ) ) );
		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp ;
		var pat_data:Vector.<int> = ((o_out.getBuffer()) as Vector.<int>) ;
		var cp0:Number = cpara[0] ;
		var cp3:Number = cpara[3] ;
		var cp6:Number = cpara[6] ;
		var cp1:Number = cpara[1] ;
		var cp4:Number = cpara[4] ;
		var cp7:Number = cpara[7] ;
		var out_w:int = o_out.getWidth() ;
		var out_h:int = o_out.getHeight() ;
		var cp7_cy_1:Number = cp7 * pk_t + 1.0 + cp6 * pk_l ;
		var cp1_cy_cp2:Number = cp1 * pk_t + cpara[2] + cp0 * pk_l ;
		var cp4_cy_cp5:Number = cp4 * pk_t + cpara[5] + cp3 * pk_l ;
		var p:int = 0 ;
		for( var iy:int = out_h - 1 ; iy >= 0 ; iy-- ) {
			var cp7_cy_1_cp6_cx:Number = cp7_cy_1 ;
			var cp1_cy_cp2_cp0_cx:Number = cp1_cy_cp2 ;
			var cp4_cy_cp5_cp3_cx:Number = cp4_cy_cp5 ;
			for( var ix:int = out_w - 1 ; ix >= 0 ; ix-- ) {
				/* final */ var d:Number = 1 / ( cp7_cy_1_cp6_cx ) ;
				var x:int = int(( ( cp1_cy_cp2_cp0_cx ) * d )) ;
				var y:int = int(( ( cp4_cy_cp5_cp3_cx ) * d )) ;
				if( x < 0 ) {
					x = 0 ;
				}
				else if( x >= in_w ) {
					x = in_w - 1 ;
				}
				
				if( y < 0 ) {
					y = 0 ;
				}
				else if( y >= in_h ) {
					y = in_h - 1 ;
				}
				
				i_in_reader.getPixel(x , y , rgb_tmp) ;
				cp7_cy_1_cp6_cx += cp6 ;
				cp1_cy_cp2_cp0_cx += cp0 ;
				cp4_cy_cp5_cp3_cx += cp3 ;
				pat_data[p] = ( rgb_tmp[0] << 16 ) | ( rgb_tmp[1] << 8 ) | ( ( rgb_tmp[2] & 0xff ) ) ;
				p++ ;
			}
			cp7_cy_1 += cp7 ;
			cp1_cy_cp2 += cp1 ;
			cp4_cy_cp5 += cp4 ;
		}
		return  ;
	}
	
	private function onePixel_ANY( pk_l:int , pk_t:int , in_w:int , in_h:int , cpara:Vector.<Number> , i_in_reader:INyARRgbPixelReader , o_out:INyARRgbRaster ):void
	{
		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp ;
		var out_reader:INyARRgbPixelReader = o_out.getRgbPixelReader() ;
		var cp0:Number = cpara[0] ;
		var cp3:Number = cpara[3] ;
		var cp6:Number = cpara[6] ;
		var cp1:Number = cpara[1] ;
		var cp4:Number = cpara[4] ;
		var cp7:Number = cpara[7] ;
		var out_w:int = o_out.getWidth() ;
		var out_h:int = o_out.getHeight() ;
		var cp7_cy_1:Number = cp7 * pk_t + 1.0 + cp6 * pk_l ;
		var cp1_cy_cp2:Number = cp1 * pk_t + cpara[2] + cp0 * pk_l ;
		var cp4_cy_cp5:Number = cp4 * pk_t + cpara[5] + cp3 * pk_l ;
		for( var iy:int = 0 ; iy < out_h ; iy++ ) {
			var cp7_cy_1_cp6_cx:Number = cp7_cy_1 ;
			var cp1_cy_cp2_cp0_cx:Number = cp1_cy_cp2 ;
			var cp4_cy_cp5_cp3_cx:Number = cp4_cy_cp5 ;
			for( var ix:int = 0 ; ix < out_w ; ix++ ) {
				var d:Number = 1 / ( cp7_cy_1_cp6_cx ) ;
				var x:int = int(( ( cp1_cy_cp2_cp0_cx ) * d )) ;
				var y:int = int(( ( cp4_cy_cp5_cp3_cx ) * d )) ;
				if( x < 0 ) {
					x = 0 ;
				}
				else if( x >= in_w ) {
					x = in_w - 1 ;
				}
				
				if( y < 0 ) {
					y = 0 ;
				}
				else if( y >= in_h ) {
					y = in_h - 1 ;
				}
				
				i_in_reader.getPixel(x , y , rgb_tmp) ;
				cp7_cy_1_cp6_cx += cp6 ;
				cp1_cy_cp2_cp0_cx += cp0 ;
				cp4_cy_cp5_cp3_cx += cp3 ;
				out_reader.setPixel_1(ix , iy , rgb_tmp) ;
			}
			cp7_cy_1 += cp7 ;
			cp1_cy_cp2 += cp1 ;
			cp4_cy_cp5 += cp4 ;
		}
		return  ;
	}
	
	private function multiPixel_INT1D_X8R8G8B8_32( pk_l:int , pk_t:int , in_w:int , in_h:int , i_resolution:int , cpara:Vector.<Number> , i_in_reader:INyARRgbPixelReader , o_out:INyARRgbRaster ):void
	{
		//assert( ! (( o_out.isEqualBufferType(NyARBufferType.INT1D_X8R8G8B8_32) ) ) );
		var res_pix:int = i_resolution * i_resolution ;
		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp ;
		var pat_data:Vector.<int> = ((o_out.getBuffer()) as Vector.<int>) ;
		var cp0:Number = cpara[0] ;
		var cp3:Number = cpara[3] ;
		var cp6:Number = cpara[6] ;
		var cp1:Number = cpara[1] ;
		var cp4:Number = cpara[4] ;
		var cp7:Number = cpara[7] ;
		var cp2:Number = cpara[2] ;
		var cp5:Number = cpara[5] ;
		var out_w:int = o_out.getWidth() ;
		var out_h:int = o_out.getHeight() ;
		var p:int = ( out_w * out_h - 1 ) ;
		for( var iy:int = out_h - 1 ; iy >= 0 ; iy-- ) {
			for( var ix:int = out_w - 1 ; ix >= 0 ; ix-- ) {
				var r:int , g:int , b:int ;
				r = g = b = 0 ;
				var cy:int = pk_t + iy * i_resolution ;
				var cx:int = pk_l + ix * i_resolution ;
				var cp7_cy_1_cp6_cx_b:Number = cp7 * cy + 1.0 + cp6 * cx ;
				var cp1_cy_cp2_cp0_cx_b:Number = cp1 * cy + cp2 + cp0 * cx ;
				var cp4_cy_cp5_cp3_cx_b:Number = cp4 * cy + cp5 + cp3 * cx ;
				for( var i2y:int = i_resolution - 1 ; i2y >= 0 ; i2y-- ) {
					var cp7_cy_1_cp6_cx:Number = cp7_cy_1_cp6_cx_b ;
					var cp1_cy_cp2_cp0_cx:Number = cp1_cy_cp2_cp0_cx_b ;
					var cp4_cy_cp5_cp3_cx:Number = cp4_cy_cp5_cp3_cx_b ;
					for( var i2x:int = i_resolution - 1 ; i2x >= 0 ; i2x-- ) {
						/* final */ var d:Number = 1 / ( cp7_cy_1_cp6_cx ) ;
						var x:int = int(( ( cp1_cy_cp2_cp0_cx ) * d )) ;
						var y:int = int(( ( cp4_cy_cp5_cp3_cx ) * d )) ;
						if( x < 0 ) {
							x = 0 ;
						}
						else if( x >= in_w ) {
							x = in_w - 1 ;
						}
						
						if( y < 0 ) {
							y = 0 ;
						}
						else if( y >= in_h ) {
							y = in_h - 1 ;
						}
						
						i_in_reader.getPixel(x , y , rgb_tmp) ;
						r += rgb_tmp[0] ;
						g += rgb_tmp[1] ;
						b += rgb_tmp[2] ;
						cp7_cy_1_cp6_cx += cp6 ;
						cp1_cy_cp2_cp0_cx += cp0 ;
						cp4_cy_cp5_cp3_cx += cp3 ;
					}
					cp7_cy_1_cp6_cx_b += cp7 ;
					cp1_cy_cp2_cp0_cx_b += cp1 ;
					cp4_cy_cp5_cp3_cx_b += cp4 ;
				}
				r /= res_pix ;
				g /= res_pix ;
				b /= res_pix ;
				pat_data[p] = ( ( r & 0xff ) << 16 ) | ( ( g & 0xff ) << 8 ) | ( ( b & 0xff ) ) ;
				p-- ;
			}
		}
		return  ;
	}
	
	private function multiPixel_ANY( pk_l:int , pk_t:int , in_w:int , in_h:int , i_resolution:int , cpara:Vector.<Number> , i_in_reader:INyARRgbPixelReader , o_out:INyARRgbRaster ):void
	{
		var res_pix:int = i_resolution * i_resolution ;
		var rgb_tmp:Vector.<int> = this.__pickFromRaster_rgb_tmp ;
		var out_reader:INyARRgbPixelReader = o_out.getRgbPixelReader() ;
		var cp0:Number = cpara[0] ;
		var cp3:Number = cpara[3] ;
		var cp6:Number = cpara[6] ;
		var cp1:Number = cpara[1] ;
		var cp4:Number = cpara[4] ;
		var cp7:Number = cpara[7] ;
		var cp2:Number = cpara[2] ;
		var cp5:Number = cpara[5] ;
		var out_w:int = o_out.getWidth() ;
		var out_h:int = o_out.getHeight() ;
		for( var iy:int = out_h - 1 ; iy >= 0 ; iy-- ) {
			for( var ix:int = out_w - 1 ; ix >= 0 ; ix-- ) {
				var r:int , g:int , b:int ;
				r = g = b = 0 ;
				var cy:int = pk_t + iy * i_resolution ;
				var cx:int = pk_l + ix * i_resolution ;
				var cp7_cy_1_cp6_cx_b:Number = cp7 * cy + 1.0 + cp6 * cx ;
				var cp1_cy_cp2_cp0_cx_b:Number = cp1 * cy + cp2 + cp0 * cx ;
				var cp4_cy_cp5_cp3_cx_b:Number = cp4 * cy + cp5 + cp3 * cx ;
				for( var i2y:int = i_resolution - 1 ; i2y >= 0 ; i2y-- ) {
					var cp7_cy_1_cp6_cx:Number = cp7_cy_1_cp6_cx_b ;
					var cp1_cy_cp2_cp0_cx:Number = cp1_cy_cp2_cp0_cx_b ;
					var cp4_cy_cp5_cp3_cx:Number = cp4_cy_cp5_cp3_cx_b ;
					for( var i2x:int = i_resolution - 1 ; i2x >= 0 ; i2x-- ) {
						/* final */ var d:Number = 1 / ( cp7_cy_1_cp6_cx ) ;
						var x:int = int(( ( cp1_cy_cp2_cp0_cx ) * d )) ;
						var y:int = int(( ( cp4_cy_cp5_cp3_cx ) * d )) ;
						if( x < 0 ) {
							x = 0 ;
						}
						else if( x >= in_w ) {
							x = in_w - 1 ;
						}
						
						if( y < 0 ) {
							y = 0 ;
						}
						else if( y >= in_h ) {
							y = in_h - 1 ;
						}
						
						i_in_reader.getPixel(x , y , rgb_tmp) ;
						r += rgb_tmp[0] ;
						g += rgb_tmp[1] ;
						b += rgb_tmp[2] ;
						cp7_cy_1_cp6_cx += cp6 ;
						cp1_cy_cp2_cp0_cx += cp0 ;
						cp4_cy_cp5_cp3_cx += cp3 ;
					}
					cp7_cy_1_cp6_cx_b += cp7 ;
					cp1_cy_cp2_cp0_cx_b += cp1 ;
					cp4_cy_cp5_cp3_cx_b += cp4 ;
				}
				out_reader.setPixel_2(ix , iy , r / res_pix , g / res_pix , b / res_pix) ;
			}
		}
		return  ;
	}
	
}

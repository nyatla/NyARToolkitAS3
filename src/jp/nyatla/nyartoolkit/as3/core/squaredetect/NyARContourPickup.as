/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.squaredetect 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;
	public class NyARContourPickup
	{
		//巡回参照できるように、テーブルを二重化
		//                                           0  1  2  3  4  5  6  7   0  1  2  3  4  5  6
		protected static const _getContour_xdir:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0, -1, -1, -1 , 0, 1, 1, 1, 0, -1, -1]);
		protected static const _getContour_ydir:Vector.<int> = Vector.<int>([-1,-1, 0, 1, 1, 1, 0,-1 ,-1,-1, 0, 1, 1, 1, 0]);
		public function getContour_1(i_raster:NyARBinRaster,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			NyAS3Utils.assert(i_raster.isEqualBufferType(NyARBufferType.INT1D_BIN_8));
			var s:NyARIntSize=i_raster.getSize();
			return impl_getContour(i_raster,0,0,s.w-1,s.h-1,0,i_entry_x,i_entry_y,o_coord);
		}
		public function getContour_2(i_raster:NyARBinRaster,i_area:NyARIntRect,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			NyAS3Utils.assert(i_raster.isEqualBufferType(NyARBufferType.INT1D_BIN_8));
			return impl_getContour(i_raster,i_area.x,i_area.y,i_area.x+i_area.w-1,i_area.h+i_area.y-1,0,i_entry_x,i_entry_y,o_coord);
		}
		/**
		 * ラスタの指定点を基点に、輪郭線を抽出します。開始点は、輪郭の一部、かつ左上のエッジで有る必要があります。
		 * @param i_raster
		 * 輪郭線を抽出するラスタを指定します。
		 * @param i_th
		 * 輪郭とみなす暗点の敷居値を指定します。
		 * @param i_entry_x
		 * 輪郭抽出の開始点です。
		 * @param i_entry_y
		 * 輪郭抽出の開始点です。
		 * @param o_coord
		 * 輪郭点を格納する配列を指定します。i_array_sizeよりも大きなサイズの配列が必要です。
		 * @return
		 * 輪郭の抽出に成功するとtrueを返します。輪郭抽出に十分なバッファが無いと、falseになります。
		 * @throws NyARException
		 */
		public function getContour_3(i_raster:NyARGrayscaleRaster,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			NyAS3Utils.assert(i_raster.isEqualBufferType(NyARBufferType.INT1D_GRAY_8));
			var s:NyARIntSize=i_raster.getSize();
			return impl_getContour(i_raster,0,0,s.w-1,s.h-1,i_th,i_entry_x,i_entry_y,o_coord);
		}
		public function getContour_4(i_raster:NyARGrayscaleRaster,i_area:NyARIntRect,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			NyAS3Utils.assert(i_raster.isEqualBufferType(NyARBufferType.INT1D_GRAY_8));
			return impl_getContour(i_raster,i_area.x,i_area.y,i_area.x+i_area.w-1,i_area.h+i_area.y-1,i_th,i_entry_x,i_entry_y,o_coord);
		}
		
		/**
		 * 輪郭線抽出関数の実体です。
		 * @param i_raster
		 * @param i_l
		 * @param i_t
		 * @param i_r
		 * @param i_b
		 * @param i_th
		 * @param i_entry_x
		 * @param i_entry_y
		 * @param o_coord
		 * @return
		 * @throws NyARException
		 */
		private function impl_getContour( i_raster:INyARRaster , i_l:int , i_t:int , i_r:int , i_b:int , i_th:int , i_entry_x:int , i_entry_y:int , o_coord:NyARIntCoordinates ):Boolean
		{ 
			//assert( ! (( i_t <= i_entry_x ) ) );
			var coord:Vector.<NyARIntPoint2d> = o_coord.items ;
			var xdir:Vector.<int> = _getContour_xdir ;
			var ydir:Vector.<int> = _getContour_ydir ;
			var buf:Vector.<int> = ((i_raster.getBuffer()) as Vector.<int>) ;
			var width:int = i_raster.getWidth() ;
			var max_coord:int = o_coord.items.length ;
			var coord_num:int = 1 ;
			coord[0].x = i_entry_x ;
			coord[0].y = i_entry_y ;
			var dir:int = 5 ;
			var c:int = i_entry_x ;
			var r:int = i_entry_y ;
			for(  ;  ;  ) {
				dir = ( dir + 5 ) % 8 ;
				if( c > i_l && c < i_r && r > i_t && r < i_b ) {
					for(  ;  ;  ) {
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						dir++ ;
						if( buf[( r + ydir[dir] ) * width + ( c + xdir[dir] )] <= i_th ) {
							break ;
						}
						
						throw new NyARException(  ) ;
					}
				}
				else {
					for( i = 0 ; i < 8 ; i++ ) {
						x = c + xdir[dir] ;
						y = r + ydir[dir] ;
						if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
							if( buf[( y ) * width + ( x )] <= i_th ) {
								break ;
							}
							
						}
						
						dir++ ;
					}
					if( i == 8 ) {
						throw new NyARException(  ) ;
					}
					
				}
				c = c + xdir[dir] ;
				r = r + ydir[dir] ;
				coord[coord_num].x = c ;
				coord[coord_num].y = r ;
				var x:int, y:int,i:int;
				if( c == i_entry_x && r == i_entry_y ) {
					coord_num++ ;
					if( coord_num == max_coord ) {
						return false ;
					}
					
					dir = ( dir + 5 ) % 8 ;
					for( i = 0 ; i < 8 ; i++ ) {
						x= c + xdir[dir] ;
						y= r + ydir[dir] ;
						if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
							if( buf[( y ) * width + ( x )] <= i_th ) {
								break ;
							}
							
						}
						
						dir++ ;
					}
					if( i == 8 ) {
						throw new NyARException(  ) ;
					}
					
					c = c + xdir[dir] ;
					r = r + ydir[dir] ;
					if( coord[1].x == c && coord[1].y == r ) {
						o_coord.length = coord_num ;
						break ;
					}
					else {
						coord[coord_num].x = c ;
						coord[coord_num].y = r ;
					}
				}
				
				coord_num++ ;
				if( coord_num == max_coord ) {
					return false ;
				}
				
			}
			return true;
		}
	}
}
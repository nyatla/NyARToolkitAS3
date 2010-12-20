/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
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
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.core.squaredetect 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import org.libspark.flartoolkit.core.raster.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	
	/**
	 * OBJECT_AS3_BitmapData形式に対応したNyARContourPickup
	 */
	public class FLContourPickup extends NyARContourPickup
	{
		
		public function FLContourPickup() 
		{
		}
		public override function getContour_1(i_raster:NyARBinRaster,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			
			switch(i_raster.getBufferType()){
			case NyARBufferType.OBJECT_AS3_BitmapData:
				var s:NyARIntSize = i_raster.getSize();
				return impl_getContour_BitmapData_BIN(i_raster,0,0,s.w-1,s.h-1,0,i_entry_x,i_entry_y,o_coord);
			default:
				return super.getContour_1(i_raster,i_entry_x,i_entry_y,o_coord);
			}
		}
		public override function getContour_2(i_raster:NyARBinRaster,i_area:NyARIntRect,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			switch(i_raster.getBufferType()){
			case NyARBufferType.OBJECT_AS3_BitmapData:
				return impl_getContour_BitmapData_BIN(i_raster,i_area.x,i_area.y,i_area.x+i_area.w-1,i_area.h+i_area.y-1,0,i_entry_x,i_entry_y,o_coord);
			default:
				return super.getContour_2(i_raster,i_area,i_entry_x,i_entry_y,o_coord);
			}
		}
		public override function getContour_3(i_raster:NyARGrayscaleRaster,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			try{
			var s:NyARIntSize=i_raster.getSize();
			switch(i_raster.getBufferType()){
			case NyARBufferType.OBJECT_AS3_BitmapData:
				return impl_getContour_BitmapData(i_raster,0,0,s.w-1,s.h-1,i_th,i_entry_x,i_entry_y,o_coord);
			default:
				return super.getContour_3(i_raster,i_th,i_entry_x,i_entry_y,o_coord);
			}
			}catch (e:Error ) {
				
			}
			return false;
		}
		public override function getContour_4(i_raster:NyARGrayscaleRaster,i_area:NyARIntRect,i_th:int,i_entry_x:int,i_entry_y:int,o_coord:NyARIntCoordinates):Boolean
		{
			var s:NyARIntSize=i_raster.getSize();
			switch(i_raster.getBufferType()){
			case NyARBufferType.OBJECT_AS3_BitmapData:
				return impl_getContour_BitmapData(i_raster,i_area.x,i_area.y,i_area.x+i_area.w-1,i_area.h+i_area.y-1,i_th,i_entry_x,i_entry_y,o_coord);
			default:
				return super.getContour_4(i_raster,i_area,i_th,i_entry_x,i_entry_y,o_coord);
			}			
		}		
		private function impl_getContour_BitmapData(i_raster:INyARRaster , i_l:int , i_t:int , i_r:int , i_b:int , i_th:int , i_entry_x:int , i_entry_y:int , o_coord:NyARIntCoordinates ):Boolean
		{
			var coord:Vector.<NyARIntPoint2d> = o_coord.items ;
			var xdir:Vector.<int> = _getContour_xdir ;
			var ydir:Vector.<int> = _getContour_ydir ;
			var buf:BitmapData = BitmapData(i_raster.getBuffer());
			var width:int = i_raster.getWidth() ;
			var max_coord:int = o_coord.items.length ;
			var coord_num:int = 1 ;
			coord[0].x = i_entry_x ;
			coord[0].y = i_entry_y ;
			var dir:int = 5 ;
			var c:int = i_entry_x ;
			var r:int = i_entry_y ;
			for (  ;  ;  ) {
				dir = ( dir + 5 ) % 8 ;
				if( c > i_l && c < i_r && r > i_t && r < i_b ) {
					for(  ;  ;  ) {
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) <= i_th ) {
							break ;
						}
						TrackerView.megs(">>"+coord_num);
						throw new NyARException(  ) ;
					}
				}
				else {
					for( i = 0 ; i < 8 ; i++ ) {
						x = c + xdir[dir] ;
						y = r + ydir[dir] ;
						if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
							if((buf.getPixel(x,y ))<= i_th ) {
								break ;
							}
							
						}
						
						dir++ ;
					}
					if ( i == 8 ) {
						TrackerView.megs(">>>"+coord_num);
						throw new NyARException(  ) ;
					}
					
				}
				
				c = c + xdir[dir] ;
				r = r + ydir[dir] ;
				coord[coord_num].x = c ;
				coord[coord_num].y = r ;
				var x:int, y:int,i:int;
				if ( (c == i_entry_x) && (r == i_entry_y) ) {
					
					coord_num++ ;
					if( coord_num == max_coord ) {
						return false ;
					}
					
					dir = ( dir + 5 ) % 8 ;
					for( i = 0 ; i < 8 ; i++ ) {
						x= c + xdir[dir] ;
						y= r + ydir[dir] ;
						if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
							if((buf.getPixel(x,y)) <= i_th ) {
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
		private function impl_getContour_BitmapData_BIN(i_raster:NyARBinRaster , i_l:int , i_t:int , i_r:int , i_b:int , i_th:int , i_entry_x:int , i_entry_y:int , o_coord:NyARIntCoordinates ):Boolean
		{
			var coord:Vector.<NyARIntPoint2d> = o_coord.items ;
			var xdir:Vector.<int> = _getContour_xdir ;
			var ydir:Vector.<int> = _getContour_ydir ;
			var buf:BitmapData = BitmapData(i_raster.getBuffer());
			var width:int = i_raster.getWidth() ;
			var max_coord:int = o_coord.items.length ;
			var coord_num:int = 1 ;
			coord[0].x = i_entry_x ;
			coord[0].y = i_entry_y ;
			var dir:int = 5 ;
			var c:int = i_entry_x ;
			var r:int = i_entry_y ;
			for (  ;  ;  ) {
				dir = ( dir + 5 ) % 8 ;
				if( c > i_l && c < i_r && r > i_t && r < i_b ) {
					for(  ;  ;  ) {
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
							break ;
						}
						
						dir++ ;
						if((buf.getPixel( c + xdir[dir],( r + ydir[dir] ) )) >0 ) {
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
							if((buf.getPixel(x,y ))>0 ) {
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
				if ( (c == i_entry_x) && (r == i_entry_y) ) {
					
					coord_num++ ;
					if( coord_num == max_coord ) {
						return false ;
					}
					
					dir = ( dir + 5 ) % 8 ;
					for( i = 0 ; i < 8 ; i++ ) {
						x= c + xdir[dir] ;
						y= r + ydir[dir] ;
						if( x >= i_l && x <= i_r && y >= i_t && y <= i_b ) {
							if((buf.getPixel(x,y)&0xff)>0 ) {
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
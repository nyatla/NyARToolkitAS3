/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 *
 * The NyARToolkitCS is AS3 edition NyARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
 *
 * This work is based on the ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as publishe
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling 
{
	import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
	/**
	 * ...
	 * @author 
	 */
	public class NyARRleLabelFragmentInfoPtrStack extends NyARPointerStack 
	{
		public function NyARRleLabelFragmentInfoPtrStack( i_length:int )
		{ 
			this.initInstance(i_length) ;
			return  ;
		}
		
		public function sortByArea():void
		{ 
			var len:int = this._length ;
			if( len < 1 ) {
				return  ;
			}
			
			var h:int = len * 13 / 10 ;
			var item:Vector.<Object> = this._items ;
			for(  ;  ;  ) {
				var swaps:int = 0 ;
				for( var i:int = 0 ; i + h < len ; i++ ){
					if( ((NyARRleLabelFragmentInfo)(item[i + h])).area > item[i].area ){
						var temp:Object = item[i + h] ;
						item[i + h] = item[i] ;
						item[i] = temp ;
						swaps++ ;
					}
					
				}
				if( h == 1 ) {
					if( swaps == 0 ) {
						break ;
					}
					
				}
				else {
					h = h * 10 / 13 ;
				}
			}
		}
		
	}


}
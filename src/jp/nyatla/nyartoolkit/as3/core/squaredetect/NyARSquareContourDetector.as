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
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	public class NyARSquareContourDetector
	{
		/**
		 *
		 * @param i_raster
		 * @param i_callback
		 * @throws NyARException
		 */
		public function detectMarker_1(i_raster:NyARBinRaster):void
		{
			NyARException.trap("detectMarker not implemented.");
		}
		/**
		 * 通知ハンドラです。
		 * この関数は、detectMarker関数のコールバック関数として機能します。
		 * 継承先のクラスで、矩形の発見時の処理をここに記述してください。
		 * @param i_coord
		 * @param i_coor_num
		 * @param i_vertex_index
		 * @throws NyARException
		 */
		protected function onSquareDetect(i_coord:NyARIntCoordinates, i_vertex_index:Vector.<int>):void
		{
			NyARException.trap("onSquareDetect not implemented.");
		}
		
	}

}
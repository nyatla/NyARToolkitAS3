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
package jp.nyatla.nyartoolkit.as3.core.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.*;
	/**
	 * 遠近法を用いたPerspectiveパラメータを計算するクラスのテンプレートです。
	 * 任意頂点四角系と矩形から、遠近法の変形パラメータを計算します。
	 * このクラスはリファレンス実装のため、パフォーマンスが良くありません。実際にはNyARPerspectiveParamGenerator_O1を使ってください。
	 */	
	public class NyARPerspectiveParamGenerator 
	{
		protected var _local_x:int ; 
		protected var _local_y:int ; 
		public function NyARPerspectiveParamGenerator( i_local_x:int , i_local_y:int )
		{ 
			this._local_x = i_local_x ;
			this._local_y = i_local_y ;
			return;
		}
		public function getParam( i_size:NyARIntSize , i_vertex:Vector.<NyARIntPoint2d> , o_param:Vector.<Number>):Boolean
		{
			//assert( ! (( i_vertex.length == 4 ) ));
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param);
		}
		public function getParam_2( i_size:NyARIntSize , i_vertex:Vector.<NyARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_size.w , i_size.h , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_3( i_width:int , i_height:int , i_vertex:Vector.<NyARDoublePoint2d> , o_param:Vector.<Number>):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_4( i_width:int , i_height:int , i_vertex:Vector.<NyARIntPoint2d> , o_param:Vector.<Number> ):Boolean
		{
			return this.getParam_5(i_width , i_height , i_vertex[0].x , i_vertex[0].y , i_vertex[1].x , i_vertex[1].y , i_vertex[2].x , i_vertex[2].y , i_vertex[3].x , i_vertex[3].y , o_param) ;
		}
		
		public function getParam_5( i_dest_w:int , i_dest_h:int , x1:Number , y1:Number , x2:Number , y2:Number , x3:Number , y3:Number , x4:Number , y4:Number , o_param:Vector.<Number>):Boolean
		{
			throw new NyARException("getParam not implemented.");
		}
		
	}


}
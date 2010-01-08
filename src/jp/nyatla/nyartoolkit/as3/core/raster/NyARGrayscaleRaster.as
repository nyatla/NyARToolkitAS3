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
package jp.nyatla.nyartoolkit.as3.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	public final class NyARGrayscaleRaster extends NyARRaster_BasicClass
	{

		protected var _ref_buf:Vector.<int>;
		private var _buffer_reader:INyARBufferReader;
		
		public function NyARGrayscaleRaster(i_width:int,i_height:int)
		{
			super(new NyARIntSize(i_width,i_height));
			this._ref_buf = new Vector.<int>(i_height*i_width);
			this._buffer_reader=new NyARBufferReader(this._ref_buf,INyARBufferReader.BUFFERFORMAT_INT1D_GRAY_8);
		}
		public override function getBufferReader():INyARBufferReader
		{
			return this._buffer_reader;
		}
		/**
		 * 4近傍の画素ベクトルを取得します。
		 * 0,1,0
		 * 1,x,1
		 * 0,1,0
		 * @param i_raster
		 * @param x
		 * @param y
		 * @param o_v
		 */
		public function getPixelVector4(x:int,y:int,o_v:NyARIntPoint2d):void
		{
			var buf:Vector.<int>=this._ref_buf;
			var w:int=this._size.w;
			var idx:int=w*y+x;
			o_v.x=buf[idx+1]-buf[idx-1];
			o_v.y=buf[idx+w]-buf[idx-w];
		}
		/**
		 * 8近傍画素ベクトル
		 * 1,2,1
		 * 2,x,2
		 * 1,2,1
		 * @param i_raster
		 * @param x
		 * @param y
		 * @param o_v
		 */
		public function getPixelVector8(x:int,y:int,o_v:NyARIntPoint2d):void
		{
			var buf:Vector.<int>=this._ref_buf;
			var s:NyARIntSize=this._size;
			var idx_0:int =s.w*y+x;
			var idx_p1:int=idx_0+s.w;
			var idx_m1:int=idx_0-s.w;
			var b:int=buf[idx_m1-1];
			var d:int=buf[idx_m1+1];
			var h:int=buf[idx_p1-1];
			var f:int=buf[idx_p1+1];
			o_v.x=buf[idx_0+1]-buf[idx_0-1]+(d-b+f-h)/2;
			o_v.y=buf[idx_p1]-buf[idx_m1]+(f-d+h-b)/2;
		}
		
		public function copyFrom(i_input:NyARGrayscaleRaster):void
		{
			var out_buf:Vector.<int> = Vector.<int>(this._ref_buf);
			var in_buf:Vector.<int> = Vector.<int>(i_input._ref_buf);
			ArrayUtils.copyInt(in_buf,0,out_buf,0,this._size.h*this._size.w);
			return;
		}	
	}
}
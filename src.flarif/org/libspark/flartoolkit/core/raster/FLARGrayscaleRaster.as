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
package org.libspark.flartoolkit.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.*;
	import org.libspark.flartoolkit.*;
	import flash.display.*;
	import flash.geom.*;
	/**
	 * このRasterは、0x0000ff - 0x000000の値で、グレースケール画像を表現します。
	 */
	public final class FLARGrayscaleRaster extends NyARGrayscaleRaster
	{
		public function FLARGrayscaleRaster(i_width:int,i_height:int,i_is_alloc:Boolean)
		{
			super(i_width,i_height,NyARBufferType.OBJECT_AS3_BitmapData,i_is_alloc);
		}
		protected override function initInstance(i_size:NyARIntSize,i_buf_type:int,i_is_alloc:Boolean):Boolean
		{
			if (i_buf_type != NyARBufferType.OBJECT_AS3_BitmapData) {
				throw new FLARException();
			}
			this._buf = i_is_alloc?new BitmapData(i_size.w,i_size.h,false):null;
			return true;
		}
		public override function copyTo(i_left:int,i_top:int,i_skip:int,o_output:NyARGrayscaleRaster):void
		{
			//assert (this.getSize().isInnerSize(i_left + o_output.getWidth() * i_skip, i_top+ o_output.getHeight() * i_skip));		
			//assert (this.isEqualBufferType(o_output.getBufferType()));
			var d:BitmapData = BitmapData(o_output.getBuffer());
			var s:BitmapData = BitmapData(this.getBuffer());
			var mat:Matrix = new Matrix();
			mat.a = mat.d = (1.0 / (i_skip));
			mat.tx = i_left;
			mat.ty = i_top;
			d.draw(s, mat,null,null,null,false);
			return;
		}		
	}
}